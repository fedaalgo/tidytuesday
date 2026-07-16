# --- tidytuesday::2628 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-07-14/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-14/many_penguins.csv'
  ) |>
  clean_names()
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-07-14/readme.md

# understand ----

# names
dfa |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

# This dataset gives morphometric data for 93 penguins from 18 species within 6
# genera. It was inspired by the now-classic "Palmer penguins data set". I
# attended a workshop where students were analyzing the Palmer-penguins data set
# with a hierarchical model with individuals grouped by species. However,
# because there are only three species represented in the Palmer data set
# (Adélie, Chinstrap, and Gentoo), this data set is not ideal for that purpose.
# I found (with the assistance of a chatbot) the AVONET dataset (Tobias et al.
# 2022):

# The AVONET database contains comprehensive functional trait data for all
# birds, including six ecological variables, eleven continuous morphological
# traits, and information on range size and location. Raw morphological
# measurements are available from 90020 individuals of 11009 extant bird species
# sampled from 181 countries.

# I selected the penguin data from the database. The data set has 10 different
# morphometric measurements of penguin beaks, wings, tails, etc. (although up to
# 12% of some types of measurements are missing).

# - How do trait values covary within/across species and genera?
# - Is there a good way to do ordination/visualization that handles the
# missingness of some of the traits nicely?
# - Are there interesting ways to visualize these data in >2 dimensions?
