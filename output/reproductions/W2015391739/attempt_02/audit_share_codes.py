"""Bounded CRSP share-code and co-occurrence audit for A2 company-MVE inputs.

Reads only the final handoff's PERMCO-month keys plus the catalog-listed MSF
and MSENAMES source tables; writes aggregate-only results under this attempt.
No construction or model output is changed.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np
import pandas as pd
import pyreadstat

HERE = Path(__file__).resolve().parent
REG_DTA = HERE / "data/basu_replication_1963_1990/reg.dta"
MSF_PATH = Path("/storage/sas/base/crsp/a_stock/msf.sas7bdat")
NAMES_PATH = Path("/storage/sas/base/crsp/a_stock/msenames.sas7bdat")
OUTPUT = HERE / "share_code_audit.json"
CHUNK_ROWS = 200_000

# Per the CRSP guide's first-digit and second-digit definitions, 10/11/12 are
# ordinary common shares (general, need-not-be-further-defined, foreign); 18
# are REIT shares. 14/15 and 44/45 are closed-end/UIT subtypes, not ordinary
# common shares. The broader 1x or 4x families are therefore not a clean screen.
COMMON_OR_REIT_CODES = {10, 11, 12, 18}


def sas_date_month(values: pd.Series) -> pd.PeriodIndex:
    return pd.to_datetime(values, unit="D", origin="1960-01-01").dt.to_period("M")


def json_value(value):
    if isinstance(value, (np.integer,)):
        return int(value)
    if isinstance(value, (np.floating,)):
        return None if np.isnan(value) else float(value)
    if isinstance(value, pd.Period):
        return str(value)
    return value


def group_for_code(code):
    if pd.isna(code):
        return "missing_share_code"
    code = int(code)
    first, second = divmod(code, 10)
    if code in {10, 11, 12}:
        return "ordinary_common_shares"
    if code == 18:
        return "REIT_shares"
    if second in {4, 5} and first in {1, 4, 7}:
        return "closed_end_fund_or_UIT_subtype"
    if first == 2:
        return "certificates_or_Americus_components"
    if first == 3:
        return "ADRs"
    if first == 4:
        return "shares_of_beneficial_interest"
    if first == 7 and second == 3:
        return "ETFs_or_depositary_units"
    if first == 7:
        return "other_7x_units"
    return "other_share_code"


def clean_id(values: pd.Series) -> pd.Series:
    return values.astype("string").str.strip().replace("", pd.NA)


def main() -> None:
    handoff = pd.read_stata(
        REG_DTA,
        columns=["gvkey", "fyear", "permno", "permco", "anchor_mth", "company_mve_th"],
    )
    handoff["permco_i"] = pd.to_numeric(handoff["permco"], errors="coerce").astype("int64")
    handoff["anchor_month"] = sas_date_month(handoff["anchor_mth"])
    company_keys = (
        handoff.groupby(["permco_i", "anchor_month"], as_index=False)
        .agg(
            sample_mve_min=("company_mve_th", "min"),
            sample_mve_max=("company_mve_th", "max"),
            sample_rows=("company_mve_th", "size"),
        )
    )
    key_index = pd.MultiIndex.from_frame(
        company_keys[["permco_i", "anchor_month"]].rename(
            columns={"permco_i": "PERMCO", "anchor_month": "month"}
        )
    )
    permcos = set(company_keys["permco_i"].tolist())
    months = set(company_keys["anchor_month"].tolist())

    meta = pyreadstat.read_sas7bdat(
        MSF_PATH,
        metadataonly=True,
        usecols=["PERMNO", "PERMCO", "DATE", "CUSIP", "PRC", "SHROUT"],
    )[1]
    total_msf_rows = int(meta.number_rows)
    matched_parts: list[pd.DataFrame] = []
    rows_scanned = 0
    chunks_read = 0
    for offset in range(0, total_msf_rows, CHUNK_ROWS):
        chunk, _ = pyreadstat.read_sas7bdat(
            MSF_PATH,
            usecols=["PERMNO", "PERMCO", "DATE", "CUSIP", "PRC", "SHROUT"],
            dates_as_pandas_datetime=True,
            row_offset=offset,
            row_limit=min(CHUNK_ROWS, total_msf_rows - offset),
        )
        if chunk.empty:
            break
        chunks_read += 1
        rows_scanned += len(chunk)
        chunk["PERMCO"] = pd.to_numeric(chunk["PERMCO"], errors="coerce")
        part = chunk.loc[chunk["PERMCO"].isin(permcos)].copy()
        if part.empty:
            continue
        part["DATE"] = pd.to_datetime(part["DATE"])
        part["month"] = part["DATE"].dt.to_period("M")
        part = part.loc[part["month"].isin(months)].copy()
        if part.empty:
            continue
        part["PERMCO"] = part["PERMCO"].astype("int64")
        keep = pd.MultiIndex.from_arrays([part["PERMCO"], part["month"]]).isin(key_index)
        part = part.loc[keep].copy()
        if part.empty:
            continue
        part["PERMNO"] = pd.to_numeric(part["PERMNO"], errors="coerce")
        part["issue_mve_th"] = part["PRC"].abs() * part["SHROUT"]
        matched_parts.append(part[["PERMCO", "month", "PERMNO", "DATE", "CUSIP", "issue_mve_th"]])

    if not matched_parts:
        raise RuntimeError("No MSF rows matched final company-month keys")
    msf = pd.concat(matched_parts, ignore_index=True)
    issues = (
        msf.groupby(["PERMCO", "month", "PERMNO"], as_index=False, dropna=False)
        .agg(
            quote_date=("DATE", "max"),
            issue_mve_th=("issue_mve_th", "max"),
            msf_rows=("DATE", "size"),
            msf_quote_dates=("DATE", "nunique"),
            msf_cusip=("CUSIP", "last"),
        )
    )
    issues["issue_id"] = np.arange(len(issues), dtype="int64")

    # Use each PERMNO's name-history row effective on the actual MSF quote date.
    names, names_meta = pyreadstat.read_sas7bdat(
        NAMES_PATH,
        usecols=["PERMNO", "PERMCO", "NAMEDT", "NAMEENDT", "SHRCD", "NCUSIP", "CUSIP", "SHRCLS", "COMNAM", "TICKER"],
        dates_as_pandas_datetime=True,
    )
    names["PERMNO"] = pd.to_numeric(names["PERMNO"], errors="coerce")
    names["PERMCO"] = pd.to_numeric(names["PERMCO"], errors="coerce")
    names["NAMEDT"] = pd.to_datetime(names["NAMEDT"])
    names["NAMEENDT"] = pd.to_datetime(names["NAMEENDT"])
    names = names.loc[names["PERMNO"].isin(issues["PERMNO"].unique())].copy()
    joined = issues.merge(names, on="PERMNO", how="left", suffixes=("_msf", "_name"))
    active = (
        joined["NAMEDT"].notna()
        & (joined["NAMEDT"] <= joined["quote_date"])
        & (joined["NAMEENDT"].isna() | (joined["NAMEENDT"] >= joined["quote_date"]))
    )
    effective = joined.loc[active].copy()
    active_counts = effective.groupby("issue_id").size().rename("effective_name_rows")
    issues = issues.merge(active_counts, left_on="issue_id", right_index=True, how="left")
    issues["effective_name_rows"] = issues["effective_name_rows"].fillna(0).astype("int64")
    unique_ids = set(issues.loc[issues["effective_name_rows"] == 1, "issue_id"])
    unique_names = effective.loc[effective["issue_id"].isin(unique_ids)].copy()
    name_fields = ["issue_id", "SHRCD", "PERMCO_name", "NAMEDT", "NAMEENDT", "NCUSIP", "CUSIP", "SHRCLS", "COMNAM", "TICKER"]
    issues = issues.merge(unique_names[name_fields], on="issue_id", how="left")
    issues["SHRCD"] = pd.to_numeric(issues["SHRCD"], errors="coerce")
    for field in ["msf_cusip", "NCUSIP", "CUSIP", "SHRCLS", "COMNAM", "TICKER"]:
        issues[field + "_clean"] = clean_id(issues[field])

    issues["share_group"] = issues["SHRCD"].map(group_for_code)
    issues.loc[issues["effective_name_rows"] == 0, "share_group"] = "no_effective_name"
    issues.loc[issues["effective_name_rows"] > 1, "share_group"] = "ambiguous_effective_name"
    issues.loc[(issues["effective_name_rows"] == 1) & issues["SHRCD"].isna(), "share_group"] = "missing_share_code"
    issues["common_or_REIT"] = (
        (issues["effective_name_rows"] == 1) & issues["SHRCD"].isin(COMMON_OR_REIT_CODES)
    )
    issues["any_1x_code"] = (
        (issues["effective_name_rows"] == 1) & (issues["SHRCD"].floordiv(10) == 1)
    )

    company_totals = (
        issues.groupby(["PERMCO", "month"], as_index=False)
        .agg(
            rebuilt_mve_th=("issue_mve_th", "sum"),
            n_issue_months=("PERMNO", "nunique"),
            has_common_or_REIT=("common_or_REIT", "max"),
            has_any_1x_code=("any_1x_code", "max"),
            n_common_or_REIT_issue_months=("common_or_REIT", "sum"),
        )
    )
    keys = company_keys.rename(columns={"permco_i": "PERMCO", "anchor_month": "month"})
    company_totals = keys.merge(company_totals, on=["PERMCO", "month"], how="left")
    company_totals["mve_delta"] = company_totals["rebuilt_mve_th"] - company_totals["sample_mve_min"]
    if company_totals["rebuilt_mve_th"].isna().any():
        raise RuntimeError("At least one final company-month has no reconstructed issue total")

    # Count each exact code and whether it appears with common/REIT shares
    # shares. This is issuer co-occurrence only; it does not imply a duplicate.
    code_month = (
        issues.loc[issues["effective_name_rows"] == 1]
        .groupby(["PERMCO", "month", "SHRCD"], as_index=False)
        .agg(code_mve_th=("issue_mve_th", "sum"), code_issue_months=("issue_id", "nunique"))
        .merge(
            company_totals[["PERMCO", "month", "has_common_or_REIT", "has_any_1x_code", "n_common_or_REIT_issue_months"]],
            on=["PERMCO", "month"],
            how="left",
        )
    )
    code_stats = (
        code_month.groupby("SHRCD", dropna=False)
        .agg(
            company_months=("month", "size"),
            issue_months=("code_issue_months", "sum"),
            issue_mve_th=("code_mve_th", "sum"),
            company_months_with_common_or_REIT=("has_common_or_REIT", "sum"),
            company_months_with_any_1x=("has_any_1x_code", "sum"),
            issue_mve_with_common_or_REIT_th=("code_mve_th", lambda s: float(s[code_month.loc[s.index, "has_common_or_REIT"]].sum())),
        )
        .reset_index()
        .sort_values("SHRCD")
    )
    code_stats["company_months_without_common_or_REIT"] = (
        code_stats["company_months"] - code_stats["company_months_with_common_or_REIT"]
    )
    code_stats["company_months_without_any_1x"] = (
        code_stats["company_months"] - code_stats["company_months_with_any_1x"]
    )
    code_stats["issue_mve_without_common_or_REIT_th"] = (
        code_stats["issue_mve_th"] - code_stats["issue_mve_with_common_or_REIT_th"]
    )

    # For certificates and ADRs coexisting with any 1x security, compare dated
    # identifiers. Keep 10/11/12/18 ordinary common/REIT rows distinct from
    # 14/15 closed-end/UIT subtypes in the co-occurrence summary.
    target_mask = issues["SHRCD"].isin([20, 21, 30, 31]) & (issues["effective_name_rows"] == 1)
    target = issues.loc[target_mask].copy()
    one_x = issues.loc[issues["any_1x_code"]].copy()
    pairs = target.merge(
        one_x,
        on=["PERMCO", "month"],
        suffixes=("_target", "_ordinary"),
        how="inner",
    )
    if len(pairs):
        same_ncusip = (
            pairs["NCUSIP_clean_target"].notna()
            & (pairs["NCUSIP_clean_target"] == pairs["NCUSIP_clean_ordinary"])
        )
        same_cusip_header = (
            pairs["CUSIP_clean_target"].notna()
            & (pairs["CUSIP_clean_target"] == pairs["CUSIP_clean_ordinary"])
        )
        same_msf_cusip = (
            pairs["msf_cusip_clean_target"].notna()
            & (pairs["msf_cusip_clean_target"] == pairs["msf_cusip_clean_ordinary"])
        )
        same_share_class = (
            pairs["SHRCLS_clean_target"].notna()
            & (pairs["SHRCLS_clean_target"] == pairs["SHRCLS_clean_ordinary"])
        )
        pair_rows = pd.DataFrame({
            "target_issue_id": pairs["issue_id_target"],
            "target_shrcd": pairs["SHRCD_target"],
            "coexisting_1x_shrcd": pairs["SHRCD_ordinary"],
            "same_ncusip": same_ncusip,
            "same_cusip_header": same_cusip_header,
            "same_msf_cusip": same_msf_cusip,
            "same_share_class": same_share_class,
        })
        pair_any1x = (
            pair_rows.groupby("target_issue_id", as_index=False)
            .agg(
                same_ncusip_any_1x=("same_ncusip", "max"),
                same_cusip_header_any_1x=("same_cusip_header", "max"),
                same_msf_cusip_any_1x=("same_msf_cusip", "max"),
                same_share_class_any_1x=("same_share_class", "max"),
            )
        )
        pair_common = pair_rows.loc[pair_rows["coexisting_1x_shrcd"].isin(COMMON_OR_REIT_CODES)]
        pair_common = (
            pair_common.groupby("target_issue_id", as_index=False)
            .agg(
                same_ncusip_ordinary=("same_ncusip", "max"),
                same_cusip_header_ordinary=("same_cusip_header", "max"),
                same_msf_cusip_ordinary=("same_msf_cusip", "max"),
                same_share_class_ordinary=("same_share_class", "max"),
            )
        )
        pair_by_code = (
            pair_rows.groupby(["target_issue_id", "target_shrcd", "coexisting_1x_shrcd"], as_index=False)
            .agg(
                same_ncusip=("same_ncusip", "max"),
                same_cusip_header=("same_cusip_header", "max"),
                same_msf_cusip=("same_msf_cusip", "max"),
                same_share_class=("same_share_class", "max"),
            )
        )
        pair_by_code_summary = (
            pair_by_code.groupby(["target_shrcd", "coexisting_1x_shrcd"], as_index=False)
            .agg(
                target_issue_months=("target_issue_id", "nunique"),
                same_ncusip_target_months=("same_ncusip", "sum"),
                same_cusip_header_target_months=("same_cusip_header", "sum"),
                same_msf_cusip_target_months=("same_msf_cusip", "sum"),
                same_share_class_target_months=("same_share_class", "sum"),
            )
        )
        target_overlap = target.merge(
            company_totals[["PERMCO", "month", "has_common_or_REIT", "has_any_1x_code"]],
            on=["PERMCO", "month"],
            how="left",
        )
        target_overlap = target_overlap.merge(pair_any1x, left_on="issue_id", right_on="target_issue_id", how="left")
        target_overlap = target_overlap.merge(pair_common, left_on="issue_id", right_on="target_issue_id", how="left", suffixes=("", "_common"))
        target_overlap_summary = (
            target_overlap.groupby("SHRCD", as_index=False)
            .agg(
                target_issue_months=("issue_id", "nunique"),
                target_issue_months_with_any_1x=("has_any_1x_code", "sum"),
                target_issue_months_with_common_or_REIT=("has_common_or_REIT", "sum"),
                same_ncusip_matches_any_1x=("same_ncusip_any_1x", "sum"),
                same_cusip_header_matches_any_1x=("same_cusip_header_any_1x", "sum"),
                same_msf_cusip_matches_any_1x=("same_msf_cusip_any_1x", "sum"),
                same_share_class_matches_any_1x=("same_share_class_any_1x", "sum"),
                same_ncusip_matches_ordinary=("same_ncusip_ordinary", "sum"),
                same_cusip_header_matches_ordinary=("same_cusip_header_ordinary", "sum"),
                same_msf_cusip_matches_ordinary=("same_msf_cusip_ordinary", "sum"),
                same_share_class_matches_ordinary=("same_share_class_ordinary", "sum"),
            )
        )
    else:
        target_overlap_summary = pd.DataFrame(columns=["SHRCD", "target_issue_months_with_any_1x", "target_issue_months_with_common_or_REIT"])
        pair_by_code_summary = pd.DataFrame(columns=["target_shrcd", "coexisting_1x_shrcd", "target_issue_months", "same_ncusip_target_months", "same_cusip_header_target_months", "same_msf_cusip_target_months", "same_share_class_target_months"])

    company_totals["any_2x_3x_mve_th"] = 0.0
    company_totals["any_20_21_30_31_mve_th"] = 0.0
    company_totals["any_closed_end_UIT_mve_th"] = 0.0
    group_definitions = {
        "certificates_2x": issues["SHRCD"].fillna(-1).astype(int).map(lambda c: c // 10 == 2),
        "ADRs_3x": issues["SHRCD"].fillna(-1).astype(int).map(lambda c: c // 10 == 3),
        "shares_of_beneficial_interest_4x": issues["SHRCD"].fillna(-1).astype(int).map(lambda c: c // 10 == 4),
        "units_and_ETFs_7x": issues["SHRCD"].fillna(-1).astype(int).map(lambda c: c // 10 == 7),
        "closed_end_or_UIT_codes": issues["SHRCD"].isin([14, 15, 44, 45, 74, 75]),
        "ADR_and_certificate_codes_20_21_30_31": issues["SHRCD"].isin([20, 21, 30, 31]),
    }
    family_totals = {}
    for label, mask in group_definitions.items():
        part = issues.loc[mask]
        by_company = part.groupby(["PERMCO", "month"], as_index=False).agg(family_mve_th=("issue_mve_th", "sum"))
        affected = company_totals.merge(by_company, on=["PERMCO", "month"], how="left")
        affected["family_mve_th"] = affected["family_mve_th"].fillna(0.0)
        family_totals[label] = {
            "issue_months": int(mask.sum()),
            "company_months_with_family": int((affected["family_mve_th"] > 0).sum()),
            "final_handoff_rows_with_family": int(
                handoff.merge(
                    affected[["PERMCO", "month", "family_mve_th"]],
                    left_on=["permco_i", "anchor_month"],
                    right_on=["PERMCO", "month"],
                    how="left",
                )["family_mve_th"].gt(0).sum()
            ),
            "family_mve_th": float(affected["family_mve_th"].sum()),
            "mean_company_mve_share": float((affected["family_mve_th"] / affected["rebuilt_mve_th"]).mean()),
            "max_company_mve_share": float((affected["family_mve_th"] / affected["rebuilt_mve_th"]).max()),
            "company_months_with_family_and_common_or_REIT": int(
                ((affected["family_mve_th"] > 0) & affected["has_common_or_REIT"]).sum()
            ),
            "company_months_with_family_without_common_or_REIT": int(
                ((affected["family_mve_th"] > 0) & ~affected["has_common_or_REIT"]).sum()
            ),
        }

    name_permco_mismatch = (
        (issues["effective_name_rows"] == 1)
        & issues["PERMCO_name"].notna()
        & (issues["PERMCO_name"].astype("Int64") != issues["PERMCO"].astype("Int64"))
    )
    groups = (
        issues.groupby("share_group", dropna=False)
        .agg(issue_months=("issue_id", "nunique"), issue_mve_th=("issue_mve_th", "sum"))
        .reset_index()
        .sort_values("share_group")
    )
    result = {
        "audit_scope": "final A2 company-month keys; each constituent matched to the MSENAMES row effective at actual MSF DATE; no model construction changes",
        "interpretation": {
            "common_or_REIT_codes": sorted(COMMON_OR_REIT_CODES),
            "cooccurrence_definition": "another issue under the same PERMCO and month carries SHRCD 10/11/12/18; issuer association alone does not prove duplicate claims",
            "identifiers_compared": "effective MSENAMES NCUSIP, CUSIP header, share class, and MSF CUSIP; equality does not establish ADR ratio or valuation equivalence",
            "security_type_source": "CRSP Stock and Index Data Description Guide, physical PDF p. 115 (printed p. 111): first digit 2 certificates/Americus, 3 ADRs, 4 SBIs, 7 units/ETFs; second digit 4 closed-end funds/UITs, 5 foreign closed-end funds, 8 REITs",
        },
        "sample": {
            "final_handoff_rows": int(len(handoff)),
            "gvkey_fyear_duplicates": int(handoff.duplicated(["gvkey", "fyear"]).sum()),
            "final_company_months": int(len(company_keys)),
            "company_months_with_different_stored_mve": int((company_keys["sample_mve_min"] != company_keys["sample_mve_max"]).sum()),
            "constituent_issue_months": int(len(issues)),
            "duplicate_msf_rows_within_issue_month": int((issues["msf_rows"] > 1).sum()),
            "issue_months_with_multiple_quote_dates": int((issues["msf_quote_dates"] > 1).sum()),
        },
        "name_match": {
            "unique_effective_rows": int((issues["effective_name_rows"] == 1).sum()),
            "missing_effective_rows": int((issues["effective_name_rows"] == 0).sum()),
            "ambiguous_effective_rows": int((issues["effective_name_rows"] > 1).sum()),
            "unique_rows_with_missing_shrcd": int(((issues["effective_name_rows"] == 1) & issues["SHRCD"].isna()).sum()),
            "unique_rows_with_missing_nameenddt": int(((issues["effective_name_rows"] == 1) & issues["NAMEENDT"].isna()).sum()),
            "unique_rows_with_name_permco_mismatch": int(name_permco_mismatch.sum()),
        },
        "company_mve_reconciliation": {
            "company_months": int(len(company_totals)),
            "rebuilt_totals_matching_handoff_tolerance_1e_6": int((company_totals["mve_delta"].abs() <= 1e-6).sum()),
            "total_issue_mve_th": float(company_totals["rebuilt_mve_th"].sum()),
            "common_or_REIT_company_months": int(company_totals["has_common_or_REIT"].sum()),
            "company_months_without_common_or_REIT": int((~company_totals["has_common_or_REIT"]).sum()),
            "unresolved_name_mve_th": float(issues.loc[issues["effective_name_rows"] != 1, "issue_mve_th"].sum()),
        },
        "by_share_code": [
            {k: json_value(v) for k, v in row.items()}
            for row in code_stats.to_dict("records")
        ],
        "by_code_family": [
            {k: json_value(v) for k, v in row.items()}
            for row in groups.to_dict("records")
        ],
        "security_type_sensitivity": family_totals,
        "certificates_and_ADRs_vs_common_or_REIT": [
            {k: json_value(v) for k, v in row.items()}
            for row in target_overlap_summary.to_dict("records")
        ],
        "certificates_and_ADRs_by_coexisting_1x_code": [
            {k: json_value(v) for k, v in row.items()}
            for row in pair_by_code_summary.to_dict("records")
        ],
        "source": {
            "msf_path": str(MSF_PATH),
            "msf_catalog_rows": total_msf_rows,
            "msf_rows_scanned": rows_scanned,
            "msf_chunks_read": chunks_read,
            "msenames_path": str(NAMES_PATH),
            "msenames_catalog_rows": int(names_meta.number_rows),
            "msenames_rows_for_final_constituent_permnos": int(len(names)),
            "msenames_fields_used": ["SHRCD", "NAMEDT", "NAMEENDT", "PERMCO", "NCUSIP", "CUSIP", "SHRCLS", "COMNAM", "TICKER"],
        },
    }
    OUTPUT.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
