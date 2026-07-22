# --- tidytuesday::2629 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-07-21/readme.md

# setup ----

# library path
.libPaths("~/.local/share/R/x86_64-pc-linux-gnu-library/4.6")

# sanity check
pak::pkg_deps_tree()
pak::pkg_outdated()

# check requirements for specific packages
pak::pkg_sysreqs("ggraph")
pak::pkg_sysreqs("tidyverse")

# check requirements for ALL outdated packages
outdated <- pak::pkg_outdated()
if (nrow(outdated) > 0) {
  pak::pkg_sysreqs(outdated$package)
}
# if pak outputs pacman -s ... commands, run them in your terminal first.

pak::pkg_update(ask = FALSE, check_installed = TRUE)

# check: pak::pkg_outdated()
# verify sysreqs: pak::pkg_sysreqs(pak::pkg_outdated()$package) → install any listed system packages via pacman
# update: pak::pkg_update(ask = false, check_installed = true)
# load: keep using pacman::p_load(...) in your scripts

# load
pacman::p_load(
  broom, # https://cran.r-project.org/web/packages/broom/
  corrplot, # https://cran.r-project.org/web/packages/corrplot/
  data.table, # https://cran.r-project.org/web/packages/data.table/
  igraph, # https://cran.r-project.org/web/packages/igraph/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-21/nde_experiences.csv'
  ) |>
  clean_names()
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-07-21/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# ...

# This week we're exploring near-death experiences (NDEs) reported to the Near
# Death Experience Research Foundation (NDERF). The dataset contains 589
# individual NDE records scraped from the NDERF Search site, which embeds
# structured JSON metadata for each experience. Each record includes
# demographics, a Greyson NDE Scale score, and AI-detected experience features.
# No narrative text is included in the extracted dataset, respecting NDERF's
# copyright.

# Near-death experiences are reported by 10–23% of cardiac arrest survivors in
# prospective studies. They typically involve out-of-body perception, a feeling
# of peace, seeing a bright light, and encountering deceased relatives. The
# Greyson NDE Scale (0–32) is the standard validated instrument for measuring
# NDE depth. Score of 7 or higher indicates a genuine NDE.

# > "62 patients (18%) reported NDE, of whom 41 (12%) described a core
# > experience. Occurrence of the experience was not associated with duration of
# > cardiac arrest or unconsciousness, medication, or fear of death before
# > cardiac arrest." — Van Lommel et al. 2001, The Lancet

# - What features most commonly co-occur in NDEs?
# - Are out-of-body experiences correlated with ESP or unity?
# - How does the Greyson score distribution differ between genders or countries?
# - Are distressing NDEs more common in certain demographics or time periods?
# - How has the rate of NDERF submissions changed over time (1999–2025)?
# - Do deeper NDEs (higher Greyson scores) tend to have longer narratives?

# Logistic Regression with ggplot2 S-Curve Visualization
# Using NDE narratives dataset

# ---- 1. Setup and Data Preparation ----
library(tidyverse)
library(broom)

# Load your data (assuming CSV with the structure you described)
nde_data <- read_csv("nde_narratives.csv")

# Create binary outcome if needed:
# 1 = "True" (e.g., validated NDE), 0 = "False" (questionable)
nde_data <- df %>%
  mutate(
    outcome = ifelse(classification %in% c("NDE", "Probable NDE"), 1, 0),
    # Standardize predictors for easier interpretation
    greyson_std = scale(greyson_score)[, 1],
    narrative_length_std = scale(narrative_length)[, 1]
  )

# ---- 2. Fit Logistic Regression Models ----

# Model 1: Simple (univariate) - Greyson score only
model_simple <- glm(outcome ~ greyson_score, 
                    family = binomial(link = "logit"), 
                    data = nde_data)

# Model 2: Multiple predictors
model_full <- glm(outcome ~ greyson_score + narrative_length + ai_clinical + ai_obe,
                  family = binomial(link = "logit"),
                  data = nde_data)

# Summary statistics
summary(model_simple)
summary(model_full)

# ---- 3. Extract Model Coefficients ----
tidy(model_simple)
tidy(model_full)

# Odds ratios (exponential of coefficients)
tidy(model_simple) %>% 
  mutate(odds_ratio = exp(estimate))

# ---- 4. Generate Predictions for S-Curve Plotting ----

# Create a sequence of greyson_score values across the observed range
prediction_data <- tibble(
  greyson_score = seq(0, 32, by = 0.5),
  narrative_length = median(nde_data$narrative_length, na.rm = TRUE),
  ai_clinical = FALSE,
  ai_obe = FALSE
) %>%
  mutate(
    pred_prob = predict(model_full, newdata = ., type = "response"),
    pred_se = predict(model_full, newdata = ., type = "response", se.fit = TRUE)$se.fit,
    ci_lower = pred_prob - 1.96 * pred_se,
    ci_upper = pred_prob + 1.96 * pred_se
  )

# ---- 5. S-Curve Visualization ----

p1 <- ggplot(nde_data, aes(x = greyson_score, y = outcome)) +
  # Raw data points with jitter
  geom_jitter(height = 0.05, alpha = 0.3, size = 2, color = "#3987e5") +
  
  # Predicted probability curve
  geom_line(data = prediction_data, 
            aes(x = greyson_score, y = pred_prob), 
            color = "#d95926", 
            linewidth = 1.2,
            inherit.aes = FALSE) +
  
  # Confidence interval band
  geom_ribbon(data = prediction_data,
              aes(x = greyson_score, ymin = ci_lower, ymax = ci_upper),
              alpha = 0.2, 
              fill = "#d95926",
              inherit.aes = FALSE) +
  
  labs(
    title = "Logistic Regression: Probability of Validated NDE",
    subtitle = "S-curve showing how Greyson score predicts classification",
    x = "Greyson NDE Scale (0–32)",
    y = "Probability of True Classification (0–1)",
    caption = "Blue points = observed data (jittered); Orange line = predicted probability; Shaded area = 95% CI"
  ) +
  scale_y_continuous(limits = c(-0.05, 1.05), breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(breaks = seq(0, 32, 4)) +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#e1e0d9"),
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12, color = "#898781"),
    axis.title = element_text(size = 11),
    plot.caption = element_text(size = 10, color = "#c3c2b7")
  )

print(p1)

ggsave("logistic_regression_s_curve.png", p1, width = 8, height = 5, dpi = 300)

# ---- 6. Multiple Predictors: Faceted S-Curves ----

# Show S-curve at different levels of narrative_length
prediction_data_facet <- expand_grid(
  greyson_score = seq(0, 32, by = 0.5),
  narrative_length = quantile(nde_data$narrative_length, c(0.25, 0.5, 0.75), na.rm = TRUE),
  ai_clinical = FALSE,
  ai_obe = FALSE
) %>%
  mutate(
    pred_prob = predict(model_full, newdata = ., type = "response"),
    narrative_group = case_when(
      narrative_length == quantile(nde_data$narrative_length, 0.25, na.rm = TRUE) ~ "Short (Q1)",
      narrative_length == quantile(nde_data$narrative_length, 0.5, na.rm = TRUE) ~ "Medium (Q2)",
      narrative_length == quantile(nde_data$narrative_length, 0.75, na.rm = TRUE) ~ "Long (Q3)"
    )
  )

p2 <- ggplot(prediction_data_facet, aes(x = greyson_score, y = pred_prob, color = narrative_group)) +
  geom_line(linewidth = 1.2) +
  facet_wrap(~ narrative_group, ncol = 3) +
  labs(
    title = "Effect of Narrative Length on Classification Probability",
    subtitle = "S-curves shift based on how detailed the account is",
    x = "Greyson Score",
    y = "P(Validated NDE)"
  ) +
  scale_y_continuous(limits = c(0, 1)) +
  scale_color_manual(values = c("#3987e5", "#1baf7a", "#e87ba4"), guide = "none") +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", size = 11)
  )

print(p2)

# ---- 7. Diagnostic Plots ----

# Residuals vs Fitted
p3 <- broom::augment(model_full) %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point(alpha = 0.4, color = "#3987e5") +
  geom_smooth(se = FALSE, color = "#d95926", method = "loess") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "#898781") +
  labs(
    title = "Residual Plot",
    x = "Fitted Probability",
    y = "Residuals"
  ) +
  theme_minimal()

print(p3)

# ---- 8. Model Comparison ----

# Compare simple vs. full model
anova(model_simple, model_full, test = "Chisq")

# AIC
AIC(model_simple, model_full)

# ---- 9. Classification Performance ----

# Add predicted class (threshold = 0.5)
nde_data <- nde_data %>%
  mutate(
    pred_prob = predict(model_full, type = "response"),
    pred_class = ifelse(pred_prob > 0.5, 1, 0)
  )

# Confusion matrix
table(Actual = nde_data$outcome, Predicted = nde_data$pred_class)

# Sensitivity, Specificity, Accuracy
nde_data %>%
  summarise(
    accuracy = mean(outcome == pred_class, na.rm = TRUE),
    sensitivity = sum(outcome == 1 & pred_class == 1, na.rm = TRUE) / sum(outcome == 1, na.rm = TRUE),
    specificity = sum(outcome == 0 & pred_class == 0, na.rm = TRUE) / sum(outcome == 0, na.rm = TRUE)
  )

# ---- 10. Interpretation Tips ----
# 
# 1. Coefficients in logistic regression are in LOG-ODDS scale:
#    - exp(coefficient) = odds ratio
#    - If greyson_score coef = 0.15, then exp(0.15) ≈ 1.16
#    - Each 1-unit increase in Greyson score multiplies the odds by 1.16
#
# 2. The S-curve is centered at the point where P = 0.5 (the inflection point)
#    - This is where the model has maximum uncertainty
#    - Steepness reflects how much the predictor changes the odds
#
# 3. Your binary outcome is the AI's classification (true/false)
#    - The logistic model learns what features correlate with that label
#    - High greyson_score + detailed narrative → higher predicted "true"
#
# -----------------------------------------------------

# What features most commonly co-occur in NDEs?
#   Are out-of-body experiences correlated with ESP or unity?
# Feature Co-occurrence Analysis in NDE Narratives
# Exploring which AI-detected features cluster together

# ---- 2. Extract AI Feature Columns ----
ai_features <- nde_data %>%
  select(starts_with("ai_")) %>%
  # Convert logical to numeric for correlation
  mutate(across(everything(), as.numeric))

# Feature names (clean labels)
feature_labels <- c(
  ai_obe = "Out-of-Body",
  ai_unity = "Unity/Oneness",
  ai_hellish = "Hellish/Distressing",
  ai_clinical = "Clinical Death",
  ai_esp = "ESP/Clairvoyance",
  ai_past_lives = "Past Lives",
  ai_world_future = "World Future",
  ai_aliens = "Aliens"
)

colnames(ai_features) <- feature_labels[colnames(ai_features)]

# ---- 3. Correlation Matrix ----
corr_matrix <- cor(ai_features, use = "complete.obs")

# Plot correlation heatmap
png("nde_feature_correlations.png", width = 800, height = 700)

corrplot(corr_matrix, 
         method = "color", 
         type = "upper",
         tl.col = "black",
         tl.srt = 45,
         addCoef.col = "black",
         number.cex = 0.8,
         col = colorRampPalette(c("#d95926", "white", "#3987e5"))(200),
         main = "Feature Co-occurrence Correlation Matrix",
         mar = c(4, 2, 2, 2))
dev.off()

print("Correlation matrix (full):")
print(corr_matrix)

# ---- 4. Pairwise Correlations: Focus on OBE, ESP, Unity ----
target_features <- c("Out-of-Body", "ESP/Clairvoyance", "Unity/Oneness")

correlations_long <- corr_matrix %>%
  as.data.frame() %>%
  rownames_to_column("feature1") %>%
  pivot_longer(-feature1, names_to = "feature2", values_to = "correlation") %>%
  filter(feature1 %in% target_features | feature2 %in% target_features) %>%
  filter(feature1 != feature2) %>%
  arrange(desc(abs(correlation)))

print("\nStrongest correlations with OBE, ESP, and Unity:")
print(correlations_long)

# ---- 5. Co-occurrence Frequency Table ----
# How often do features appear together?

cooccurrence <- data.frame(
  Pair = character(),
  Both_Present = numeric(),
  Percent = numeric(),
  Correlation = numeric()
)

feature_cols <- colnames(ai_features)
for (i in 1:(length(feature_cols)-1)) {
  for (j in (i+1):length(feature_cols)) {
    feat1 <- feature_cols[i]
    feat2 <- feature_cols[j]
    
    both <- sum(ai_features[[feat1]] == 1 & ai_features[[feat2]] == 1, na.rm = TRUE)
    total <- sum(!is.na(ai_features[[feat1]]) & !is.na(ai_features[[feat2]]))
    pct <- (both / total) * 100
    corr <- corr_matrix[feat1, feat2]
    
    cooccurrence <- rbind(cooccurrence, data.frame(
      Pair = paste(feat1, "×", feat2),
      Both_Present = both,
      Percent = pct,
      Correlation = corr
    ))
  }
}

cooccurrence <- cooccurrence %>%
  arrange(desc(Percent))

print("\nTop 10 most common feature pairs:")
print(head(cooccurrence, 10))

# ---- 6. Specific Comparisons ----
# OBE vs ESP
obe_esp_table <- table(
  OBE = ai_features$`Out-of-Body`,
  ESP = ai_features$`ESP/Clairvoyance`
)
print("\nOBE × ESP co-occurrence table:")
print(obe_esp_table)

# OBE vs Unity
obe_unity_table <- table(
  OBE = ai_features$`Out-of-Body`,
  Unity = ai_features$`Unity/Oneness`
)
print("\nOBE × Unity co-occurrence table:")
print(obe_unity_table)

# ESP vs Unity
esp_unity_table <- table(
  ESP = ai_features$`ESP/Clairvoyance`,
  Unity = ai_features$`Unity/Oneness`
)
print("\nESP × Unity co-occurrence table:")
print(esp_unity_table)

# ---- 7. Chi-square Tests for Independence ----
print("\n--- Chi-Square Tests for Independence ---")

# OBE vs ESP
chi_obe_esp <- chisq.test(obe_esp_table)
print(paste("OBE vs ESP: χ² =", round(chi_obe_esp$statistic, 3), 
            ", p =", round(chi_obe_esp$p.value, 4)))

# OBE vs Unity
chi_obe_unity <- chisq.test(obe_unity_table)
print(paste("OBE vs Unity: χ² =", round(chi_obe_unity$statistic, 3), 
            ", p =", round(chi_obe_unity$p.value, 4)))

# ESP vs Unity
chi_esp_unity <- chisq.test(esp_unity_table)
print(paste("ESP vs Unity: χ² =", round(chi_esp_unity$statistic, 3), 
            ", p =", round(chi_esp_unity$p.value, 4)))

# ---- 8. Feature Prevalence (Baseline) ----
feature_prevalence <- ai_features %>%
  summarise(across(everything(), list(
    n = ~sum(. == 1, na.rm = TRUE),
    pct = ~mean(. == 1, na.rm = TRUE) * 100
  ))) %>%
  pivot_longer(everything()) %>%
  separate(name, into = c("feature", "stat"), sep = "_") %>%
  pivot_wider(names_from = stat, values_from = value) %>%
  arrange(desc(pct))

print("\nFeature prevalence across all narratives:")
print(feature_prevalence)

# ---- 9. Visualize Co-occurrence Network ----
# Strong correlations (r > 0.2) form a network

strong_corr <- correlations_long %>%
  filter(abs(correlation) > 0.2)

if (nrow(strong_corr) > 0) {
  # Build adjacency matrix for network graph
  features_in_network <- unique(c(strong_corr$feature1, strong_corr$feature2))
  
  adj_matrix <- matrix(0, nrow = length(features_in_network), 
                       ncol = length(features_in_network))
  rownames(adj_matrix) <- colnames(adj_matrix) <- features_in_network
  
  for (i in 1:nrow(strong_corr)) {
    f1 <- strong_corr$feature1[i]
    f2 <- strong_corr$feature2[i]
    r <- strong_corr$correlation[i]
    adj_matrix[f1, f2] <- abs(r)
    adj_matrix[f2, f1] <- abs(r)
  }
  
  # Create and plot network
  g <- graph_from_adjacency_matrix(adj_matrix, mode = "undirected", 
                                   weighted = TRUE, diag = FALSE)
  
  png("nde_feature_network.png", width = 900, height = 900)
  plot(g, 
       vertex.size = 20,
       vertex.label.cex = 0.9,
       vertex.label.dist = 2,
       edge.width = E(g)$weight * 5,
       edge.color = rgb(0.3, 0.3, 0.3, 0.6),
       layout = layout_with_fr(g),
       main = "NDE Feature Co-occurrence Network\n(edges = correlations > 0.2)")
  dev.off()
  
  print("\nFeatures with strong co-occurrence (r > 0.2):")
  print(strong_corr)
} else {
  print("\nNo strong correlations (r > 0.2) found between features.")
}

# ---- 10. Conditional Probabilities ----
# P(ESP | OBE) vs P(ESP)
prob_esp <- mean(ai_features$`ESP/Clairvoyance` == 1, na.rm = TRUE)
prob_esp_given_obe <- mean(
  ai_features$`ESP/Clairvoyance`[ai_features$`Out-of-Body` == 1] == 1, 
  na.rm = TRUE
)

prob_unity <- mean(ai_features$`Unity/Oneness` == 1, na.rm = TRUE)
prob_unity_given_obe <- mean(
  ai_features$`Unity/Oneness`[ai_features$`Out-of-Body` == 1] == 1, 
  na.rm = TRUE
)

print("\n--- Conditional Probabilities ---")
print(paste("P(ESP) =", round(prob_esp, 3)))
print(paste("P(ESP | OBE) =", round(prob_esp_given_obe, 3)))
print(paste("Lift (ESP given OBE):", round(prob_esp_given_obe / prob_esp, 2), "×"))
print()
print(paste("P(Unity) =", round(prob_unity, 3)))
print(paste("P(Unity | OBE) =", round(prob_unity_given_obe, 3)))
print(paste("Lift (Unity given OBE):", round(prob_unity_given_obe / prob_unity, 2), "×"))

# ---- 11. Interpretation Summary ----
cat("\n========================================\n")
cat("INTERPRETATION SUMMARY\n")
cat("========================================\n\n")

# Find strongest correlations
strongest <- correlations_long %>%
  arrange(desc(abs(correlation))) %>%
  head(5)

cat("Top 5 strongest feature correlations:\n")
for (i in 1:nrow(strongest)) {
  feat1 <- strongest$feature1[i]
  feat2 <- strongest$feature2[i]
  r <- strongest$correlation[i]
  direction <- ifelse(r > 0, "co-occur", "inversely related")
  cat(sprintf("%d. %s ↔ %s (r = %.3f, %s)\n", i, feat1, feat2, r, direction))
}

cat("\nInterpretation:\n")
if (prob_esp_given_obe > prob_esp * 1.5) {
  cat("✓ ESP is MORE likely in OBE experiences\n")
} else if (prob_esp_given_obe < prob_esp * 0.5) {
  cat("✗ ESP is LESS likely in OBE experiences\n")
} else {
  cat("- ESP likelihood is similar in OBE and non-OBE experiences\n")
}

if (prob_unity_given_obe > prob_unity * 1.5) {
  cat("✓ Unity/Oneness is MORE likely in OBE experiences\n")
} else if (prob_unity_given_obe < prob_unity * 0.5) {
  cat("✗ Unity/Oneness is LESS likely in OBE experiences\n")
} else {
  cat("- Unity/Oneness likelihood is similar in OBE and non-OBE experiences\n")
}

# -----------------------------------------------------

# Greyson Score Distribution by Gender and Country
# Simple exploratory analysis

library(tidyverse)

# ---- 1. Load Data ----
nde_data <- read_csv("nde_narratives.csv")

# ---- 2. Greyson Score by Gender ----
print("=== GREYSON SCORE BY GENDER ===\n")

gender_stats <- nde_data %>%
  group_by(gender) %>%
  summarise(
    n = n(),
    mean = mean(greyson_score, na.rm = TRUE),
    median = median(greyson_score, na.rm = TRUE),
    sd = sd(greyson_score, na.rm = TRUE),
    min = min(greyson_score, na.rm = TRUE),
    max = max(greyson_score, na.rm = TRUE),
    .groups = "drop"
  )

print(gender_stats)

# ---- 3. Visualization: Greyson by Gender ----
p_gender <- ggplot(nde_data, aes(x = gender, y = greyson_score, fill = gender)) +
  geom_boxplot(alpha = 0.6, outlier.alpha = 0.3) +
  geom_jitter(width = 0.2, alpha = 0.2, size = 1.5) +
  labs(
    title = "Greyson NDE Scale Score by Gender",
    x = "Gender",
    y = "Greyson Score (0–32)",
    fill = "Gender"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank()
  )

print(p_gender)
ggsave("greyson_by_gender_boxplot.png", p_gender, width = 6, height = 5, dpi = 300)

# ---- 4. Density plot by gender ----
p_gender_density <- ggplot(nde_data, aes(x = greyson_score, fill = gender)) +
  geom_density(alpha = 0.5) +
  labs(
    title = "Greyson Score Distribution by Gender",
    x = "Greyson Score",
    y = "Density",
    fill = "Gender"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 14, face = "bold"))

print(p_gender_density)
ggsave("greyson_by_gender_density.png", p_gender_density, width = 7, height = 5, dpi = 300)

# ---- 5. T-test: Gender difference ----
male_scores <- nde_data$greyson_score[nde_data$gender == "M"]
female_scores <- nde_data$greyson_score[nde_data$gender == "F"]

t_test <- t.test(male_scores, female_scores, na.rm = TRUE)
print("\nT-test (Male vs Female):")
print(t_test)

# ---- 6. Greyson Score by Country ----
print("\n=== GREYSON SCORE BY COUNTRY ===\n")

country_stats <- nde_data %>%
  group_by(country) %>%
  summarise(
    n = n(),
    mean = mean(greyson_score, na.rm = TRUE),
    median = median(greyson_score, na.rm = TRUE),
    sd = sd(greyson_score, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(n)) %>%
  filter(n >= 10)  # Only countries with 10+ observations

print("Top countries by sample size (n ≥ 10):")
print(country_stats)

# ---- 7. Visualization: Greyson by Top Countries ----
# Focus on countries with enough data
top_countries <- country_stats %>%
  arrange(desc(n)) %>%
  slice(1:10) %>%
  pull(country)

nde_top_countries <- nde_data %>%
  filter(country %in% top_countries)

p_country <- ggplot(nde_top_countries, aes(x = reorder(country, greyson_score, FUN = median), 
                                           y = greyson_score, fill = country)) +
  geom_boxplot(alpha = 0.6, outlier.alpha = 0.3, show.legend = FALSE) +
  geom_jitter(width = 0.2, alpha = 0.15, size = 1) +
  labs(
    title = "Greyson Score by Country (Top 10 by Sample Size)",
    x = "Country",
    y = "Greyson Score (0–32)"
  ) +
  coord_flip() +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank()
  )

print(p_country)
ggsave("greyson_by_country_boxplot.png", p_country, width = 8, height = 6, dpi = 300)

# ---- 8. ANOVA: Country effect ----
nde_top_countries_clean <- nde_top_countries %>%
  filter(!is.na(greyson_score))

aov_country <- aov(greyson_score ~ country, data = nde_top_countries_clean)
print("\nANOVA (Country effect on Greyson score):")
print(summary(aov_country))

# ---- 9. Summary Table ----
print("\n=== SUMMARY ===\n")
print(paste("Total records:", nrow(nde_data)))
print(paste("Gender distribution (M/F):", 
            sum(nde_data$gender == "M", na.rm = TRUE), "/",
            sum(nde_data$gender == "F", na.rm = TRUE)))
print(paste("Unique countries:", n_distinct(nde_data$country)))
print(paste("\nOverall Greyson score mean:", 
            round(mean(nde_data$greyson_score, na.rm = TRUE), 2)))
print(paste("Overall Greyson score median:", 
            round(median(nde_data$greyson_score, na.rm = TRUE), 2)))
print(paste("Overall Greyson score SD:", 
            round(sd(nde_data$greyson_score, na.rm = TRUE), 2)))

# -----------------------------------------------------

# Are distressing NDEs more common in certain demographics or time periods?

# Distressing NDEs by Demographics and Time Period
# Simple exploratory analysis

library(tidyverse)

# ---- 1. Load Data ----
nde_data <- read_csv("nde_narratives.csv")

# ---- 2. Extract Year from Dates ----
nde_data <- nde_data %>%
  mutate(
    exp_year = year(exp_date),
    post_year = year(post_date),
    hellish = as.numeric(ai_hellish)  # Convert logical to numeric
  )

# ---- 3. Distressing NDEs by Gender ----
print("=== DISTRESSING NDEs BY GENDER ===\n")

gender_hellish <- nde_data %>%
  group_by(gender) %>%
  summarise(
    n = n(),
    n_hellish = sum(hellish, na.rm = TRUE),
    pct_hellish = mean(hellish, na.rm = TRUE) * 100,
    .groups = "drop"
  )

print(gender_hellish)

# ---- 4. Visualization: Distressing by Gender ----
p_gender_hellish <- ggplot(gender_hellish, aes(x = gender, y = pct_hellish, fill = gender)) +
  geom_col(alpha = 0.7, show.legend = FALSE) +
  geom_text(aes(label = paste0(round(pct_hellish, 1), "%")), 
            vjust = -0.5, size = 4, fontface = "bold") +
  labs(
    title = "Prevalence of Distressing NDEs by Gender",
    x = "Gender",
    y = "% with Distressing Content"
  ) +
  scale_y_continuous(limits = c(0, max(gender_hellish$pct_hellish) * 1.15)) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank()
  )

print(p_gender_hellish)
ggsave("distressing_by_gender.png", p_gender_hellish, width = 6, height = 5, dpi = 300)

# ---- 5. Distressing NDEs by Top Countries ----
print("\n=== DISTRESSING NDEs BY COUNTRY ===\n")

country_hellish <- nde_data %>%
  group_by(country) %>%
  summarise(
    n = n(),
    n_hellish = sum(hellish, na.rm = TRUE),
    pct_hellish = mean(hellish, na.rm = TRUE) * 100,
    .groups = "drop"
  ) %>%
  filter(n >= 10) %>%
  arrange(desc(n))

print("Top countries (n ≥ 10):")
print(country_hellish)

# ---- 6. Visualization: Distressing by Top Countries ----
top_countries <- country_hellish %>%
  slice(1:10) %>%
  pull(country)

country_hellish_top <- country_hellish %>%
  filter(country %in% top_countries) %>%
  arrange(pct_hellish)

p_country_hellish <- ggplot(country_hellish_top, aes(x = reorder(country, pct_hellish), 
                                                     y = pct_hellish, fill = pct_hellish)) +
  geom_col(alpha = 0.7) +
  geom_text(aes(label = paste0(round(pct_hellish, 1), "%")), 
            hjust = -0.3, size = 3.5) +
  labs(
    title = "Prevalence of Distressing NDEs by Country",
    subtitle = "Top 10 countries by sample size",
    x = "Country",
    y = "% with Distressing Content"
  ) +
  scale_fill_gradient(low = "#3987e5", high = "#d95926", guide = "none") +
  coord_flip() +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank()
  )

print(p_country_hellish)
ggsave("distressing_by_country.png", p_country_hellish, width = 7, height = 5, dpi = 300)

# ---- 7. Distressing NDEs Over Time ----
print("\n=== DISTRESSING NDEs OVER TIME ===\n")

# By experience year (when the NDE occurred)
time_hellish_exp <- nde_data %>%
  filter(!is.na(exp_year), exp_year >= 1980) %>%  # Focus on modern era
  group_by(exp_year) %>%
  summarise(
    n = n(),
    n_hellish = sum(hellish, na.rm = TRUE),
    pct_hellish = mean(hellish, na.rm = TRUE) * 100,
    .groups = "drop"
  ) %>%
  filter(n >= 5)  # Only years with 5+ reports

print("Distressing NDEs by experience year:")
print(tail(time_hellish_exp, 15))

# ---- 8. Visualization: Distressing Over Time ----
p_time_hellish <- ggplot(time_hellish_exp, aes(x = exp_year, y = pct_hellish)) +
  geom_point(aes(size = n), alpha = 0.6, color = "#d95926") +
  geom_smooth(se = TRUE, color = "#3987e5", method = "loess", alpha = 0.2) +
  labs(
    title = "Prevalence of Distressing NDEs Over Time",
    x = "Year of Experience",
    y = "% with Distressing Content",
    size = "Sample Size"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank()
  )

print(p_time_hellish)
ggsave("distressing_over_time.png", p_time_hellish, width = 8, height = 5, dpi = 300)

# ---- 9. Distressing NDEs by Decade ----
print("\n=== DISTRESSING NDEs BY DECADE ===\n")

nde_data <- nde_data %>%
  mutate(exp_decade = floor(exp_year / 10) * 10)

decade_hellish <- nde_data %>%
  filter(!is.na(exp_decade), exp_decade >= 1950) %>%
  group_by(exp_decade) %>%
  summarise(
    n = n(),
    n_hellish = sum(hellish, na.rm = TRUE),
    pct_hellish = mean(hellish, na.rm = TRUE) * 100,
    .groups = "drop"
  )

print("Distressing NDEs by decade:")
print(decade_hellish)

p_decade_hellish <- ggplot(decade_hellish, aes(x = factor(exp_decade), y = pct_hellish, fill = pct_hellish)) +
  geom_col(alpha = 0.7) +
  geom_text(aes(label = paste0(round(pct_hellish, 1), "%")), 
            vjust = -0.5, size = 3.5) +
  labs(
    title = "Prevalence of Distressing NDEs by Decade",
    x = "Decade",
    y = "% with Distressing Content"
  ) +
  scale_fill_gradient(low = "#3987e5", high = "#d95926", guide = "none") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(p_decade_hellish)
ggsave("distressing_by_decade.png", p_decade_hellish, width = 7, height = 5, dpi = 300)

# ---- 10. Chi-square: Gender × Distressing ----
gender_hellish_table <- table(nde_data$gender, nde_data$hellish)
chi_gender <- chisq.test(gender_hellish_table)
print("\n=== CHI-SQUARE TESTS ===\n")
print("Gender × Distressing:")
print(chi_gender)

# ---- 11. Summary ----
print("\n=== SUMMARY ===\n")
overall_hellish <- mean(nde_data$hellish, na.rm = TRUE) * 100
print(paste("Overall distressing NDE rate:", round(overall_hellish, 1), "%"))
print(paste("Total NDEs analyzed:", nrow(nde_data)))
print(paste("NDEs with distressing content:", sum(nde_data$hellish, na.rm = TRUE)))

# -----------------------------------------------------

# How has the rate of NDERF submissions changed over time (1999–2025)?

# NDERF Submission Trends Over Time (1999–2025)
# Simple exploratory analysis

library(tidyverse)

# ---- 1. Load Data ----
nde_data <- read_csv("nde_narratives.csv")

# ---- 2. Extract Year from Post Date ----
nde_data <- nde_data %>%
  mutate(post_year = year(post_date))

# ---- 3. Annual Submission Counts ----
print("=== ANNUAL SUBMISSION COUNTS ===\n")

annual_submissions <- nde_data %>%
  group_by(post_year) %>%
  summarise(
    n_submissions = n(),
    .groups = "drop"
  ) %>%
  arrange(post_year) %>%
  filter(!is.na(post_year))

print(annual_submissions)

# ---- 4. Overall Trend Plot ----
p_trend <- ggplot(annual_submissions, aes(x = post_year, y = n_submissions)) +
  geom_col(fill = "#3987e5", alpha = 0.7) +
  geom_smooth(se = TRUE, color = "#d95926", method = "loess", alpha = 0.2, span = 0.3) +
  labs(
    title = "NDERF Submission Rate Over Time",
    x = "Year",
    y = "Number of Submissions",
    caption = "Bars = actual submissions; Orange line = smoothed trend"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank()
  )

print(p_trend)
ggsave("submission_trend_annual.png", p_trend, width = 10, height = 6, dpi = 300)

# ---- 5. Yearly Statistics ----
print("\n=== YEARLY STATISTICS ===\n")

yearly_stats <- annual_submissions %>%
  summarise(
    mean_per_year = mean(n_submissions, na.rm = TRUE),
    median_per_year = median(n_submissions, na.rm = TRUE),
    sd = sd(n_submissions, na.rm = TRUE),
    min_year = post_year[which.min(n_submissions)],
    min_count = min(n_submissions),
    max_year = post_year[which.max(n_submissions)],
    max_count = max(n_submissions)
  )

print(yearly_stats)

# ---- 6. Submission Rate by Decade ----
print("\n=== SUBMISSIONS BY DECADE ===\n")

nde_data <- nde_data %>%
  mutate(post_decade = floor(post_year / 10) * 10)

decade_submissions <- nde_data %>%
  filter(!is.na(post_decade)) %>%
  group_by(post_decade) %>%
  summarise(
    n_submissions = n(),
    .groups = "drop"
  ) %>%
  arrange(post_decade)

print(decade_submissions)

p_decade <- ggplot(decade_submissions, aes(x = factor(post_decade), y = n_submissions, fill = n_submissions)) +
  geom_col(alpha = 0.7) +
  geom_text(aes(label = n_submissions), vjust = -0.5, size = 4, fontface = "bold") +
  labs(
    title = "NDERF Submissions by Decade",
    x = "Decade",
    y = "Total Submissions"
  ) +
  scale_fill_gradient(low = "#3987e5", high = "#d95926", guide = "none") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank()
  )

print(p_decade)
ggsave("submission_by_decade.png", p_decade, width = 7, height = 5, dpi = 300)

# ---- 7. Submission Rate per Month (Recent Years) ----
print("\n=== MONTHLY SUBMISSIONS (Last 5 Years) ===\n")

nde_data <- nde_data %>%
  mutate(
    post_yearmonth = floor_date(post_date, "month")
  )

recent_cutoff <- max(nde_data$post_date, na.rm = TRUE) - years(5)

monthly_recent <- nde_data %>%
  filter(post_date >= recent_cutoff, !is.na(post_yearmonth)) %>%
  group_by(post_yearmonth) %>%
  summarise(
    n_submissions = n(),
    .groups = "drop"
  ) %>%
  arrange(post_yearmonth)

print(paste("Data from", format(recent_cutoff, "%Y-%m-%d"), "onwards"))
print(head(monthly_recent, 15))

p_monthly <- ggplot(monthly_recent, aes(x = post_yearmonth, y = n_submissions)) +
  geom_line(color = "#3987e5", linewidth = 0.8) +
  geom_point(color = "#3987e5", size = 2, alpha = 0.6) +
  geom_smooth(se = TRUE, color = "#d95926", method = "loess", alpha = 0.2) +
  labs(
    title = "Monthly NDERF Submissions (Last 5 Years)",
    x = "Month",
    y = "Number of Submissions"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(p_monthly)
ggsave("submission_monthly_recent.png", p_monthly, width = 10, height = 5, dpi = 300)

# ---- 8. Cumulative Submissions Over Time ----
print("\n=== CUMULATIVE SUBMISSIONS ===\n")

cumulative <- annual_submissions %>%
  mutate(cumulative = cumsum(n_submissions))

print(tail(cumulative, 10))

p_cumulative <- ggplot(cumulative, aes(x = post_year, y = cumulative)) +
  geom_area(fill = "#3987e5", alpha = 0.3) +
  geom_line(color = "#3987e5", linewidth = 1.2) +
  labs(
    title = "Cumulative NDERF Submissions Over Time",
    x = "Year",
    y = "Cumulative Submissions"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank()
  )

print(p_cumulative)
ggsave("submission_cumulative.png", p_cumulative, width = 10, height = 6, dpi = 300)

# ---- 9. Growth Rate Analysis ----
print("\n=== GROWTH RATE ANALYSIS ===\n")

growth_analysis <- annual_submissions %>%
  arrange(post_year) %>%
  mutate(
    pct_change = ((n_submissions - lag(n_submissions)) / lag(n_submissions)) * 100
  ) %>%
  filter(!is.na(pct_change)) %>%
  filter(post_year >= 2010)  # Focus on recent decade

print("Year-over-year % change (2010 onwards):")
print(growth_analysis)

# ---- 10. Early Years vs Recent ----
print("\n=== COMPARISON: EARLY vs RECENT ===\n")

early_period <- nde_data %>%
  filter(post_year >= 1999, post_year <= 2005) %>%
  summarise(n = n(), years = n_distinct(post_year))

mid_period <- nde_data %>%
  filter(post_year >= 2006, post_year <= 2015) %>%
  summarise(n = n(), years = n_distinct(post_year))

recent_period <- nde_data %>%
  filter(post_year >= 2016) %>%
  summarise(n = n(), years = n_distinct(post_year))

comparison <- bind_rows(
  tibble(period = "1999–2005", n = early_period$n, years = early_period$years),
  tibble(period = "2006–2015", n = mid_period$n, years = mid_period$years),
  tibble(period = "2016–2025", n = recent_period$n, years = recent_period$years)
) %>%
  mutate(avg_per_year = round(n / years, 1))

print(comparison)

# ---- 11. Summary Statistics ----
print("\n=== SUMMARY ===\n")
print(paste("Total submissions:", nrow(nde_data)))
print(paste("Date range:", 
            format(min(nde_data$post_date, na.rm = TRUE), "%Y-%m-%d"), 
            "to",
            format(max(nde_data$post_date, na.rm = TRUE), "%Y-%m-%d")))
print(paste("Years covered:", n_distinct(nde_data$post_year)))
print(paste("Average submissions per year:", round(mean(annual_submissions$n_submissions), 1)))
print(paste("Peak year:", 
            annual_submissions$post_year[which.max(annual_submissions$n_submissions)],
            "(",
            max(annual_submissions$n_submissions),
            "submissions)"))

# -----------------------------------------------------

# Do deeper NDEs (higher Greyson scores) tend to have longer narratives?

# Greyson Score vs Narrative Length
# Simple exploratory analysis

library(tidyverse)

# ---- 1. Load Data ----
nde_data <- read_csv("nde_narratives.csv")

# ---- 2. Summary Statistics ----
print("=== SUMMARY STATISTICS ===\n")

summary_stats <- nde_data %>%
  filter(!is.na(greyson_score), !is.na(narrative_length)) %>%
  summarise(
    n = n(),
    greyson_mean = mean(greyson_score),
    greyson_sd = sd(greyson_score),
    narrative_mean = mean(narrative_length),
    narrative_sd = sd(narrative_length),
    narrative_median = median(narrative_length),
    .groups = "drop"
  )

print(summary_stats)

# ---- 3. Correlation Test ----
print("\n=== CORRELATION ANALYSIS ===\n")

clean_data <- nde_data %>%
  filter(!is.na(greyson_score), !is.na(narrative_length))

correlation <- cor.test(clean_data$greyson_score, clean_data$narrative_length)
print(correlation)

corr_coef <- round(correlation$estimate, 3)
corr_pval <- round(correlation$p.value, 4)
print(paste("\nPearson r =", corr_coef, ", p-value =", corr_pval))

if (corr_pval < 0.05) {
  print("✓ Statistically significant correlation (p < 0.05)")
} else {
  print("✗ No statistically significant correlation")
}

# ---- 4. Scatterplot with Trend Line ----
p_scatter <- ggplot(clean_data, aes(x = greyson_score, y = narrative_length)) +
  geom_point(alpha = 0.4, color = "#3987e5", size = 2) +
  geom_smooth(method = "lm", se = TRUE, color = "#d95926", fill = "#d95926", alpha = 0.2) +
  labs(
    title = "Greyson Score vs Narrative Length",
    x = "Greyson NDE Scale Score (0–32)",
    y = "Narrative Length (characters)",
    caption = paste("Correlation: r =", corr_coef, ", p =", corr_pval)
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.caption = element_text(size = 11, color = "#898781"),
    panel.grid.minor = element_blank()
  )

print(p_scatter)
ggsave("greyson_vs_narrative_scatter.png", p_scatter, width = 9, height = 6, dpi = 300)

# ---- 5. Linear Regression Model ----
print("\n=== LINEAR REGRESSION ===\n")

lm_model <- lm(narrative_length ~ greyson_score, data = clean_data)
print(summary(lm_model))

# Extract coefficients
intercept <- round(coef(lm_model)[1], 2)
slope <- round(coef(lm_model)[2], 2)
r_squared <- round(summary(lm_model)$r.squared, 4)

print(paste("\nInterpretation:"))
print(paste("- Intercept:", intercept, "characters"))
print(paste("- Slope:", slope, "characters per Greyson point"))
print(paste("- R-squared:", r_squared, "(explains", round(r_squared * 100, 1), "% of variance)"))
print(paste("\nFor every 1-point increase in Greyson score,"))
print(paste("narrative length increases by ~", slope, "characters on average."))

# ---- 6. Binned Analysis: Greyson Score Categories ----
print("\n=== GREYSON SCORE CATEGORIES ===\n")

clean_data <- clean_data %>%
  mutate(
    greyson_category = case_when(
      greyson_score < 7 ~ "Low (0–6)",
      greyson_score >= 7 & greyson_score < 14 ~ "Moderate (7–13)",
      greyson_score >= 14 & greyson_score < 21 ~ "High (14–20)",
      greyson_score >= 21 ~ "Very High (21–32)"
    )
  )

category_stats <- clean_data %>%
  group_by(greyson_category) %>%
  summarise(
    n = n(),
    mean_length = mean(narrative_length, na.rm = TRUE),
    median_length = median(narrative_length, na.rm = TRUE),
    sd_length = sd(narrative_length, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(greyson_category = factor(greyson_category, 
                                   levels = c("Low (0–6)", "Moderate (7–13)", 
                                              "High (14–20)", "Very High (21–32)"))) %>%
  arrange(greyson_category)

print(category_stats)

# ---- 7. Boxplot by Category ----
p_boxplot <- ggplot(clean_data, aes(x = factor(greyson_category, 
                                               levels = c("Low (0–6)", "Moderate (7–13)", 
                                                          "High (14–20)", "Very High (21–32)")),
                                    y = narrative_length,
                                    fill = greyson_category)) +
  geom_boxplot(alpha = 0.6, outlier.alpha = 0.3) +
  geom_jitter(width = 0.2, alpha = 0.15, size = 1) +
  labs(
    title = "Narrative Length by Greyson Score Category",
    x = "Greyson Score Category",
    y = "Narrative Length (characters)",
    fill = "Category"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )

print(p_boxplot)
ggsave("narrative_by_greyson_category.png", p_boxplot, width = 8, height = 6, dpi = 300)

# ---- 8. Density Plot ----
p_density <- ggplot(clean_data, aes(x = narrative_length, fill = greyson_category)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~ factor(greyson_category, 
                      levels = c("Low (0–6)", "Moderate (7–13)", 
                                 "High (14–20)", "Very High (21–32)")),
             ncol = 2) +
  labs(
    title = "Distribution of Narrative Length by Greyson Score",
    x = "Narrative Length (characters)",
    y = "Density",
    fill = "Category"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    legend.position = "none"
  )

print(p_density)
ggsave("narrative_density_by_greyson.png", p_density, width = 9, height = 6, dpi = 300)

# ---- 9. Percentile Analysis ----
print("\n=== NARRATIVE LENGTH PERCENTILES BY GREYSON CATEGORY ===\n")

percentile_stats <- clean_data %>%
  group_by(greyson_category) %>%
  summarise(
    p10 = quantile(narrative_length, 0.10, na.rm = TRUE),
    p25 = quantile(narrative_length, 0.25, na.rm = TRUE),
    p50 = quantile(narrative_length, 0.50, na.rm = TRUE),
    p75 = quantile(narrative_length, 0.75, na.rm = TRUE),
    p90 = quantile(narrative_length, 0.90, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(greyson_category = factor(greyson_category, 
                                   levels = c("Low (0–6)", "Moderate (7–13)", 
                                              "High (14–20)", "Very High (21–32)"))) %>%
  arrange(greyson_category)

print(percentile_stats)

# ---- 10. ANOVA: Greyson Category Effect ----
print("\n=== ANOVA: Greyson Category Effect ===\n")

aov_model <- aov(narrative_length ~ greyson_category, data = clean_data)
print(summary(aov_model))

aov_pval <- round(summary(aov_model)[[1]]$`Pr(>F)`[1], 4)
if (aov_pval < 0.05) {
  print(paste("\n✓ Significant difference in narrative length across categories (p =", aov_pval, ")"))
} else {
  print(paste("\n✗ No significant difference in narrative length across categories (p =", aov_pval, ")"))
}

# ---- 11. Effect Size (Eta-squared) ----
print("\n=== EFFECT SIZE (Eta-squared) ===\n")

ss_between <- sum((category_stats$n) * 
                    (category_stats$mean_length - mean(clean_data$narrative_length))^2)
ss_total <- sum((clean_data$narrative_length - mean(clean_data$narrative_length))^2)
eta_squared <- ss_between / ss_total

print(paste("Eta-squared =", round(eta_squared, 4)))
print(paste("Greyson score explains ~", round(eta_squared * 100, 1), 
            "% of variance in narrative length"))

# ---- 12. Summary ----
print("\n=== SUMMARY ===\n")
print(paste("Sample size:", nrow(clean_data)))
print(paste("Correlation: r =", corr_coef, "(p =", corr_pval, ")"))
print(paste("R-squared:", r_squared, "(explains", round(r_squared * 100, 1), "% of variance)"))
print(paste("\nConclusion: ", 
            if_else(corr_pval < 0.05 & corr_coef > 0.1,
                    "Deeper NDEs (higher Greyson scores) DO tend to have longer narratives.",
                    "The relationship is weak or not statistically significant.")))

