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
  data.table, # https://cran.r-project.org/web/packages/data.table/
  corrplot, # https://cran.r-project.org/web/packages/corrplot/
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

model <- glm(ai_clinical ~ ai_hellish, data = df, family = binomial)
summary(model)
exp(coef(model))
exp(confint(model))

df$pred_prob <- predict(model, type = "response")
head(df[, c("ai_hellish", "ai_clinical", "pred_prob")])

# predict ai_clinical using all other ai_* variables
predictors <- c("ai_obe", "ai_unity", "ai_hellish", "ai_esp", "ai_past_lives", "ai_world_future", "ai_aliens")

# construct formula: outcome ~ predictor1 + predictor2 + ...
formula_str <- paste("ai_clinical ~", paste(predictors, collapse = " + "))
model_multi <- glm(as.formula(formula_str), data = df, family = binomial)

# view summary
summary(model_multi)

# get odds ratios and confidence intervals
exp(cbind(or = coef(model_multi), confint(model_multi)))   

# select only the logical ai_* columns
ai_data <- df |> select(starts_with("ai_"))

# calculate correlation matrix (automatically handles true/false as 1/0)
cor_matrix <- cor(ai_data, use = "pairwise.complete.obs")

# view the matrix
print(cor_matrix)

# visualise ----

ai_data <- df |> select(starts_with("ai_"))

cor_matrix <- cor(ai_data, use = "pairwise.complete.obs")

corrplot(cor_matrix, 
         method = 'square',
         type = 'upper',
         tl.col = 'black',
         tl.srt = 45,
         title = "correlation of nde features",
         mar = c(0,0,1,0),
         addcoef.col = 'grey',
         number.cex = 0.7)

