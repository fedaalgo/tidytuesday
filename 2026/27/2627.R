# --- tidytuesday::2627 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-07-07/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.6", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-07/ufc_athletes.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-07/ufc_fights.csv'
  ) |>
  clean_names()

dfc <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-07/ufc_rankings_dataset.csv'
  ) |>
  clean_names()

dfd <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-07/ufcstats_data.csv'
  ) |>
  clean_names()

dfe <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-07/ultimate_ufc_dataset.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-07-07/readme.md

# understand ----

df_list <- list(dfa = dfa, dfb = dfb, dfc = dfc, dfd = dfd, dfe = dfe)

# names
df_list |>
  map(
    ~ .x |>
      slice(0) |>
      glimpse()
)

# glimpse & skim
df_list |> 
  map(
    ~.x |> 
      glimpse() |> 
      skim()
)

# tokenize
# dfa |>
#   unnest_tokens(output = word, input = variable) |>
#   anti_join(stop_words, by = "word") |>
#   group_by(word) |>
#   summarise(n = n()) |>
#   arrange(desc(n))

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

# The fightr package provides a comprehensive, historical dataset of Ultimate
# Fighting Championship (UFC) bouts and athlete-level profile information. It
# tracks divisional and pound-for-pound rankings over time, career records,
# physical attributes, fighting styles, gym affiliations, and summarized
# performance statistics, offering a longitudinal view of a fighter's status and
# performance within the promotion.

# Here are a few questions you might want to try and answer with this week's data:

# - How do physical attribute advantages such as height, reach, or age
# differences (reach_dif, age_dif) correlate with the likelihood of winning a
# bout?
# - How has the distribution of fight finishes (KO/TKO vs. Submission vs.
# Decision) evolved over the history of the UFC?
# - Is there a discernible relationship between a fighter's historical
# striking/takedown accuracy and their peak divisional ranking? 
# - How accurate are the betting odds (r_ev, b_ev) at predicting the actual
# winner of a title bout?
