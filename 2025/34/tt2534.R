# --- tidytuesday::2534 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-08-26/readme.md

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
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-08-26/billboard.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2025/2025-08-26/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
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

df |> 
  group_by(producers) |> 
  summarise(n = n()) |> 
  arrange(desc(n))

df |> 
  group_by(artist_place_of_origin) |> 
  summarise(n = n()) |> 
  arrange(desc(n))
