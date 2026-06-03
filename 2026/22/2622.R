# --- tidytuesday::2622 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-06-02/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-02/eplp.csv'
  ) |>
  clean_names()

# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-06-02/readme.md

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

# he European Parenting Leave Policies (EPLP) Dataset provides harmonised data
# on maternity, co-parent, paid parental, and job-protected leave regulations
# across 21 European countries from 1970 to 2024. The dataset enables
# quantitative analyses of policy trends, cross-national differences, and the
# effects of major reforms – for researchers, policymakers, and others
# interested in family policy. Given the variety of parental leave schemes
# across countries, the dataset considers three different dimensions of parental
# leave duration for each country, if applicable. Dimension 1 (par1) identifies
# the paid parental leave scheme with the longest possible duration. Dimension 2
# (par2) identifies the paid parental leave duration with the highest monthly
# flat rate payment. Dimension 3 (par3) identifies the duration with the highest
# replacement rate. Values that are missing are represented as NA. Some values
# are missing because they are not applicable. These values are encoded as "Not
# applicable" for character vectors, and -98 for numeric variables.

# - which countries were the first to implement co-parent leave policies?
# - has parenting leave decreased in any countries?
