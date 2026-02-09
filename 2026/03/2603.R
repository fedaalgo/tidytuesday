# --- tidytuesday::2603 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-01-20/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  ggraph, # https://cran.r-project.org/web/packages/ggraph/
  igraph, # https://cran.r-project.org/web/packages/igraph/
  likert, # https://cran.r-project.org/web/packages/likert/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  styler, # https://cran.r-project.org/web/packages/styler/
  stopwords, # https://cran.r-project.org/web/packages/stopwords/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse, # https://cran.r-project.org/web/packages/tidyverse/
  wordcloud2 # https://cran.r-project.org/web/packages/wordcloud2/
)

# import
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-01-20/apod.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-01-20/readme.md

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
df |>
  unnest_tokens(output = word, input = explanation) |>
  anti_join(stop_words, by = "word") |>
  group_by(word) |>
  summarise(n = n()) |>
  arrange(desc(n))

stopwords_en <-
  data.frame(word = stopwords(language = "en")) |>
  rbind(data.frame(
    word = c(
      "apod.nasa.gov",
      "also",
      "digg_skin",
      "digg_un",
      "html",
      "http",
      "known"
    )
  )
)

# sample
set.seed(123)

dfs <- df |> 
  slice_sample(n = 100)

# visualise ----

dfs |> 
  select(explanation) |> 
  unnest_ngrams(word, explanation, n = 2) |> 
  group_by(word) |> 
  summarise(n = n()) |> 
  arrange(desc(n)) |> 
  filter(str_length(word) > 5)

dfs_bigrams <- 
  dfs |> 
  select(explanation) |> 
  filter(!is.na(explanation)) |>
  filter(str_trim(explanation) != "") |>
  unnest_ngrams(word, explanation, n = 2)

dfs_bigrams_sep <- 
  dfs_bigrams |> 
  separate(word, c("word1", "word2"), sep = " ") |>
  filter(!is.na(word1) & !is.na(word2))

dfs_bigrams_filtered <- dfs_bigrams_sep |>
  filter(!word1 %in% stopwords_en$word) |>
  filter(!word2 %in% stopwords_en$word)

dfs_bigram_counts <- dfs_bigrams_filtered |> 
  count(word1, word2, sort = TRUE)

## bi-gram graph
dfs_bigram_graph <- dfs_bigram_counts |> 
  filter(n >= 5) |> 
  graph_from_data_frame()

dfs_bigram_graph

a <- grid::arrow(type = 'closed', length = unit(.15, 'inches'))

set.seed(8080)

ggraph(dfs_bigram_graph, layout = "fr") +
  geom_edge_link(
    aes(edge_alpha = n),
    show.legend = FALSE,
    arrow = a,
    end_cap = circle(.07, 'inches')
  ) +
  geom_node_point(color = "#000000",
                  alpha = 0.85,
                  size = 3) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  labs(
    title = "APOD bi-gram",
    subtitle = " ",
    caption = "arrows' saturation show level of recurrence"
  ) +
  theme(text = element_text(family = 'Consolas'),
        plot.title = element_text(face = 'bold')
)

ggsave("apod_bi-gram.png", width = 12, height = 8, dpi = 300)
