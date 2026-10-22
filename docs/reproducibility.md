# Reproducibility audit — preliminary

## Available research artifacts (not yet distributed)

- `Anova_crecimiento_año_1 y 2.R`: original growth-analysis script.
- `Supervivencia y covariables_Año3.R`: original survival-analysis script.

## Known execution and publication barriers

- The growth script imports data using `read.table("clipboard", ...)`, so a documented file-based input and column schema are not yet available.
- The growth script includes a local Windows path, which should be reviewed before publication.
- The supplied survival script contains `glm(sup_3~, ...)`, an incomplete model formula; this version cannot be run as written.
- Redistribution permissions for the original research code should be confirmed.
- No claim is made that outputs were regenerated, that packages were installed, or that models were validated.

## Requirements before a reproducible release

1. Verify the workbook's sheets, columns, coding, missing values and provenance against the thesis.
2. Confirm data and code publication permissions, particularly for individual measurements and site information.
3. Preserve the original scripts and build separate **adapted** scripts under `src/reproducible/` if permitted.
4. Run and compare results against thesis tables and figures, reporting discrepancies transparently.
5. Publish only verified aggregate tables or figures and a clear data-availability statement.
