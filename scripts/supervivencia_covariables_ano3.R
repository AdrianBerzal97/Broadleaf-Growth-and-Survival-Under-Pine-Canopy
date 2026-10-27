# Year-3 survival: logistic regression using the original Excel sheet.
# Sheet "Supervivencia (2023)": row 1 contains group headings, row 2 headers.
# Response sup_3: 1 = alive, 0 = dead. The model is exploratory;
# covariate selection should follow the study's scientific design.

for (pkg in c("readxl", "car")) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop("Install missing package: ", pkg)
}
options(contrasts = c("contr.sum", "contr.poly"))
excel_file <- file.choose()
sup <- as.data.frame(readxl::read_excel(
  excel_file, sheet = "Supervivencia (2023)", skip = 1,
  .name_repair = "unique", guess_max = 5000))
names(sup) <- trimws(names(sup))
required <- c("bloque", "tratamiento", "especie", "sup_3")
missing <- setdiff(required, names(sup))
if (length(missing)) stop("Missing columns: ", paste(missing, collapse = ", "))
names(sup)[match(c("bloque", "tratamiento", "especie"), names(sup))] <-
  c("BLOQUE", "TRATAMIENTO", "ESPECIE")
for (nm in c("BLOQUE", "TRATAMIENTO", "ESPECIE")) sup[[nm]] <- factor(sup[[nm]])
response <- tolower(trimws(as.character(sup$sup_3)))
response[response %in% c("vivo", "viva", "sí", "si")] <- "1"
response[response %in% c("muerto", "muerta", "no")] <- "0"
if (any(!is.na(response) & !(response %in% c("0", "1"))))
  stop("Unexpected survival values in sup_3.")
sup$sup_3 <- as.integer(response)
# Main experimental factors. Additional variables available in the workbook:
# cobh, alturah, cobl, altural, C_TOTAL, GSF, indice, indice A.
# Do not automatically include all covariates: some may be collinear.
predictors <- c("TRATAMIENTO", "ESPECIE", "BLOQUE")
df <- droplevels(stats::na.omit(sup[, c("sup_3", predictors), drop = FALSE]))
if (length(unique(df$sup_3)) != 2) stop("Need both survival outcomes.")
for (nm in predictors)
  if (nlevels(df[[nm]]) < 2) stop("Insufficient factor levels: ", nm)
modelo_glm <- stats::glm(stats::reformulate(predictors, response = "sup_3"),
                         data = df, family = stats::binomial("logit"))
print(summary(modelo_glm))
print(car::Anova(modelo_glm, type = 3))
cat("\nOdds ratios:\n")
print(exp(stats::coef(modelo_glm)))
cat("\nComplete cases:", nrow(df), "\n")
# Inspect separation, model diagnostics, and experimental dependence before inference.
