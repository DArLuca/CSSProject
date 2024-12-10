library(httr)
library(rvest)
library(jsonlite)
library(dplyr)

### get overview of scrapable newspapers or APIs
api_key <- readLines("./api-key.txt")
endpoint <- "https://api.nytimes.com/svc/archive/v1/2024/1.json?api-key="

# Construct the base URL. We use paste0 here to make the code easy adjustable.
# Note: do not change the dates for now please.
#term <- "brexit"
begin_date <- "20220110"
end_date <- "20241210"


baseurl <- paste0(
  "http://api.nytimes.com/svc/search/v2/articlesearch.json?q=",
  "&begin_date=",begin_date,
  "&end_date=",end_date,
  "&facet_filter=true", # restricts descriptives of the results to the search criteria
  "&api-key=",api_key,
  sep="")

maxPages <- ceiling((initialQuery$response$meta$hits[1] / 10)-1)

# create an empty result list
result_list <- vector("list",length=maxPages)


for(i in 0:maxPages){
  print(i)
  nytSearch <-
    fromJSON(paste0(baseurl, "&page=", i, "&api-key=", api_key), flatten = TRUE) %>%
    data.frame(.,stringsAsFactors = FALSE)
  result_list[[i+1]] <- nytSearch
  Sys.sleep(12)
} ### abgebrochen auf Seite 155


result <-
  rbind_pages(result_list)

### export result df
library(readr)

write_csv(result, "./data/nyt_incomplete.csv")

summary(nytSearch)

# We could call this directly using `getURL` from the package `RCurl`.
# Let's see the first 2000 characters
RCurl::getURL(baseurl) %>% substr(.,1,2000)

# We use the json package again to convert this data
initialQuery <- fromJSON(baseurl)
glimpse(initialQuery)

initialQuery$response$docs

#check if we got all articles
# total hits
initialQuery$response$meta$hits
# hits returned
length(initialQuery$response$docs$headline)


######
# topic model analysis








### newspapers of interest
https://www.heritage.org/press/press-archive


### Scraping 

<- 


nyt_api <- "https://api.nytimes.com/svc/archive/v1/2024/1.json?api-key=MrH81Lr74JQGARzZrQ2pRgb1vC9wr7kl"


