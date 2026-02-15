# --- tidytuesday::2605 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-02-03/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  ggstatsplot, # https://cran.r-project.org/web/packages/ggstatsplot/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  styler, # https://cran.r-project.org/web/packages/styler/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-02-03/edible_plants.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-02-03/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

df |> 
  separate(temperature_growing, into = c("temp_min", "temp_max"), 
           sep = "-", remove = FALSE, convert = TRUE) |> 
  mutate(temp_avg = (temp_min + temp_max) / 2) |> 
  group_by(sunlight) |> 
  summarize(
    n = n(),
    mean_temp_min = mean(temp_min, na.rm = TRUE),
    mean_temp_max = mean(temp_max, na.rm = TRUE),
    mean_temp_avg = mean(temp_avg, na.rm = TRUE),
    sd_temp_avg = sd(temp_avg, na.rm = TRUE)
)

df |> 
  count(cultivation, water) |> 
  arrange(cultivation, water)

# ... ----

# do plants that require more sunlight also require higher temperatures?

ggbetweenstats(
  data = df |> 
    separate(temperature_growing, into = c("temp_min", "temp_max"), 
      sep = "-", remove = FALSE, convert = TRUE) |> 
    mutate(temp_avg = (temp_min + temp_max) / 2),
  x = sunlight,
  y = temp_avg,
  type = "nonparametric",
  plot.type = "violin",
  point.args = list(alpha = 0.4, size = 2),  # individual points
  centrality.plotting = TRUE,  # median/mean
  title = "Temperature Requirements by Sunlight Needs"
)

ggsave("ggbetweenstats.png",  width = 12, height = 8, dpi = 300)

# To investigate whether plants requiring more sunlight also require
# higher temperatures, a Kruskal-Wallis test comparing average growing
# temperatures across different sunlight requirement categories was
# conducted. The results revealed no statistically significant
# relationship (χ² = 10.14, df = 5, p = 0.071), with pairwise
# comparisons also showing no significant differences after Bonferroni
# correction. The violin plot visualization confirms this finding,
# showing that plants requiring full sun have nearly identical median
# temperature requirements (18.5°C) to those preferring partial shade.
# Notably, both the full sun and partial shade groups exhibit bimodal
# distributions with distinct peaks at cooler (14-18°C) and warmer
# (22-28°C) temperatures, indicating that each sunlight category
# contains both cool-season and warm-season plants. The small-to-medium
# effect size (ξ²rank = 0.20, CI95%~ [0.14, 1.02]) and these
# overlapping distributions demonstrate that sunlight and temperature
# requirements are largely independent ecological factors. This makes
# biological sense, as sunlight needs primarily relate to
# photosynthetic capacity while temperature requirements reflect
# climate adaptation—allowing for cool-season crops (like peas) and
# warm-season crops (like tomatoes) to both thrive in full sun despite
# vastly different temperature preferences.

# what cultivation classes require the most water?

ggbarstats(
  data = df |> 
    filter(!is.na(water), !is.na(cultivation)) |> 
    mutate(water_ordered = factor(water, 
                                  levels = c("Very Low", "Low", "Medium", 
                                            "High", "Very High"),
                                  ordered = TRUE)),
  x = cultivation,
  y = water_ordered,
  title = "Water Requirements by Cultivation Class",
  xlab = "Cultivation Class",
  ylab = "Water Requirement",
  package = "ggsci",
  palette = "default_igv" # 51 colors
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)
)

ggsave("ggbarstats.png",  width = 12, height = 8, dpi = 300)

# To determine which cultivation classes require the most water,
# association between cultivation class and water requirements 
# was examined using Pearson's chi-squared test. The analysis revealed
# a statistically significant relationship (χ²Pearson(44) = 78.20, p =
# 1.14e-03) with a moderate effect size (V²Cramer = 0.25, CI95%
# [0.00, 0.21]), indicating that cultivation class does influence water
# needs. However, the stacked bar chart indicates that this
# relationship is complex rather than straightforward. The Medium
# cultivation class (n=93), which comprises the largest group, exhibits
# the most diverse water requirements, with 48% requiring medium water,
# 8% requiring very high water, and plants distributed across all water
# levels. The High cultivation class (n=24) shows a notable 8% of
# plants requiring very high water alongside 33% requiring medium
# water. In contrast, the Low cultivation class (n=18) tends toward
# lower water needs, with 17% requiring very low water and only 6%
# requiring very high water. Overall, while cultivation class
# significantly predicts water requirements, most classes contain
# plants with varied water needs rather than clustering at a single
# water requirement level, reflecting the diverse ecological
# adaptations within each cultivation category.
