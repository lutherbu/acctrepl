# Patch proposal: jar-5069f30b0ba0

Relative Valuation with Machine Learning

DOI: 10.1111/1475-679X.12464

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented empirical procedures in the supplied Internet Appendix only, including its variable definitions, ML sample splitting, valuation comparisons, robustness branches, portfolio outputs, and SHAP results; this scope does not add an independently reconstructed main-paper workflow.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 1/12464 - Relative-Valuation-with-Machine-Learning/gl-online-appendix.pdf",
      "sha256": "23c636cf38d6d052aa39078facaf8ca800c6c81b96760c747c82e57f27f0b41e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "42a35925e4b6bdf59a1d01b37b27061e91811c3962437ebb1889eca1d6003a4e"
}
```

## Proposed actions

### obtain_workflow_and_panel_specification: Obtain the author-provided execution materials and complete input/producer specification before attempting the appendix workflow; preserve the appendix's documented branches and do not reconstruct from published result tables.

Scopes: full_pipeline. Type: clarification. Certainty: blocked.
Addresses: firm_month_inputs, no_executable_code, workflow_inputs_unresolved
Evidence: release_inventory, monthly_sample_and_blocks, missing_main_text_definitions, cart_software_and_recipe, quarterly_sales_and_debt_inputs, alternative_split_branch, hp_benchmark_window, new_economy_classification, equal_weighted_portfolio_method, shap_variable_importance, crsp_catalog_candidates, crsp_msfv2_row1_probe, scikit_learn_installed_metadata, original_formula_pages

Preparation / proposed procedure:

1. Request the executable source or, if the authors intentionally provide a manual workflow, the complete ordered procedure and producer-to-consumer handoffs for every appendix branch; identify any author-prepared analysis panel or exact supported source route.
2. Request the referenced main-text Table 1 sample definition, Table 2 model/variable definitions, Table 3 portfolio methodology, and the pre-selected random seed; specify the firm/security identifiers, record unit, joins, filters, monthly accounting alignment, output fields, and full author panel schema.
3. For the CRSP market-equity input, map the author's crsp_market_equity measure to a specified monthly CRSP table and adjustment rule. The local catalog lists CRSP.MSF and CRSP.MSF_V2; the latter is readable with PERMNO, MthCalDt, and MthCap in a one-row probe, but the appendix does not establish which product/version, security-to-firm aggregation, field mapping, population, or history is intended.
4. Resolve the known v2s sales window as current plus the preceding three saleqt quarters and preserve the appendix's missing-debt convention (dltt, dlc, and pstk each zero when missing); request the exact source fields, quarter-to-month match, and any other variable-construction history rather than guessing them.
5. Request the base GBM implementation, software/version, model settings, and validation search; the appendix names only the CART-side scikit-learn DecisionTreeRegressor/SimpleImputer recipe (median imputation, max_depth 3–6, validation choice and final fit), and specifies 20 trees for the separate 80/20 robustness branch.
6. Account for the appendix's HP model inputs (available from 1989 only), New Economy rule and required IPO/first-report data, equal-weighted NYSE market-cap cutoff, and FF6 plus seven anomaly-cluster portfolio benchmark inputs; preserve all branches and clarify missing source/producer contracts.
7. Use the original PDF pages 9–10 as the notation reference for the prediction-to-equity-value formulas if creating working notes; keep those notes separate and do not edit or replace the supplied PDF.

Validation to perform later:

- After materials are supplied, compare the author panel's record unit, identifiers, source columns, period/history, formula inputs, and target/predictor fields against the complete author contract; use a bounded metadata probe only for the exact permitted files.
- Confirm all appendix analyses and robustness branches have an identified producer, compatible input route, and ordered handoff before any separately authorized run; do not execute estimators as part of this feasibility review.


## Remaining issues and prerequisites

- no_executable_code [unresolved; full_pipeline]: Full review of the only supplied 1,117-line PDF found a substantive empirical appendix with variable definitions, formulas, split/model procedures, and reported tables/figures, but no executable or embedded program. Accordingly, the package has no launch driver or runnable entry point; the appendix's narrative methods remain workflow evidence, not executable code.
- workflow_inputs_unresolved [unresolved; full_pipeline]: The appendix provides substantive procedures but not the complete producer/consumer workflow or its observation-level inputs. It refers to main-text Tables 1, 2, and 3 and a pre-selected seed without supplying those specifications here. Known data needs include CRSP market equity, book/asset/debt/accounting measures, three prior quarterly sales observations for annualized sales, firm/month alignment, group classifications, and inputs for all included model-comparison and portfolio branches. The five-block split, 80/20 robustness split with 20 trees, 1989-start HP benchmark, New Economy classification, equal-weighted NYSE size cutoff, and SHAP outputs are documented, but their missing source schemas, full GBM settings/implementation, exact identifiers, histories, and cross-stage handoffs cannot be resolved from this PDF. The local CRSP candidate is readable only in a one-row probe and is not a verified compatible panel route. Do not infer an unprovided full-paper implementation or independent raw-data reconstruction.
- firm_month_inputs [undetermined]: An author-prepared firm-month analysis panel and its required construction inputs for the appendix's traditional-model comparisons, ML targets/predictors, sample splits, valuation-error groups, and portfolio/importance outputs. The appendix specifies 480 monthly cross-sections from January 1980 through December 2019 and some variable formulas; for the v2s equity-value translation it annualizes sales from the current and preceding three saleqt quarters, and it sets missing dltt, dlc, or pstk debt components to zero. It does not provide a complete source-panel schema, firm identifiers, accounting-to-month alignment, full sample rules, the pre-selected random seed, or the remaining construction/input routes. CRSP is named for market equity, but this appendix alone is not a complete source-data specification.

## Review notes

- Source review covers all 1,117 cached lines of the supplied appendix; original PDF pages 8–10 were rendered to confirm the split diagram and valuation formulas. The frozen title matches the appendix title; the appendix does not state a conflicting DOI.
- The selected target is the as-downloaded appendix workflow only. No analysis_only scope is supported because the release contains no executable analysis code or observation-level analysis data. The appendix contains empirical variable, performance, portfolio, and SHAP results; their presence does not supply the inputs or execution workflow.
- The assigned catalog lists CRSP.MSF and CRSP.MSF_V2. A bounded one-row local probe confirmed the specified MSF_V2 file is readable with PERMNO, MthCalDt, and MthCap, but coverage_verified=false and no author mapping is established. This does not support a verified full-panel route or an entitlement conclusion. No separate Compustat requirement was inferred from field names not explicitly sourced in the appendix.
- Python 3.12.14 and scikit-learn 1.9.1 are locally reported; official mutable stable documentation displayed scikit-learn 1.9.1. The author's version is unspecified, and the appendix does not identify the GBM implementation. No author code, estimator, data model, or regression was run.
- Two failed capture-wrapper attempts were retained under probes/ after a mistyped child cwd prevented child-process creation; each outer attempt exited 1, the exec tool exposed combined output without separate streams, and no child return code or streams existed. The observed outputs and limits are recorded in the corresponding failed_outer JSON files; these are process-history records, not assessment evidence.
