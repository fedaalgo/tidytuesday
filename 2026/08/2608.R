# --- tidytuesday::2608 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-02-24/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-02-24/sfi_grants.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-02-24/readme.md

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

# SFI was the national foundation in Ireland for investment in
# scientific and engineering research. Consequently, SFI invested in
# those academic researchers and research teams who were most likely
# to generate new knowledge, leading edge technologies and
# competitive enterprises in the fields of science, technology,
# engineering and maths (STEM).

# which institute received the most grant funding?

df |>
  group_by(research_body) |>
  summarise(total_funding = sum(current_total_commitment, na.rm = TRUE)) |>
  arrange(desc(total_funding)) |>
  slice(1)

# how much did sfi invest into research each year?

df |>
  mutate(year = year(start_date)) |>
  group_by(year) |>
  summarise(total_funding = sum(current_total_commitment, na.rm = TRUE)) |> 
  ggplot(mapping = aes(x = year, y = total_funding)) +
  geom_line() +
  scale_y_continuous(labels = function(x) format(x, big.mark = ",", scientific = FALSE)) +
  labs(
    title = "Science Foundation Ireland Grants Commitments",
    subtitle = "Research Investment per Year",
    caption = "data pulled from https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-02-24/readme.md"
  ) +
  theme_minimal() +
  theme(
    axis.title.y = element_blank(),
    plot.subtitle = element_text(color = "#000000"),
    plot.caption = element_text(family = "mono")
  )

ggsave("plot.png", width = 12, height = 8, dpi = 300)
