# --- tidytuesday::2602 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-01-13/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-01-13/africa.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-01-13/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

df |> 
  group_by(country) |> 
  summarise(n = n()) |> 
  arrange(desc(n))

df |> 
  group_by(country) |> 
  summarise(total = sum(native_speakers)) |> 
  arrange(desc(total)) |> 
  print(n = Inf)

df |>
  filter(country == "Cameroon") |> 
  group_by(family) |> 
  summarise(n = n()) |> 
  arrange(desc(n))

# visualise ----

gruvbox_colors <- c(
  "#fb4934",
  "#b8bb26",
  "#fabd2f",
  "#83a598",
  "#d3869b",
  "#8ec07c"
)

df |> 
  group_by(country) |> 
  summarise(total = sum(native_speakers)) |> 
  arrange(desc(total)) |> 
  mutate(color_group = rep(1:6, length.out = n())) |> 
  ggplot(aes(x = total, y = reorder(country, total), fill = factor(color_group))) +
  geom_col() +
  scale_fill_manual(values = gruvbox_colors) +
  labs(
    title = "Native Speakers by Country",
    subtitle = "Total number of native speakers across African countries",
    x = NULL,
    y = NULL
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12, color = "gray40"),
    panel.grid.major.y = element_blank(),
    plot.margin = margin(10, 20, 10, 10)
  ) +
  scale_x_continuous(labels = scales::comma)

ggsave("native_speakers.png", width = 12, height = 8, dpi = 300)
