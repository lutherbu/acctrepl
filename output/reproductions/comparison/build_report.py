#!/usr/bin/env python3
"""Index the accepted campaign and its reviewed publication comparisons.

Read-only with respect to accepted packages. No SAS/Stata jobs, source data,
network access, coefficient matching by row position, or statistical reruns.
The curated paper_assessments.json and scope notes below are review judgments,
not numerical equivalence tests. Run with Python 3 from any working directory.
"""

import csv
import hashlib
import json
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
import sys
sys.path.insert(0, str(ROOT))
import project_layout as layout
Path = layout.path_class(ROOT)
ROOT = Path(str(ROOT))
CAMPAIGN = HERE.parent / "summary.json"
PUBLICATION = Path(layout.active_path("models", ROOT))

LABELS = {
    "broad_agreement": "Main patterns broadly agree",
    "mixed": "Mixed findings",
    "substantive_discrepancy": "Main finding differs materially",
    "limited_published_target": "Limited published target",
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def fit_note(pid, mid, rid, fit, paper):
    """Specific reviewed comparisons; never infer agreement from execution."""
    if fit["execution_status"] != "executed":
        return "No converged estimate to compare. " + str(
            fit.get("execution_detail") or fit.get("blocked_reason") or "Native numerical failure; see review."
        )
    if pid == "W3125677029":
        vals = {
            "table2_abs_da": "SOX +3.327 (p<.001) versus -.015***; Time .085 (p=.056) versus .003***.",
            "table2_positive_da": "SOX +3.288 (p<.001) versus -.019**; Time .097 (p=.061) versus .002***.",
            "table2_negative_da": "SOX -3.381 (p<.001) versus +.006***; Time -.071 (p=.343) versus -.003***.",
            "table2_r_prod": "SOX -.266 (p<.001) versus +.032***; Time -.006 (p=.199) versus -.002, both nonsignificant.",
            "table2_r_cfo": "SOX -.326 (p=.002) versus +.007**; Time and SCA also reverse sign and lose significance.",
            "table2_r_disx": "SOX +.872 (p=.014) versus -.011***; Time reverses and loses significance; SCA loses significance.",
            "table2_rm_proxy": "SOX -.080 (p<.001) versus +.041***; Time and SCA lose significance.",
        }
        return vals[mid] + " Source test sidedness is unknown; tails/standardization remain unresolved."
    if pid == "W3126118385":
        return {
            "table5_model1_cf_pattern": "All four stage increments remain negative/significant. Stage totals -.150/-.028/-.033/-.212 versus -.121/-.031/-.001/-.142. N 26,242 versus 48,369.",
            "table5_model1_ar": "None of four stage contrasts is significant at 5% (p=.151/.547/.433/.253), unlike published introduction/shake-out/decline contrasts. N 17,713 versus 48,369.",
            "table5_model1_age_quintiles": "Stage contrasts retain signs/significance, but total levels differ, including negative local shake-out total (-.009 versus +.026). N 26,438 versus 48,369. Do not confuse total-level tests with reference-group contrasts.",
        }[mid]
    if pid == "W2152596199":
        return {
            "abs_da": "Tenure -.0003001, p=.334 versus -.00037, p=.0041: loses significance.",
            "abs_ca": "Tenure -.0003052, p=.001 versus -.00142, p=.0004: same negative/significant finding, much smaller magnitude.",
            "pos_ca": "Tenure -.0195236, p<.001 versus -.0293, p<.0001: same negative/significant finding.",
            "raw_da": "Tenure -.0003607, p=.290 versus +.00038, p=.0330: reverses sign and loses significance.",
            "raw_ca": "Tenure -.0001831, p=.144 versus -.00043, p=.3359: negative/nonsignificant in both.",
        }[mid]
    if pid == "W1990806291":
        if mid == "mishkin_forecast":
            return "CFO/NAC/ABNAC forecast slopes .8113/.7831/.6786 versus .73/.70/.57: all positive, larger locally; persistence ordering retained. Shared system NAC pricing equality fails to reject (p=.1624 versus <.001)."
        return "Valuation slopes .6068/.8704/1.1530 versus .67/.78/.69. CFO/ABNAC and both joint equality rejections persist; NAC equality does not (p=.1624 versus <.001). These are shared-system tests under an approximate conditional likelihood."
    if pid == "W3122987060":
        if mid == "baseline_cf_components":
            return "All seven component slopes retain signs/significance. DEPR .278 versus .42; AMORT .261 versus .47. N 10,500 versus 10,164; adjusted R2 .3769 versus .35."
        k = int(rid[-1])
        return [
            "Current EARN .459 versus .42; positive/significant. N 10,500 versus 10,164.",
            "Current/lag EARN .390/.106 versus .35/.12; both positive/significant. N 10,500 versus 10,164.",
            "EARN terms .379/.080/.058 versus .33/.07/.10; all positive/significant. N 10,500 versus 10,164.",
            "EARN terms .375/.079/.042/.041 versus .33/.08/.07/.06; all positive/significant. N 9,868 versus 9,250.",
            "EARN terms .373/.081/.038/.036/.021 versus .33/.08/.07/.05/.03; all positive/significant. N 9,311 versus 8,491.",
            "Current and lags 1–3/5 remain positive/significant; lag 4 nonsignificant in both. N 8,755 versus 7,821.",
            "All signs positive; lag 5 loses significance (p=.175 versus source t=2.51), lag 6 gains conventional two-sided 5% significance (p<.001 versus source t=1.94). N 8,166 versus 7,213. Source test sidedness unspecified.",
        ][k]
    if pid == "W1997012386":
        return (
            "STDROA/DIV/LEV remain positive/significant: 3.343/7.963/1.776 versus 2.079/3.557/.316. N 140 versus 704."
            if mid == "conflict_conmkt_1993_98" else
            "STDROA stays positive/significant; DIV loses significance (.115, p=.466 versus .404, p=.001); LEV remains nonsignificant with sign change. N 140 versus 632. Source predicted tests one-tailed, local tests two-tailed."
        )
    if pid == "W3124907716":
        return {
            "tacc_t1": "DTE 3.718 (p=.026) versus 3.7785 (.0153), TAcc 1.406 versus .9583: both positive/significant. N 4,995 versus 4,139.",
            "tacc_t3": "DTE nonsignificant in both; TAcc .068 (p=.732) versus .6160 (.0422) loses significance. N 4,077 versus 2,530.",
            "abaccmj_t1": "DTE positive/significant in both; AbAccMJ .176 (p=.089) versus .1423 (.2506), both nonsignificant at 5% but differ at 10%. N 4,995 versus 4,139.",
            "abaccmj_t2": "DTE and AbAccMJ positive/significant in both: 9.549/.595 versus 8.8055/.8854. N 3,128 versus 2,785.",
            "abaccmj_t3": "DTE nonsignificant in both; AbAccMJ changes sign (+.117 versus -.0730), nonsignificant in both. N 4,077 versus 2,530.",
            "abaccfl_t1": "DTE gains significance: 4.167, p=.025 versus 2.7257, p=.1157. AbAccFL remains positive/significant. N 4,106 versus 3,352.",
            "abaccfl_t2": "DTE and AbAccFL remain positive/significant: 11.446/1.148 versus 10.2743/.6174. N 2,542 versus 2,254.",
            "abaccfl_t3": "DTE nonsignificant in both; AbAccFL changes sign (+.239 versus -.0039), nonsignificant in both. N 3,207 versus 2,279.",
        }[mid] + " Source p-value convention is ambiguous; local p-values are two-sided."
    if pid == "W2028237122":
        return {
            "propensity_loss_trend": "Slope -.0344, p=.274 versus -.0361, t=-1.63; same negative/nonsignificant pattern at two-sided 5%.",
            "propensity_decrease_trend": "Slope -.0960, p=.081 versus -.1024, t=-1.62; both nonsignificant at two-sided 5%, but differ at 10%.",
            "propensity_surprise_trend": "Slope -.9758, p<.001 versus -1.218, t=-13.91; same negative/significant pattern.",
        }[mid] + " 18 annual observations; exact split-adjusted baseline unavailable."
    if pid == "W3124908438":
        return {
            "long_window_future_components": "Delta-ATO -.01967 (p=.103) versus +.087 (t=5.88); future ATO -.00302 (p=.589) versus +.017 (t=3.44). Both published positive findings absent; EARN and other terms also differ.",
            "short_window_announcement_returns": "Delta-ATO .000881 (p=.301) versus .002 (t=2.01): loses published significance. SUR stays positive/significant; delta-PM changes nonsignificant sign.",
            "analyst_forecast_revisions": "Delta-ATO .000109 (p=.245) versus .001 (t=2.44): loses significance. Delta-PM .00824 (p=.002) versus .001 (t=.94): gains significance. SUR remains positive/significant.",
        }[mid]
    if pid == "W2321597487":
        typ = "industry" if mid.endswith("industry") else "pooled"
        proxy = "cf" if "_cf_" in mid else "dd" if "_dd_" in mid else "jones"
        j = {"cf": 0, "dd": 1, "jones": 2}[proxy]
        prefix = mid.split("_")[0] if not mid.startswith("t5_") else "_".join(mid.split("_")[:2])
        vectors = {
            "a": {"pooled": ([.53,.45,.58],[1.053,.822,1.097]), "industry": ([.49,.46,.46],[.732,.504,.797])},
            "b": {"pooled": ([.25,.17,.38],[.528,.386,1.279]), "industry": ([.15,.12,.11],[.432,.332,.809])},
            "c": {"pooled": ([.34,.34,.48],[.823,.783,1.043]), "industry": ([.31,.23,.35],[.614,.381,.720])},
            "m": {"pooled": ([.13,.12,.11],[.113,.098,.105]), "industry": ([.10,.10,.07],[.102,.0841,.0777])},
            "t5_a": {"pooled": ([.59,.50,.61],[.700,.568,.715]), "industry": ([.30,.30,.31],[.476,.356,.503])},
            "t5_b": {"pooled": ([.23,.14,.28],[.272,.213,.391]), "industry": ([.13,.10,.05],[.204,.125,.187])},
            "t5_c": {"pooled": ([.37,.36,.45],[.419,.379,.502]), "industry": ([.29,.22,.31],[.315,.244,.331])},
        }
        if prefix == "t5_d":
            if typ == "industry":
                return (
                    f"Joint model industry-adjusted CF interaction {[-.29,-.27,-.15][j]} published versus {[.00922,.0453,.208][j]} local (p{['=.872','=.448','<.001'][j]}): sign reversal. "
                    + ["DCF and delta-CF interactions remain positive locally; market interaction positive/significant.",
                       "Delta-CF interaction local p=.237; market interaction positive/significant.",
                       "DCF interaction local p=.125; delta-CF p=.039; market interaction positive/significant."][j]
                )
            return "All four joint-model interaction signs positive as in source; local p<=.001. Magnitudes and some source inference differ; source Table 5D notes multicollinearity. See all four interaction rows in the review."
        old, new = vectors[prefix][typ]
        msg = f"Focal {'market-return' if prefix=='m' else 'book-proxy'} interaction {new[j]} versus published {old[j]}; positive locally with p<.001."
        if prefix.startswith("t5_"):
            msg += " The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked."
        return msg + " Magnitude agreement varies; source test sidedness is unspecified."
    if pid == "W1987881672":
        return "This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt."
    if pid == "W3126000559":
        return {
            "icw_financial_covenants": "Uncorrected/corrected -.537/-.146, p=.141/.672 versus -.362/-.500, source p=.00/.00: both lose significance. N 223 versus 2,828.",
            "icw_interest_rate": "Uncorrected/corrected -5.732/+8.629, p=.856/.701 versus +28.959/-.386, p=.04/.98: both reverse signs; uncorrected significance lost. N 223 versus 2,828.",
            "icw_secured": "Uncorrected/corrected -1.170/-1.767, p=.066/.001 versus +.282/+.494, p=.04/.00: both reverse signs. N 212 versus 2,828; perfect-prediction removals.",
            "icw_general_covenants": "Uncorrected/corrected -.946/-.811, p=.291/.250 versus -.050/+.121, p=.88/.75: both nonsignificant, corrected sign changes. N 37 versus 2,828; omnibus cluster test unavailable.",
            "icw_maturity": "Uncorrected/corrected +.186/+.148, p=.215/.217 versus -.003/+.095, p=.94/.15: both nonsignificant, uncorrected sign changes. N 223 versus 2,828.",
            "icw_pp_ratio": "Uncorrected/corrected -9.127/-4.217, p=.003/.052 versus -.507/-.067, p=.02/.79: 5% decisions agree but magnitudes differ greatly and corrected result is marginal at 10%. N 88 versus 2,045; separation note.",
        }[mid]
    if pid == "W2065676679":
        h = int(rid[-1]) - 1
        if mid == "roe_btm_benchmark":
            return f"ROE0 { [.313,.170,.214,.180,.150][h] } versus {[.183,.122,.030,.053,.092][h]}; BTM {[-.119,-.098,-.065,-.060,-.079][h]} versus {[-.119,-.089,-.088,-.077,-.048][h]}. Directions agree. N 4,409 versus 6,044; see native table for individual inference."
        return f"Bias-minus-lag contrast {[.097,.092,-.009,.006,-.020][h]} versus {[.135,.130,.074,-.020,-.004][h]}. Incremental robust Wald p={['<.001','<.001','.064','<.001','.005'][h]} versus source classical F={[37.6,33.0,10.3,2.7,5.1][h]}. These test procedures differ. N 4,409 versus 6,044."
    if pid == "W3124170598":
        sd = {
            "jones_eq6": (9.98,14.65), "modified_jones_eq6": (10.33,14.91),
            "jones_roa_lag_eq7": (9.62,14.58), "jones_roa_current_eq7": (10.65,13.95),
            "modified_jones_roa_lag_eq7": (9.94,14.82), "modified_jones_roa_current_eq7": (10.98,14.31),
        }[mid]
        return f"No published coefficient target for this regression family. Residual SD {sd[1]}% of assets versus {sd[0]}%; distributions differ. Common residual comparison N 124,351 versus 122,798; these are descriptive targets, not coefficient tests."
    if pid == "W3124365414":
        return {
            "abnormal_cfo_eq6": "Suspect coefficient -.0129535, p=.056 versus -.0200, t=-3.05: same sign, loses two-sided 5% significance.",
            "abnormal_disexp_eq6": "Suspect coefficient -.0668535, p<.001 versus -.0591, t=-4.35: same negative/significant finding.",
            "abnormal_prod_eq6": "Suspect coefficient +.0460897, p<.001 versus +.0497, t=4.99: same positive/significant finding.",
        }[mid] + " N 50,520 versus 21,758; Newey-West bandwidth assumed."
    if pid == "W3123227524":
        row = {
            "t6_da": (-.126,-.066,.313), "t6_cfo": (-.158,-.090,.111),
            "t6_prod": (-.256,.023,.532), "t6_disx": (-.167,.076,.045),
            "t6_rm1": (-.237,-.036,.093), "t6_rm2": (-.221,-.029,.240),
        }[mid]
        return f"Focal coefficient {row[1]}, p={row[2]} versus {row[0]} (source significant). " + (
            "Sign reverses." if row[1]>0 else "Negative sign retained, 5% significance lost."
        ) + " N 2,030; source model N not reported."
    if pid == "W3121620818":
        return {
            "t7_ts_jones": "DA .912 (two-sided p=.200; one-sided .100) versus 1.734 (source one-sided p=.179): both positive/nonsignificant at 5%.",
            "t7_ts_modified_jones": "DA 1.051 (two-sided p=.128; one-sided .064) versus 1.849 (source one-sided p=.156): both positive/nonsignificant at 5%.",
            "t7_cs_jones": "DA 3.705 (two-sided p=.0006) versus 4.737 (source one-sided p=.007): both positive/significant.",
            "t7_cs_modified_jones": "DA 3.718 (two-sided p=.0003) versus 3.938 (source one-sided p=.016): both positive/significant.",
        }[mid] + " N 950 versus 346."
    if pid == "W3123284902":
        return {
            "t5_model4_panel_a": "Accruals/NOA -.009226/-.005742 versus -.0079/-.0058: both negative/significant. 438 monthly estimates; local firm-month N 1,174,665.",
            "t5_model4_panel_b": "Accruals/NOA -.004268/-.004429 versus -.0062/-.0023: both negative/significant, NOA more negative. 438 monthly estimates; local N 1,153,631.",
            "t5_model4_panel_c": "Accruals -.001822 versus -.0019, nonsignificant in both; NOA -.002063 versus -.0024, significant in both. 438 monthly estimates; local N 1,122,680.",
        }[rid]
    if pid == "W3123899283":
        row = {
            "full_h1": (.652,.722,9102,11137), "vol_q1_h1": (.934,.927,1899,2329),
            "vol_q2_h1": (.888,.873,None,2261), "vol_q3_h1": (.838,.838,None,2260),
            "vol_q4_h1": (.755,.715,None,2190), "vol_q5_h1": (.507,.632,1682,2097),
            "full_h2": (.484,.524,7502,9336), "full_h3": (.449,.455,6147,7803),
            "full_h4": (.421,.387,5011,6440), "full_h5": (.381,.381,4032,5214),
            "high_vol_h2": (.287,.369,1314,1643), "high_vol_h3": (.261,.301,1029,1276),
            "high_vol_h4": (.241,.192,822,968), "high_vol_h5": (.177,.235,659,732),
            "low_vol_h2": (.867,.872,1620,2042), "low_vol_h3": (.774,.800,1365,1790),
            "low_vol_h4": (.812,.751,1140,1562), "low_vol_h5": (.805,.782,922,1309),
            "five_year_sum_full": (2.359,2.457,4032,5186),
            "five_year_sum_high_vol": (1.372,1.599,659,726),
            "five_year_sum_low_vol": (4.205,4.306,922,1306),
        }[rid]
        return f"Persistence slope {row[1]} versus {row[0]}, positive/significant. N {row[3]} versus {row[2] if row[2] is not None else 'unreported'}. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs."
    if pid == "W3125741632":
        if rid.startswith("forward"):
            k = int(rid[-1])-1
            return f"b1/g1/combined levels retain negative significance at k={k+1}. Combined slope {[-.0770251,-.1233755,-.1407305][k]} versus {[-.1114,-.1724,-.1788][k]}. Adjacent tests differ: k2-k1 g1 loses 5% significance; k3-k2 b1 gains it. Shared contrast findings, not additional fits."
        j=int(rid[-1])
        return f"Historical j={j}: b1/g1 signs and 5% decisions agree. Combined bad-news slope {[-.0323612,-.0307694,-.0086599,-.0045085,-.0434492][j]} versus {[-.0383,-.0315,-.0114,-.0196,-.0217][j]}; " + ("local p=.027 gains significance versus source t=-1.00." if j==4 else "combined-level inference agrees; adjacent-change discrepancies are documented separately.")
    if pid == "W3123370480":
        k=int(rid.split('_')[1][0])-1
        return f"Earnings {[.7841,.7175,.7225][k]} versus {[.8304,.7924,.7871][k]} remains positive/significant. Accruals {[-.0488,-.0485,-.0455][k]} versus {[-.0725,-.0848,-.0932][k]}: " + ("loses two-sided 5% significance (t=-1.93). " if k==2 else "negative/significant. ") + "Dividend dummy gains significance; " + ("negative-earnings dummy loses 5% significance." if k<2 else "negative-earnings dummy remains significant.")
    if pid == "W2015142764":
        return (
            "TIME x DD .0058138, p=.008 versus .017, t=10.51; positive/significant but much smaller. N 27,363 versus 95,270."
            if mid == "baseline_dd" else
            "TIME x ABACC2 .0095975, p=.008 versus .012, t=4.62; positive/significant. N 30,594 versus 99,643."
        ) + " GMM moment specification is approximate."
    if pid == "W3125018794":
        return (
            "Forecast alpha0 changes from -.058 to +.0323; alpha1 remains negative/significant (-.6072 versus -.329). "
            if mid.endswith("forecast_error") else
            "Return-equation alpha1* reverses from +.138/nonsignificant to -.7245/significant; beta1 3.480 versus 1.163. "
        ) + "Shared system tests change: efficiency p=.0601 versus .001; naive expectations p=5.50e-20 versus .516. Approximate conditional likelihood."
    if pid == "W3125232597":
        return {
            "table3_acq_car": "Comparability -.005 (p=.616) versus +.017 (t=2.04): sign reverses, significance lost. N 1,334 versus 1,307.",
            "table3_synergy": "Comparability +.003 (p=.753) versus +.018 (t=2.22): significance lost. N 1,332 versus 1,277.",
            "table3_delta_roa": "Comparability +.010 (p=.313) versus +.025 (t=2.51): significance lost. N 1,041 versus 1,042.",
        }[mid] + " Published focal tests are one-sided; local expected-sign tests also do not reach 5%."
    if pid == "W11897853":
        return {
            "current_outlays_bve": "R&D/CapEx .196/.097 versus .067/.021; both positive/significant, R&D larger. Local R&D-minus-CapEx NW t=7.55. N 22,951 versus 42,776.",
            "current_outlays_price": "R&D/CapEx .257/.094 versus .072/.028; both positive/significant, R&D larger. N 21,929 versus 40,569.",
            "capitalized_investments_bve": "Capitalized R&D/PPE .080/.018 versus .041/.009; both positive/significant, R&D larger. N 14,817 versus 29,408.",
        }[mid]
    if pid == "W3121262606":
        h=int(rid[-1])-1
        if mid.endswith("total"):
            old,new = (([-1.120,-2.210,-3.328],[-1.254,-2.452,-3.577]) if mid.startswith('cfo') else ([-.665,-1.255,-1.660],[-.955,-1.768,-2.502]))
            return f"{4*(h+1)}-quarter total-exclusion slope {new[h]} versus {old[h]}; negative/significant in both. Magnitude larger locally, especially FCF. Published fit-specific N unavailable."
        return f"{4*(h+1)}-quarter components: " + ("special items positive/nonsignificant, other exclusions negative/significant in both." if mid.startswith('cfo') else "special items positive/significant and other exclusions negative/significant in both.") + " See review for both coefficient magnitudes; source fit-specific N unavailable."
    if pid == "W3123423002":
        return (
            "Low-OPACC interaction -.128 versus -.137; additional special-item interaction -.172 versus -.197: both negative/significant. N 70,084 versus 61,989."
            if mid.endswith("opacc_m6") else
            "Low-TACC interaction -.066 versus -.026; additional special-item interaction -.247 versus -.300: both negative/significant. N 70,084 versus 61,989."
        )
    if pid == "W2015391739":
        return {
            "bad_news_actual": "Slope .329 versus .284; positive/significant. N 39,201 versus 20,618; R2 .094 versus .086.",
            "bad_news_simulated": "Slope .460 versus .493; positive/significant. N 39,140 versus 20,498; R2 .195 versus .243.",
            "good_news_actual": "Slope .032 versus .025; positive/significant. N 50,787 versus 29,333; R2 .007 versus .006.",
            "good_news_simulated": "Slope .035 versus .009; positive/significant but about four times source magnitude. N 50,848 versus 29,453; R2 .009 versus .001. Unlike source point estimates, local simulated good-news slope exceeds actual good-news slope.",
        }[mid]
    if pid == "W3122432337":
        return {
            "valuation_street": "STREET slope 2.297 versus 19.28; adjusted R2 .4582 versus .4269. Local EPSOP slope/R2 exceed STREET, opposite the source ranking. N 48,306 versus 22,024.",
            "valuation_epsop": "EPSOP slope 7.185 versus 17.31; adjusted R2 .4904 versus .4205. Local EPSOP slope/R2 exceed STREET, opposite the source ranking. N 48,306 versus 22,024.",
            "information_3day_street": "ERC .018248 versus 1.3451, significant locally; adjusted R2 .0021 versus .0290. Local ERC/R2 below EPSOP, opposite source. N 33,602 versus 22,092.",
            "information_3day_epsop": "ERC .057194 versus .8707, significant locally; adjusted R2 .0072 versus .0228. Local ERC/R2 above STREET, opposite source. N 33,602 versus 22,092.",
        }[mid] + " Paired slope-difference/Vuong tests not reproduced."
    if pid == "W2048409281":
        row={
            "earnings_persistence_h1_1974": (.0314,.0772,.154),
            "earnings_persistence_h1_1984": (.0795,-.0490,.507),
            "earnings_persistence_h1_1994": (.0643,-.0910,.073),
            "earnings_persistence_h2_1974": (.0245,.1436,.126),
            "earnings_persistence_h2_1984": (.0985,.0038,.963),
            "earnings_persistence_h2_1994": (.0992,-.1116,.236),
        }[rid]
        return f"Dividend-persistence interaction {row[1]}, p={row[2]} versus {row[0]}. " + ("Nonsignificant at 5% in both, with different magnitudes." if rid=='earnings_persistence_h2_1974' else "Published positive/significant finding absent at 5%.")
    if pid == "W2105094056":
        return {
            "eq1_pre142_estimated": "IMPI gains significance (.256, p=.040 versus .162, z=1.24); BTMG1 remains positive/significant (.560 versus .509). Conditional N 2,325; source fit N unavailable.",
            "eq1_post142_estimated": "IMPI/BTMG1 .500/1.127 versus .604/1.114: both positive/significant. Conditional N 9,973; source fit N unavailable.",
            "eq1_post142_compustat": "IMPI/BTMG1 .431/1.220 versus .494/1.207: both positive/significant. Conditional N 9,140; source fit N unavailable.",
        }[mid] + " Firm strata assumed; pseudo-R2 higher locally."
    if pid == "W3125558500":
        return (
            "Four regional slopes .970/1.017/.698/.619 versus .98/1.04/.67/.62; both equality tests reject at p<.001. Adjusted R2 .926 versus .99; N 124,572 versus 113,113."
            if mid.startswith('eq1') else
            "Four regional slopes 2.200/2.207/.892/.967 versus 2.03/1.94/.94/.99; both equality tests reject at p<.001. Adjusted R2 .864 versus .99; N 124,572 versus 113,356."
        )
    if pid == "W3121345849":
        h=int(rid[-1])-1
        if mid=='hvz_forecast':
            return f"Earnings slope {[.9079,.8496,.8358][h]} versus {[.8715,.8365,.8378][h]}; adjusted R2 {[90.034,84.171,80.641][h]}% versus {[89.6,84.0,80.1][h]}%. " + ["Intercept reverses sign and remains significant; other focal slope signs retained.","Dividend dummy remains significant but near the cutoff (native p=.049, t=2.03 versus source t=6.58). Intercept loses significance.","Dividend dummy loses significance (.0627, t=.10 versus 2.6674, t=8.79); intercept also loses significance."][h]
        if mid=='ep_forecast':
            return f"All predictor directions and significance patterns retained, but magnitudes differ substantially. Adjusted R2 {[66.400,61.799,56.853][h]}% versus {[68.1,51.5,41.5][h]}%. Earnings and negative-earnings interaction values are in the review."
        return [
            "TACC reverses from -.0034 (t=-2.28) to +.1766 (t=3.19, p=.003); other predictor signs retained. Adjusted R2 70.743% versus 68.1%.",
            "TACC reverses and loses significance: +.0573 (p=.717) versus -.0217 (t=-10.07). Adjusted R2 66.273% versus 52.1%.",
            "TACC loses significance: -.0288 (p=.904) versus -.0413 (t=-13.38). 43 identified annual vectors; first requested fit rank deficient. Adjusted R2 61.574% versus 42.5%.",
        ][h]
    if pid == "W3124763333":
        return (
            "Forecast EARN and backlog slopes remain positive; coefficients differ. " if mid=='mishkin_forecast' else
            "Valuation backlog slope nearly equals forecast counterpart locally, unlike source. "
        ) + "Shared joint-system backlog equality p=.9631 versus <.001; earnings equality p=.0366 versus .05. N 24,696 versus 21,891. Approximate benchmark and conditional likelihood qualify comparison."
    return paper["summary"]


def cell(text):
    return str(text).replace("|", "\\|").replace("\n", " ")


def write_csv(name, rows, fields):
    with (HERE / name).open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def write_json(name, data):
    (HERE / name).write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")


def write_jsonl(name, rows):
    (HERE / name).write_text("".join(json.dumps(r, ensure_ascii=False) + "\n" for r in rows))


def main():
    campaign = json.loads(CAMPAIGN.read_text())
    assessments = json.loads((HERE / "paper_assessments.json").read_text())
    pubs = {d["paper_id"]: (n, d) for n, d in enumerate((layout.legacy_model(json.loads(line), ROOT) for line in PUBLICATION.open()), 1)}
    assert set(assessments) == {r['paper_id'] for r in campaign['rows']}
    papers, fits, inventory, evidence = [], [], [], []
    documentation_hash_differences = []
    native_table_hashes = {}
    for row in campaign["rows"]:
        pid = row["paper_id"]
        path = Path(row["path"]).resolve()
        accepted = json.loads((path.parent / "accepted.json").read_text())
        assert Path(accepted["path"]) == path
        assert accepted["outcome_sha256"] == sha(path / "outcome.json"), pid
        outcome = json.loads((path / "outcome.json").read_text())
        for document in ('review.md', 'design.md'):
            if sha(path/document) != outcome['files'].get(document):
                documentation_hash_differences.append(dict(paper_id=pid, file=document,
                    recorded_sha256=outcome['files'].get(document), current_sha256=sha(path/document)))
        runtime = json.loads((path/'runtime/latest.json').read_text())
        runtime_outputs = {name: fingerprint for run in runtime.get('cells',{}).values()
                           if run.get('ok') for name,fingerprint in run.get('outputs',{}).items()}
        work = json.loads((path / "work_item.json").read_text())
        models = {m["model_id"]: m for m in work["models"]}
        publine, pub = pubs[pid]
        pmodels = {m["model_id"]: m for m in pub["models"]}
        note = assessments[pid]
        roles = Counter(m["model_role"] for m in models.values())
        p = dict(paper_id=pid, title=row['title'], journal=row['journal'],
                 accepted_attempt=accepted['attempt'], baseline_models=roles['baseline'],
                 supporting_models=roles['supporting'], expected_scopes=outcome['total_scopes'],
                 executed_scopes=outcome['executed_scopes'],
                 blocked_scopes=outcome['total_scopes']-outcome['executed_scopes'],
                 **note, review_path=str(path/'review.md'), design_path=str(path/'design.md'))
        papers.append(p)
        by_model = Counter(f['model_id'] for f in outcome['fits'])
        for mid, model in models.items():
            inventory.append(dict(paper_id=pid, title=row['title'], model_id=mid,
                                  model_role=model['model_role'], model_label=model.get('model_label'),
                                  method=model.get('method'), retained_scope_count=by_model[mid],
                                  comparison_status='see_fit_ledger' if by_model[mid] else 'construction_dependency_no_standalone_comparison',
                                  note='Dependent construction regression; campaign execution count does not enumerate its individual annual/industry/security fits. See accepted design and native logs.' if not by_model[mid] else '',
                                  design_path=str(path/'design.md')))
        for fit in outcome['fits']:
            mid,rid=fit['model_id'],fit['result_set_id']
            pm=pmodels[mid]
            prs=next((r for r in pm.get('results',{}).get('result_sets',[]) if r['result_set_id']==rid),None)
            if prs is None:
                assert pid=='W3124170598' and rid is None
            table=path/(fit['table_basename']+'.md') if fit.get('table_basename') else None
            if fit['execution_status']=='executed':
                assert table and table.is_file(), (pid,mid,rid)
                assert runtime_outputs.get(str(table.relative_to(path))) == sha(table), (pid,mid,rid,'native table hash')
                native_table_hashes[str(table)] = sha(table)
            entry=dict(paper_id=pid, title=row['title'], journal=row['journal'],
                       model_id=mid, model_role=models[mid]['model_role'],
                       model_label=models[mid].get('model_label'), result_set_id=rid,
                       result_set_label=prs.get('label') if prs else 'Residual-distribution target; no published coefficient result set',
                       execution_status=fit['execution_status'], fidelity=fit['fidelity'],
                       comparison=fit_note(pid,mid,rid,fit,note),
                       paper_assessment=note['assessment'],
                       comparability_limits=note['caveat'],
                       review_path=str(path/'review.md'), design_path=str(path/'design.md'),
                       reproduced_table_path=str(table) if table else None,
                       source_extraction_path=f'{PUBLICATION}:{publine}',
                       source_extraction_status='reference_only_review_corrections_take_precedence',
                       source_locations=prs.get('locations',[]) if prs else models[mid].get('locations',[]),
                       source_aggregation=prs.get('aggregation') if prs else None,
                       source_parameters=[{k:v.get(k) for k in ('parameter_id','label','target_kind','variable_ids','estimate_kind','reported','estimate_multiplier','standard_error_multiplier')} for v in prs.get('parameters',[])] if prs else [],
                       current_assumptions=fit.get('assumptions',[]),
                       execution_detail=fit.get('execution_detail'),
                       parameterwise_equivalence_test_performed=False)
            fits.append(entry)
        ev=dict(paper_id=pid, accepted_attempt=accepted['attempt'], files={})
        for f in ['accepted.json']:
            ev['files'][str(path.parent/f)]=sha(path.parent/f)
        for f in ['outcome.json','review.md','design.md','work_item.json','runtime/latest.json']:
            ev['files'][str(path/f)]=sha(path/f)
        for f in {e['reproduced_table_path'] for e in fits if e['paper_id']==pid and e['reproduced_table_path']}:
            ev['files'][f]=sha(Path(f))
        evidence.append(ev)

    keys={(f['paper_id'],f['model_id'],f['result_set_id']) for f in fits}
    assert len(keys)==len(fits)==campaign['expected_scopes']==239
    assert len(inventory)==211 and len(papers)==47
    assert sum(f['execution_status']=='executed' for f in fits)==235
    assert Counter(m['model_role'] for m in inventory)=={'baseline':178,'supporting':33}
    assert all(f['model_role']=='baseline' for f in fits)
    assert all(f['comparison'] for f in fits)
    counts=Counter(p['assessment'] for p in papers)
    summary=dict(generated_at=datetime.now(timezone.utc).isoformat(),
                 scope='47 accepted reproduction papers, frozen baseline models and supporting dependencies; not all 167 filtered or 500 candidate papers',
                 papers=len(papers), baseline_model_definitions=178, supporting_model_definitions=33,
                 model_result_set_scopes=len(fits), executed_scopes=235, blocked_scopes=4,
                 paper_assessment_counts=dict(counts),
                 fit_fidelity_counts=dict(Counter(f['fidelity'] for f in fits)),
                 independent_parameterwise_equivalence_test=False,
                 source_precedence='Accepted final review/native exports over historical attempts and original AI extraction; current task is an exhaustive synthesis of these reviews.',
                 publication_source_sha256=sha(PUBLICATION),
                 campaign_summary_sha256=sha(CAMPAIGN),
                 assessments_sha256=sha(HERE/'paper_assessments.json'),
                 generator_sha256=sha(Path(__file__)),
                 documentation_hash_differences=documentation_hash_differences,
                 unique_native_tables_verified=len(native_table_hashes),
                 validation='47 accepted outcome fingerprints match; 239 unique scopes; every executed scope table matches its successful native runtime hash; all 211 model definitions inventoried. Current review-text hash differences are disclosed separately.')
    write_json('summary.json',summary)
    write_json('evidence_index.json',evidence)
    write_jsonl('papers.jsonl',papers)
    write_jsonl('fits.jsonl',fits)
    write_jsonl('model_inventory.jsonl',inventory)
    write_csv('papers.csv',papers,list(papers[0]))
    write_csv('fits.csv',fits,[k for k in fits[0] if k not in ['source_parameters','current_assumptions','source_locations']])
    write_csv('model_inventory.csv',inventory,list(inventory[0]))

    report=[
        '# Published-versus-reproduced findings: all 47 papers', '',
        f'Generated {summary["generated_at"]}. This is a synthesis of every accepted final review and its native output references. No regression was rerun. Package locations and ado paths were relocated with original execution artifacts preserved in the archive.', '',
        '**Coverage:** 47 papers; 178 retained baseline model definitions, expanding to 239 model/result-set scopes; 235 executed and four numerically blocked. The 33 supporting construction model definitions are indexed separately (211 definitions altogether). All 239 scopes are explicitly labeled `best_effort` in the accepted campaign.', '',
        'For a model-level consistency count under explicit focal-sign and 5% inference rules, see the [239-scope consistency summary](model_consistency_summary.md). That separate assessment does not inherit the broad paper-level categories below.', '',
        'This covers the authorized 47-paper reproduction set, not the 167-paper filtered set or the original 500 candidates. One scope can average many annual, monthly, industry, or firm regressions. Joint-system tests can be shared by two equation scopes; their appearance in both rows does not make them independent tests.', '',
        '## How to read the assessment', '',
        '| Paper-level review judgment | Papers | Interpretation |',
        '|---|---:|---|',
    ]
    definitions={
        'broad_agreement':'The reviewed focal directions and principal inference pattern broadly survive. Coefficients, N, R2, controls, or secondary contrasts may differ greatly; this does not mean numerical equivalence.',
        'mixed':'Some reviewed focal findings survive while other coefficients, hypotheses, horizons, or contrasts differ; includes partially blocked papers.',
        'substantive_discrepancy':'A central retained finding reverses, disappears, newly appears, or its key comparison changes materially. This is an outcome of the reconstructed specification, not a finding that the original paper is false.',
        'limited_published_target':'Published coefficient/inference targets are insufficient: one paper reports only a focal point estimate; one reports residual distributions rather than construction-regression coefficients.',
    }
    for k,label in LABELS.items():report.append(f'| {label} | {counts[k]} | {definitions[k]} |')
    report += ['',
        '**These are paper-level qualitative judgments, not a preregistered replication pass rate or an automatically scored coefficient census.** The fit ledger provides a comparison for all 239 scopes, including different outcomes within the same paper. It does not attach the paper-level judgment as a separate model-level verdict.', '',
        'Source one-sided tests, two-sided exported p-values, rounded t statistics, model-based versus robust/HAC covariance, and shared equality tests are distinguished where documented. A change in significance is not itself a statistically significant difference between estimates. No unreported p-values or statistical equivalence claims were manufactured.', '',
        'The source extraction in `fits.jsonl` is retained as a reference, not re-certified field by field; corrections in the accepted review take precedence. This synthesis checks focal results and reported comparisons across all scopes, rather than newly transcribing every control coefficient from all PDFs. Broader parent-sample Ns and rolling-window/industry counts are not treated as directly comparable regression Ns.', '',
        '## Complete paper summary', '',
        '| Paper | Journal | Scopes run / retained | Assessment | Published comparison | Sample comparison | Main qualification |',
        '|---|---|---:|---|---|---|---|',
    ]
    for p in papers:
        report.append('| '+ ' | '.join([
            f'[{cell(p["title"])}]({p["review_path"]})',p['journal'],f'{p["executed_scopes"]}/{p["expected_scopes"]}',
            LABELS[p['assessment']],cell(p['summary']),cell(p['sample']),cell(p['caveat'])])+' |')
    report += ['', '## Complete model records', '',
        '- [All 239 fit scopes, grouped by paper](all_models.md): specific comparison text, execution status, and links to native tables.',
        '- [Fit CSV](fits.csv) and [fit JSONL](fits.jsonl): one row per model/result-set pair; JSONL also includes the original extracted published parameters and current implementation assumptions.',
        '- [All 211 model definitions](model_inventory.csv): 178 baseline plus 33 supporting dependencies. Supporting fits are internal construction work, not 33 additional independent published-result replications.',
        '- [Paper CSV](papers.csv), [paper JSONL](papers.jsonl), [summary counts](summary.json), and [source fingerprints](evidence_index.json).', '',
        'The four blocks are auditor-tenure positive DA, negative DA and negative CA, plus deferred-tax Table 2 target 2. They have no converged coefficient result and are not coded as agreement or disagreement.', '',
        'No unexplained discrepancy is assigned to data vintage alone. Stronger causal attribution would require source-supported sample reconciliation or sensitivity analysis; that was not rerun for this report.', '',
        f'Provenance check: all {len(native_table_hashes)} distinct linked native tables match their successful runtime fingerprints, covering all 235 executed scope references. All 47 accepted outcome fingerprints and all 47 design-document fingerprints match. Three current review documents (W3125487088, W2065676679, W3124170598) differ from the review hashes stored inside their accepted outcomes; current files contain coordinator audit/documentation additions. Their comparison figures were cross-checked against native tables for this synthesis. Both recorded and current review hashes are disclosed in summary.json; no accepted record was rewritten.', '',
        'Rebuild this report with `/opt/tljh/user/bin/python output/reproductions/comparison/build_report.py` from the git project root. Curated paper judgments are in `paper_assessments.json`; scope-specific review summaries are in the generator. Accepted packages remain the evidence authority.', '',
    ]
    (HERE/'report.md').write_text('\n'.join(report))
    detail=['# All retained model/result-set comparisons', '',
            '239 scope rows below. These are reviewed focal comparisons, not a complete term-by-term equivalence test. Read each paper’s sample/estimator qualifications with its model findings. Published parameter reference records are in fits.jsonl; the accepted source-checked review controls over that earlier extraction.', '']
    for p in papers:
        detail += [f'## {p["paper_id"]}: {p["title"]}', '',
                   f'[{p["journal"]}; accepted attempt {p["accepted_attempt"]} review]({p["review_path"]}) · [construction and estimation design]({p["design_path"]})', '',
                   p['sample']+' '+p['caveat'], '',
                   '| Model / result set | Execution | Reviewed comparison | Native table |',
                   '|---|---|---|---|']
        for f in fits:
            if f['paper_id']!=p['paper_id']:continue
            detail.append('| '+' | '.join([
                f'`{f["model_id"]}` / `{f["result_set_id"] or "no_published_coefficient_set"}`',
                f['execution_status'],cell(f['comparison']),
                f'[Table]({f["reproduced_table_path"]})' if f['reproduced_table_path'] else 'No converged estimate'])+' |')
        deps=[m for m in inventory if m['paper_id']==p['paper_id'] and m['model_role']=='supporting']
        if deps:
            detail += ['', '**Supporting construction models** (no separate campaign comparison scope): '+', '.join('`'+m['model_id']+'`' for m in deps)+'. See linked design/native logs for their internal fit coverage.']
        detail += ['']
    (HERE/'all_models.md').write_text('\n'.join(detail))
    print(json.dumps(summary,ensure_ascii=False,indent=2))


if __name__=='__main__':
    main()
