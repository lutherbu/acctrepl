# Source field crosswalk: W3121890812

The machine-readable item locator and provider PDFs are cached under `../../../../output/reproduction_runs/reference_documents/`; the reused documentation index is `../../../../output/reproduction_runs/resource_documentation.json`. The locator is a page finder. The cited 2004 S&P Research Insight pages were checked in the attempt-local extraction at `../scratch/compustat_ri_2004.txt`.

| Paper item | 2004 Research Insight mnemonic | Current catalog field | 2004 guide page | Definition used here |
|---|---|---|---|---|
| #6 | AT | COMP.FUNDA.AT | Physical 136; printed 86 | Total assets. The paper does not state the average-assets interval. |
| #16 | TXT | COMP.FUNDA.TXT | Physical 257; printed 207 | Total income taxes. The provider says this includes deferred income taxes. |
| #170 | PI | COMP.FUNDA.PI | Physical 269; printed 219 | Pretax income. |
| #49 | MII | COMP.FUNDA.MII | Physical 262; printed 212 | Minority interest (income account); subtract when reported, as specified in paper footnote 18. |
| #50 | TXDI | COMP.FUNDA.TXDI | Physical 241; printed 191 | Income taxes deferred; subtract from #16 for the paper's current-tax calculation and use as its DTE fallback. |
| #52 | TLCF | COMP.FUNDA.TLCF | Physical 227; printed 177 | Tax loss carryforward; the best available local signal for a Compustat-identified NOL, but not a complete NOL indicator. |
| #269 | TXDFED | COMP.FUNDA.TXDFED | Physical 240; printed 190 | Federal deferred tax expense. |
| #270 | TXDFO | COMP.FUNDA.TXDFO | Physical 241; printed 191 | Foreign deferred tax expense. |

The current `COMP.FUNDA` catalog labels confirm these fields: `AT` is Assets - Total; `TXT` is Income Taxes - Total; `PI` is Pretax Income; `MII` is Noncontrolling Interest (Income Account); `TXDI` is Income Taxes - Deferred; `TLCF` is Tax Loss Carry Forward; `TXDFED` is Deferred Taxes-Federal; and `TXDFO` is Deferred Taxes-Foreign. It also labels `TXC` Income Taxes - Current. The build compares `TXC` with `TXT - TXDI` only where all three fields are observed; the paper's formula is used for the sign screen. The comparison is diagnostic and does not replace source item math.

The 2004 guide says `UPD=1` indicates no annual/quarterly update apart from an adjustment factor and sometimes market data, `UPD=2` is preliminary, and `UPD=3` is final (physical page 122; printed page 72). The sample construction uses `UPD=3` as a documented provider-status choice; the article does not prescribe this filter.

Current catalog definitions were read from `/storage/sas/data_description.txt` for exactly `COMP.FUNDA`, `CRSP.CCMXPF_LINKTABLE`, and `CRSP.DSF`. The CRSP/Compustat Merged Database Guide (2013) identifies `LINKPRIM` P/C as primary markers, `LINKTYPE` LC as a research-complete standard connection, and LU as an unresearched CUSIP link (physical pages 8-9; printed pages 4-5). Its native link table lists GVKEY, LINKDT, LINKENDDT, LPERMNO, LINKPRIM, and LINKTYPE (physical page 21; printed page 17). Local daily membership uses only CRSP.DSF PERMNO and DATE.

Provider references:

- S&P Research Insight North America Data Guide (2004), cached PDF `../../../../output/reproduction_runs/reference_documents/compustat_research_insight_2004.pdf`, SHA-256 `1b994d00718bc40f492871a119bc97a7af425de9da1bb79388c6a02bfef96183`.
- CRSP/Compustat Merged Database Guide (May 14, 2013), cached PDF `../../../../output/reproduction_runs/reference_documents/crsp_compustat_merged_2013.pdf`, SHA-256 `4aa183a1d5cf48f295e58382282f0925b6d11ff1cd095e89c5803f7d75862dd4`.
