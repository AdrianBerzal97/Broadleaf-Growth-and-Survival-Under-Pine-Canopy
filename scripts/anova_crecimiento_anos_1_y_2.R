# ANOVA: growth in height and diameter, years 1 and 2
# Source: sheet "Completo 2018, 19 y 23" in the study Excel workbook.
# Note: workbook row 1 contains group headings; column headers are on row 2.
# The basal columns are not labelled in the Excel file; no basal growth
# rates are calculated until those columns and time intervals are confirmed.

for (pkg in c("readxl", "car", "agricolae")) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop("Install missing package: ", pkg)
}
options(contrasts = c("contr.sum", "contr.poly"))
excel_file <- file.choose()
growth <- as.data.frame(readxl::read_excel(
  excel_file, sheet = "Completo 2018, 19 y 23", skip = 1,
  .name_repair = "unique", guess_max = 5000))
names(growth) <- trimws(names(growth))
required <- c("bloque", "tratamiento", "especie", "Alt_1", "Diam_1", "Alt_2", "Diam_2")
missing <- setdiff(required, names(growth))
if (length(missing)) stop("Missing columns: ", paste(missing, collapse = ", "))
names(growth)[match(c("bloque", "tratamiento", "especie"), names(growth))] <-
  c("BLOQUE", "TRATAMIENTO", "ESPECIE")
for (nm in c("BLOQUE", "TRATAMIENTO", "ESPECIE")) growth[[nm]] <- factor(growth[[nm]])
as_measurement <- function(x) {
  x <- trimws(as.character(x))
  x[tolower(x) %in% c("muerto", "muerta", "", "na", "nan")] <- NA_character_
  suppressWarnings(as.numeric(gsub(",", ".", x, fixed = TRUE)))
}
for (nm in c("Alt_1", "Diam_1", "Alt_2", "Diam_2"))
  growth[[nm]] <- as_measurement(growth[[nm]])
growth$IA_1_2 <- growth$Alt_2 - growth$Alt_1
growth$ID_1_2 <- growth$Diam_2 - growth$Diam_1
safe_rgr <- function(end, start, months = 11) {
  result <- rep(NA_real_, length(end))
  valid <- !is.na(end) & !is.na(start) & end > 0 & start > 0
  result[valid] <- (log(end[valid]) - log(start[valid])) / months
  result
}
growth$TRCA_1_2 <- safe_rgr(growth$Alt_2, growth$Alt_1)
growth$TRCD_1_2 <- safe_rgr(growth$Diam_2, growth$Diam_1)

run_anova <- function(data, response) {
  variables <- c(response, "TRATAMIENTO", "ESPECIE", "BLOQUE")
  df <- droplevels(stats::na.omit(data[, variables, drop = FALSE]))
  if (nrow(df) < 5 || any(vapply(df[c("TRATAMIENTO", "ESPECIE", "BLOQUE")],
                                nlevels, integer(1)) < 2)) {
    warning("Insufficient data/factor levels for ", response)
    return(invisible(NULL))
  }
  form <- stats::reformulate(c("TRATAMIENTO * ESPECIE", "BLOQUE"), response)
  model <- stats::lm(form, data = df)
  cat("\n===== ", response, " =====\n", sep = "")
  print(summary(model))
  print(car::Anova(model, type = 3))
  if (df.residual(model) > 0) {
    print(car::leveneTest(stats::reformulate("TRATAMIENTO * ESPECIE", response),
                          data = df))
    n <- length(stats::residuals(model))
    if (n >= 3 && n <= 5000) print(stats::shapiro.test(stats::residuals(model)))
    print(agricolae::HSD.test(model, "ESPECIE", group = TRUE)$groups)
    print(agricolae::HSD.test(model, "TRATAMIENTO", group = TRUE)$groups)
  }
  invisible(model)
}
models <- list(
  height_year1 = run_anova(growth, "Alt_1"),
  diameter_year1 = run_anova(growth, "Diam_1"),
  height_year2 = run_anova(growth, "Alt_2"),
  diameter_year2 = run_anova(growth, "Diam_2"),
  absolute_height_increment = run_anova(growth, "IA_1_2"),
  absolute_diameter_increment = run_anova(growth, "ID_1_2"),
  relative_height_growth = run_anova(growth, "TRCA_1_2"),
  relative_diameter_growth = run_anova(growth, "TRCD_1_2")
)
# The workbook does not identify a browsing column unambiguously;
# no browsing-based exclusion is performed in this version.
