install.packages(c("RSelenium", "rvest", "tidyverse"))

library(rvest)
library(tidyverse)


# Creating Articel-Link-List ------------------------------------------

hf_archive_url <- "https://www.heritage.org/press/press-archive"

hf_archive_html <- read_html(hf_archive_url)

titles <- hf_archive_html %>% 
  html_nodes("a[data-entity-type='node']") %>% 
  html_text(trim = TRUE)

links <- hf_archive_html %>% 
  html_nodes("a[data-entity-type='node']") %>% 
  html_attr("href")

base_url <- "https://www.heritage.org"
full_links <- paste0(base_url, links)

press_releases <- data.frame(
  title = titles,
  link = full_links
)

press_releases$article <- NA_character_


# Scraping Article Bodies -------------------------------------------------

for(i in seq_len(nrow(press_releases))) {
  article_url <- press_releases$link[i]
  
  tryCatch({
    article_page <- read_html(article_url)

    article_text <- article_page %>%
      html_node(".article__body-copy") %>%
      html_text(trim = TRUE)
    
    press_releases$article[i] <- article_text
  }, error = function(e) {
    message(sprintf("Error scraping URL: %s", article_url))
    press_releases$article[i] <- NA
  })
}


# Text Preprocessing ------------------------------------------------------

install.packages(c("tidytext", "stringr", "tm"))

library(tidytext)
library(stringr)
library(tm)

# Removing links:
press_releases$cleaned_article <- str_remove_all(press_releases$article, 
                                                 "http[s]?://\\S+")
# Removing punctuation:
press_releases$cleaned_article <- gsub("[[:punct:]]", "", 
                                       press_releases$cleaned_article)
# Transforming to lower case:
press_releases$cleaned_article <- tolower(press_releases$cleaned_article)

summary(press_releases)



