# Growth analysis: height and diameter in years 1 and 2
# Select the Excel workbook when prompted. Requires readxl, car, agricolae.
# Expected columns: BLOQUE, TRATAMIENTO, ESPECIE, alt_cero, diam_cero,
# alt_uno, diam_uno, alt_dos, diam_dos; optional Ramon.
# "Muerto" is treated as missing for growth analyses.

packages <- c("readxl", "car", "agricolae")
missing_packages <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages)) stop("Install packages: ", paste(missing_packages, collapse = ", "))
options(contrasts = c("contr.sum", "contr.poly"))

excel_file <- file.choose()
sheet_name <- 1  # Change to a sheet name or number if needed.
growth <- as.data.frame(readxl::read_excel(excel_file, sheet = sheet_name))
required <- c("BLOQUE", "TRATAMIENTO", "ESPECIE", "alt_cero", "diam_cero",
              "alt_uno", "diam_uno", "alt_dos", "diam_dos")
absent <- setdiff(required, names(growth))
if (length(absent)) stop("Missing Excel columns: ", paste(absent, collapse = ", "))

for (col in c("BLOQUE", "TRATAMIENTO", "ESPECIE")) growth[[col]] <- factor(growth[[col]])
measurements <- c("alt_cero", "diam_cero", "alt_uno", "diam_uno", "alt_dos", "diam_dos")
for (col in measurements) {
  value <- trimws(as.character(growth[[col]]))
  value[tolower(value) %in% c("muerto", "", "na", "nan")] <- NA_character_
  growth[[col]] <- suppressWarnings(as.numeric(gsub(",", ".", value, fixed = TRUE)))
}

# Rate units are per month: 11 months per observation interval, as in original script.
safe_rgr <- function(end, start, months) {
  out <- rep(NA_real_, length(end))
  ok <- !is.na(end) & !is.na(start) & end > 0 & start > 0
  out[ok] <- (log(end[ok]) - log(start[ok])) / months
  out
}

growth$IA_1 <- growth$alt_uno - growth$alt_cero
growth$ID_1 <- growth$diam_uno - growth$diam_cero
growth$TRCA_0_1 <- safe_rgr(growth$alt_uno, growth$alt_cero, 11)
growth$TRCD_0_1 <- safe_rgr(growth$diam_uno, growth$diam_cero, 11)
growth$IA_1_2 <- growth$alt_dos - growth$alt_uno
growth$IA_0_2 <- growth$alt_dos - growth$alt_cero
growth$ID_1_2 <- growth$diam_dos - growth$diam_uno
growth$ID_0_2 <- growth$diam_dos - growth$diam_cero
growth$TRCA_1_2 <- safe_rgr(growth$alt_dos, growth$alt_uno, 11)
growth$TRCA_0_2 <- safe_rgr(growth$alt_dos, growth$alt_cero, 22)
growth$TRCD_1_2 <- safe_rgr(growth$diam_dos, growth$diam_uno, 11)
growth$TRCD_0_2 <- safe_rgr(growth$diam_dos, growth$diam_cero, 22)

# For year 2, optionally exclude browsed plants, matching original exploratory analysis.
exclude_browsed_year2 <- TRUE
growth_y2 <- growth
if (exclude_browsed_year2 && "Ramon" %in% names(growth_y2)) {
  growth_y2 <- growth_y2[is.na(growth_y2$Ramon) |
                           tolower(trimws(as.character(growth_y2$Ramon))) != "si", ]
}

run_anova <- function(data, response, label) {
  cols <- c(response, "TRATAMIENTO", "ESPECIE", "BLOQUE")
  df <- stats::na.omit(data[, cols, drop = FALSE])
  df <- droplevels(df)
  if (nrow(df) < 5 || any(vapply(df[c("TRATAMIENTO", "ESPECIE", "BLOQUE")],
                                nlevels, integer(1)) < 2)) {
    message("Skipping ", label, ": insufficient complete observations or factor levels.")
    return(invisible(NULL))
  }
  model <- stats::lm(stats::reformulate(c("TRATAMIENTO * ESPECIE", "BLOQUE"),
                                        response = response), data = df)
  cat("\n=== ", label, " ===\n", sep = "")
  print(summary(model))
  print(car::Anova(model, type = 3))
  if (length(residuals(model)) >= 3 && length(residuals(model)) <= 5000)
    print(shapiro.test(residuals(model)))
  print(car::leveneTest(stats::reformulate("TRATAMIENTO * ESPECIE",
                                           response = response), data = df))
  if (df.residual(model) > 0) {
    print(agricolae::HSD.test(model, "ESPECIE", group = TRUE)$groups)
    print(agricolae::HSD.test(model, "TRATAMIENTO", group = TRUE)$groups)
  }
  invisible(model)
}

# Edit the response variables here to run other analyses from the original study.
model_year1_height <- run_anova(growth, "alt_uno", "Year 1 height")
model_year1_diameter <- run_anova(growth, "diam_uno", "Year 1 diameter")
model_year2_height <- run_anova(growth_y2, "alt_dos", "Year 2 height")
model_year2_diameter <- run_anova(growth_y2, "diam_dos", "Year 2 diameter")

summary_by_group <- function(data, response, group) {
  aggregate(data[[response]], by = list(group = data[[group]]),
            FUN = function(x) c(n = sum(!is.na(x)), mean = mean(x, na.rm = TRUE),
                                sd = sd(x, na.rm = TRUE)))
}
print(summary_by_group(growth, "TRCD_0_1", "TRATAMIENTO"))
print(summary_by_group(growth_y2, "TRCA_0_2", "ESPECIE"))
# Objects and results remain in the RStudio session. No output files are written.
