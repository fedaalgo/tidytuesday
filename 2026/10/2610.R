# --- tidytuesday::2610 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-03-10/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  styler, # https://cran.r-project.org/web/packages/styler/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-10/absolute_judgements.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-10/pairwise_comparisons.csv'
  ) |>
  clean_names()

dfc <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-10/respondent_metadata.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-03-10/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

# ...

# In an online quiz, created as an independent project by Adam
# Kucharski, over 5,000 participants compared pairs of probability
# phrases (e.g. “Which conveys a higher probability: Likely or
# Probable?”) and assigned numerical values (0–100%) to each of 19
# phrases. The resulting data can be used to analyse how people
# interpret common probability phrases.

# which phrases do people most disagree on,
# in relation to the probability they represent?

dfa |>
  group_by(term) |>
  summarise(mean = mean(probability)) |> 
  arrange(desc(mean))

# which demographic background is the most optimistic?
# does the order people are shown phrases in change their interpretation?
