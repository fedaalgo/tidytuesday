# --- tidytuesday::2612 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-03-24/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-24/pi_digits.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-03-24/readme.md

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

# These files provide the canonical sequence of π digits,
# starting with 3.14159, and have been tidied into a structured dataset

# where does your birthday first appear in π?
# are the digits of π uniformly distributed across 0–9?
# what patterns or runs of repeated digits occur in the first million digits?
# how can we visualize π creatively (spirals, radial plots, or color-coded art)?
# does each digit appear exactly 1/10 of the time, or are some more common than others?
# does the frequency distribution change as you use more digits — does it converge to uniform?
# at what position does the distribution first "stabilise" around 10% each?
