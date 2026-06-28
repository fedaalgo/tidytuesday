# --- tidytuesday::2625 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-06-23/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-23/encyclicals.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-23/papal_encyclicals.csv'
  ) |>
  clean_names()

dfc <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-23/scripture_references.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-06-23/readme.md

# understand ----

df_list <- list(dfa = dfa, dfb = dfb, dfc = dfc)

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
dfa |>
  unnest_tokens(output = word, input = text) |>
  anti_join(stop_words, by = "word") |>
  group_by(word) |>
  summarise(n = n()) |>
  arrange(desc(n))

# visualise ----

dfa |> 
  group_by(pope) |> 
  summarise(n = n()) |> 
  arrange(desc(n))

# ...

# This week we're exploring papal encyclicals — the most authoritative form of
# papal teaching in the Catholic Church. The primary dataset contains the full
# paragraph-level text of two encyclicals that bookend 135 years of
# technological revolution: Pope Leo XIII's Rerum Novarum (1891), which
# addressed the Industrial Revolution's impact on workers, and Pope Leo XIV's
# Magnifica Humanitas (2026), which addresses artificial intelligence's impact
# on human dignity. Both were signed on May 15 of their respective years.

# The data comes from Vatican.va, the official website of the Holy See. A
# supplementary dataset catalogs all 213 papal encyclicals from 1878 to 2026
# with metadata about each pope.

# - How does the vocabulary of Catholic Social Teaching evolve from the
#   Industrial Revolution to the AI Revolution?

# - Which books of the Bible does each Pope draw upon, and what does that reveal
#   about their theological emphasis?

# - Can a machine learning model reliably distinguish which Pope wrote a
#   paragraph? What features does it rely on — specific words, or writing style?

# - How has encyclical output changed over time? Leo XIII wrote 86 encyclicals;
#   Francis wrote 4. What does that tell us about how papal communication has
#   evolved?

# - Which passages of Magnifica Humanitas are most textually similar to Rerum
#   Novarum, suggesting direct intellectual lineage?
