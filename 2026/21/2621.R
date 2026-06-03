# --- tidytuesday::2621 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-05-26/readme.md

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
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-05-26/energy_cleaned.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-05-26/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# transform ----

# visualise ----

# model ----

# communicate ----

# ... 

# The “Sustainable Energy for all (SE4ALL)” initiative, launched in 2010 by
# the UN Secretary General, established three global objectives to be
# accomplished by 2030: to ensure universal access to modern energy services, to
# double the global rate of improvement in global energy efficiency, and to
# double the share of renewable energy in the global energy mix. SE4ALL database
# supports this initiative and provides country level historical data for access
# to electricity and non-solid fuel; share of renewable energy in total final
# energy consumption by technology; and energy intensity rate of improvement.

# - which countries have the lowest capacity for solar energy?
# - what form of renewable energy has, on average, experienced the fasted rate
#   of adoption?
