# --- tidytuesday::2636 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-09-08/readme.md

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
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-09-08/cafe.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-09-08/cappuccino_index.csv'
  ) |>
  clean_names()

# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-09-08/readme.md

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

# James Hoffmann is a YouTuber who explores coffee from many different angles.
# In a recent video he explored how long a barista would need to work to pay for
# a small cappuccino. Coffee, as a part of our economy, as an industry,
# is full of these awkward questions that I do think are worth asking.

# In the video (https://www.youtube.com/watch?v=WtlE3BW9Nqs)
# James presents the cappuccino index, which answers this at a
# country level. There are many interesting findings. You may want to watch the
# whole video as context and entertainment. There are some important caveats,
# such as tips being excluded.

# You might think about:

# - Some sample sizes are small. How uncertain is the ranking?
# - Which countries have the biggest variability in the price of a small cappuccino?
# - Are there any outliers?
