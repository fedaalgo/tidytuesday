# --- tidytuesday::2514 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-04-07/readme.md

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
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-04-07/repairs.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-04-07/repairs_text.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-04-07/readme.md

# understand ----

# names
dfa |> 
  slice(0) |> 
  glimpse()

dfb |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

dfb |>
  glimpse() |>
  skim()

# tokenize
# df |>
#   unnest_tokens(output = word, input = variable) |>
#   anti_join(stop_words, by = "word") |>
#   group_by(word) |>
#   summarise(n = n()) |>
#   arrange(desc(n))

# ...

# As carbon-hungry consumer production and its subsequent waste surge to
# all-time highs, experts say that the concept can help curb pollution
# while promoting a more circular economy.

# - what kinds of items are most easily repaired?

dfa |> 
  group_by(kind_of_product) |> 
  summarise(n = n()) |> 
  arrange(desc(n))

# - what are the most common reasons that items can't be repaired?

dfb |> 
  filter(is.na(repair_method)) |> 
  filter(!is.na(defect_found)) |> 
  group_by(defect_found) |> 
  summarise(n = n()) |> 
  arrange(desc(n)) |> 
  print(n = 99)

# - which countries have seen the most growth in Repair Cafe branches?

dfa |> 
  group_by(country) |> 
  summarise(n = n()) |> 
  arrange(desc(n))
