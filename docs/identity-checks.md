# Cross-sheet identity checks — revised

**Correction (22 October 2026):** Earlier claims that all 401 plant identities matched across the combined and 2023 worksheets, and that only two numeric measurement conflicts remained, were premature. Those results depended on an unverified mapping of unlabeled columns in the combined worksheet. They must not be cited as validated findings.

## Verified sheet structure

- `Año 3 (2023)` contains 401 unique records using the explicit columns `bloque`, `tratamiento`, `especie`, `individuo`.
- `Evo_Sup` contains 353 unique records using `Bloque`, `Tratamiento`, `Especie`, `Planta`.
- With treatment spellings normalized, 351 provisional keys overlap. Of those, 217 survival statuses agree and 134 disagree (70 longitudinal dead / 2023 alive; 64 longitudinal alive / 2023 dead).
- The combined worksheet has 401 records, but its columns D–G have no explicit headers in the visible header row. Their semantic mapping to `individuo`, `fila`, `seccion`, `posicion` is **not established**. Do not use a positional join to claim individual-level measurement agreement.

## Independent survival calculation

The 2023 worksheet contains 327 alive and 74 dead records (401 total). By treatment:

| Treatment | Alive | Total | Percentage |
|---|---:|---:|---:|
| CB-20 | 56 | 74 | 75.68% |
| CB-35 | 115 | 138 | 83.33% |
| Control | 58 | 77 | 75.32% |
| SL-35 | 98 | 112 | 87.50% |

These are direct unfiltered proportions from `Año 3 (2023)`, **not** reproductions of the thesis treatment survival estimates. The thesis uses different values, and its inclusion rules/denominators are not established.

## R script inspection

The survival R script imports a clipboard table, then fits an incomplete formula `glm(sup_3~, ...)`; its model cannot be reproduced as written. The growth R script also reads from the clipboard and references an undefined `growth_2_alt` object in its year-2 section. Its year-2 `lm` call also contains mismatched parentheses. The original scripts remain untouched.

## Status

Reproducibility remains partial. No original observations or raw data have been uploaded to this repository, and no statistical significance claims have been independently validated.
