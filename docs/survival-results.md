# Verified visual summaries from the thesis appendix

These two figures reproduce **aggregate survival values reported in the original undergraduate thesis**. They do not expose plot-level or individual-tree measurements. Values are descriptive; the graphics do not establish statistical significance.

## Survival by species in 2023

![Survival by species](../figures/survival_by_species_2023.svg)

| Species (thesis label) | Scientific name | Reported survival (2023) |
|---|---|---:|
| Serbal | *Sorbus torminalis* | 91.4% |
| Rebollo | *Quercus pyrenaica* | 85.3% |
| Encina | *Quercus ilex* | 84.0% |
| Arce | *Acer monspessulanum* | 73.2% |
| Overall (reported) | — | 81.5% |

**Source:** Thesis Appendix, Table A.13. Original proportions (0.914, 0.853, 0.840, 0.732, 0.815) are multiplied by 100 for display. The overall value is copied from the thesis, **not recalculated as an unweighted mean**.

## Survival by thinning treatment and year

![Survival by treatment](../figures/survival_by_treatment_2018_2023.svg)

| Treatment | 2018 | 2019 | 2023 |
|---|---:|---:|---:|
| CB-20 | 94.47% | 92.09% | 99.60% |
| CB-35 | 94.74% | 92.11% | 95.11% |
| Control | 94.14% | 92.19% | 82.81% |
| SL-35 | 94.25% | 92.34% | 71.65% |

**Source:** Thesis Appendix, Table A.14. Treatment codes follow the original table (underscore normalized to hyphen for display). The source lists a higher 2023 percentage than in 2019 for some treatments; this figure **does not assume the rows represent a closed cohort with monotonically decreasing survival**, nor attempt to reconcile the definitions. Interpretation should be checked against the original methods and underlying workbook.

## Provenance and limitations

- Source: Adrián Berzal Martínez, undergraduate thesis, Universidad Politécnica de Madrid, cover dated 2023, Appendix Tables A.13 and A.14.
- Values are **transcribed from the thesis PDF**, not independently calculated from the original workbook.
- No uncertainty intervals or hypothesis-test results have been added.
- Any differences between the thesis abstract's qualitative ranking and Appendix Table A.13 should be resolved before presenting a single definitive species ranking.
- A growth chart should be added only after verifying the exact growth measure, units, and aggregation in the original results.
