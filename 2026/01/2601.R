# --- tidytuesday::2601 --- #

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  gt, # https://cran.r-project.org/web/packages/gt/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  styler, # https://cran.r-project.org/web/packages/styler/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# data
data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQf5amXQgthzG446bvNIUOxgASM2tHBemWonuBhVHKZycIzb9l39E8qaNN8WY-7gkw7WFaWNyNqk6e0/pub?gid=907558572&single=true&output=csv")

# compact table with grouping by type
table_compact <- data |>
  # clean column names
  rename(
    Title = `Resource Title`,
    Type = `Type of Resource`,
    Association = `Name of Association`,
    URL = `URL (e.g., DOI, website)`,
    Multilingual = `Is it available in a language other than English?`
  ) |>
  # custom factor order for type
  mutate(Type = factor(Type, levels = c("Guidelines", "Research", "Teaching", "Other", NA))) |>
  # group by resource type
  arrange(Type, Title) |>
  # create the gt table
  gt(groupname_col = "Type") |>
  # title
  tab_header(
    title = md("**Resource Corner: Open Science & Research Resources**"),
    subtitle = md("*Organized by Resource Type*")
  ) |>
  # format url column
  fmt_url(
    columns = URL,
    label = "🔗"
  ) |>
  # hide the type column since used for grouping
  cols_hide(columns = Type) |>
  # column widths
  cols_width(
    Title ~ px(280),
    Authors ~ px(180),
    Association ~ px(150),
    URL ~ px(60),
    Multilingual ~ px(100),
    Languages ~ px(130),
    Notes ~ px(280)
  ) |>
  # text alignment
  cols_align(
    align = "left",
    columns = everything()
  ) |>
  cols_align(
    align = "center",
    columns = c(URL, Multilingual)
  ) |>
  # striping and styling
  opt_row_striping() |>
  tab_style(
    style = cell_fill(color = "#8ec07c"),
    locations = cells_row_groups()
  ) |>
  tab_style(
    style = cell_text(color = "white", weight = "bold", size = px(14)),
    locations = cells_row_groups()
  ) |>
  tab_style(
    style = cell_fill(color = "#353535"),
    locations = cells_column_labels()
  ) |>
  tab_style(
    style = cell_text(color = "white", weight = "bold"),
    locations = cells_column_labels()
  ) |>
  # highlight multilingual resources
  tab_style(
    style = cell_fill(color = "#edb54b"),
    locations = cells_body(
      columns = Multilingual,
      rows = Multilingual == "Yes"
    )
  ) |>
  # options
  tab_options(
    table.font.size = px(11),
    data_row.padding = px(6),
    column_labels.padding = px(8),
    heading.padding = px(12),
    row_group.padding = px(10),
    table.border.top.style = "solid",
    table.border.top.width = px(3),
    table.border.top.color = "#282828"
  ) |>
  # source note
  tab_source_note(
    source_note = md("*Resources compiled by the open science community*")
  )

table_compact

gtsave(table_compact, "/mnt/user-data/outputs/resource_table_grouped.html")
