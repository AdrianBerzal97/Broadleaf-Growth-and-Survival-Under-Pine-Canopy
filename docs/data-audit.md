# Audit of survival aggregates against the field workbook

The thesis appendix values and the workbook's binary observations are **not interchangeable**. This note records a direct unweighted count of available binary values; it does not claim to reproduce the thesis's statistical estimators or sampling design.

## Species in 2023

Source sheet: `Supervivencia (2023)`; species column C, survival `sup_3` column D. Counted 401 rows with species labels and a binary 0/1 value.

| Species | Thesis Table A.13 | Workbook direct count | Valid records |
|---|---:|---:|---:|
| *Acer monspessulanum* (Arce) | 73.20% | 73.41% | 173 |
| *Quercus ilex* (Encina) | 84.00% | 84.00% | 75 |
| *Quercus pyrenaica* (Rebollo) | 85.30% | 85.42% | 48 |
| *Sorbus torminalis* (Serbal) | 91.40% | 91.43% | 105 |

The thesis also reports an overall 81.5%, which is **not** assumed to be the unweighted mean of these four species. Small differences may arise from aggregation, rounding, filtering, or sample definitions, but their cause has not been established.

## Treatments by year

Source sheet: `Evo_Sup`, treatment column B, binary survival columns E, F and G. Counted 353 valid records per year in the inspected rows.

| Treatment | Valid records | Direct 2018 | Direct 2019 | Direct 2023 | Thesis A.14 (2018 / 2019 / 2023) |
|---|---:|---:|---:|---:|---|
| CB-20 | 67 | 91.04% | 88.06% | 98.51% | 94.47% / 92.09% / 99.60% |
| CB-35 | 119 | 96.64% | 94.12% | 89.08% | 94.74% / 92.11% / 95.11% |
| Control | 71 | 92.96% | 91.55% | 56.34% | 94.14% / 92.19% / 82.81% |
| SL-35 | 96 | 95.83% | 94.79% | 68.75% | 94.25% / 92.34% / 71.65% |

The discrepancy is substantial for some treatment-year combinations. **Do not use the thesis A.14 chart as a validated summary of the 353 rows in `Evo_Sup`.** The worksheet might contain a subset, while the thesis could use different filtering or estimators. This is not resolved. The thesis chart remains labeled as a *thesis-reported aggregate* only.

## Height labels

The thesis Appendix Table A.18 gives Control 85.72 cm and SL-35 63.44 cm in 2023, while the workbook `Evo_Alt y Diam` associates SL-35 with 85.75 cm and Control with 63.45 cm. The current height chart follows the workbook. The source discrepancy is documented in [height results](height-results.md).

## Interpretation boundaries

No inferential tests have been rerun; the original R scripts have not been changed. The raw workbook is not public. The simple proportions above use only observed binary values in the specified columns and do not correct for experimental blocks, clustering, censoring, or different definitions of survival. Reconciliation requires a documented sampling-unit definition and comparison with the original analysis workflow.
