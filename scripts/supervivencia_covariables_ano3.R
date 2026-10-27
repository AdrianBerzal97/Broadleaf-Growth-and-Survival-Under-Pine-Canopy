# Year-3 survival GLM with binomial logit link.
# Select the Excel workbook in RStudio. Requires readxl and car.
# Response sup_3 must be 0/1 (1 = surviving, 0 = dead), or Vivo/Muerto.
# Original script did not specify covariates; adjust predictors below to
# reflect the actual scientific hypothesis and available Excel columns.

packages <- c("readxl", "car")
missing_packages <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages)) stop("Install packages: ", paste(missing_packages, collapse = ", "))
options(contrasts = c("contr.sum", "contr.poly"))

excel_file <- file.choose()
sheet_name <- 1  # Set the appropriate sheet if necessary.
sup <- as.data.frame(readxl::read_excel(excel_file, sheet = sheet_name))
names(sup) <- trimws(names(sup))
# Harmonize lower-case headings used in the original script.
for (name in c("especie", "bloque", "tratamiento")) {
  upper <- toupper(name)
  if (!(upper %in% names(sup)) && name %in% names(sup))
    names(sup)[names(sup) == name] <- upper
}
required <- c("sup_3", "ESPECIE", "BLOQUE", "TRATAMIENTO")
absent <- setdiff(required, names(sup))
if (length(absent)) stop("Missing Excel columns: ", paste(absent, collapse = ", "))

value <- tolower(trimws(as.character(sup$sup_3)))
value[value %in% c("vivo", "viva", "alive", "si", "sí")] <- "1"
value[value %in% c("muerto", "muerta", "dead", "no")] <- "0"
if (any(!is.na(value) & !(value %in% c("0", "1"))))
  stop("sup_3 must be coded as 0/1 or Vivo/Muerto. Check the Excel values.")
sup$sup_3 <- as.integer(value)
for (col in c("ESPECIE", "BLOQUE", "TRATAMIENTO")) sup[[col]] <- factor(sup[[col]])

# Add cobh.1 only if its meaning, coding and inclusion are scientifically justified.
predictors <- c("TRATAMIENTO", "ESPECIE", "BLOQUE")
# Example: predictors <- c(predictors, "cobh.1")
missing_predictors <- setdiff(predictors, names(sup))
if (length(missing_predictors)) stop("Missing predictors: ", paste(missing_predictors, collapse = ", "))
for (col in intersect("cobh.1", predictors)) sup[[col]] <- factor(sup[[col]])

df <- droplevels(stats::na.omit(sup[, c("sup_3", predictors), drop = FALSE]))
if (length(unique(df$sup_3)) < 2) stop("Both survival outcomes (0 and 1) are needed.")
for (col in predictors) {
  if (is.factor(df[[col]]) && nlevels(df[[col]]) < 2)
    stop("Predictor ", col, " has fewer than two observed levels.")
}
formula_glm <- stats::reformulate(predictors, response = "sup_3")
modelo_glm <- stats::glm(formula_glm, data = df,
                         family = stats::binomial(link = "logit"))
print(summary(modelo_glm))
print(car::Anova(modelo_glm, type = 3))
cat("\nOdds ratios (exp(coefficient)):\n")
print(exp(stats::coef(modelo_glm)))
cat("\nSample size:", nrow(df), "\n")
# Interpret coefficients and diagnostics before drawing conclusions.
