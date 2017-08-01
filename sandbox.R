# Starting to explore the data 

# Data is from Kaggle https://www.kaggle.com/therohk/million-headlines

library(data.table)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(tidytext)

# Import Stop Words
data(stop_words)

raw.data = fread('abcnews-date-text.csv')
head(raw.data)
df = raw.data
df$publish_date = as.Date(as.character(df$publish_date),'%Y%m%d')

# Create Tidy Text data frame
text_df = df %>%
  unnest_tokens(word, headline_text)
head(text_df)

nrow(text_df) # 6902242 ~ roughly 6.9 Million words!

clean_df = text_df %>%
  anti_join(stop_words)
head(clean_df)

nrow(text_df) - nrow(clean_df) # 1676863 ~ 1.7 Million rows removed!

clean_df %>%
  count(word, sort = TRUE)

clean_df %>%
  count(word, sort = TRUE) %>%
  filter(n > 11000) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

clean_df$year = year(clean_df$publish_date)
clean_df$month = month(clean_df$publish_date)
clean_df$wday = factor(wday(clean_df$publish_date,label=TRUE))
head(clean_df)

clean_df %>%
  group_by(year) %>%
  count(word, sort = TRUE) %>%
  filter(n > 1500) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() + 
  facet_wrap(~year, scales = "free")
  

clean_df %>%
  group_by(wday) %>%
  count(word, sort = TRUE) %>%
  filter(n > 2500) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() + 
  facet_wrap(~wday, scales = "free")

clean_df %>%
  # filter(word != 'police') %>%
  group_by(year) %>%
  count(word, sort = TRUE) %>%
  arrange(-year,-n) %>%
  top_n(n=2, wt = n)

clean_df %>%
  # filter(word != 'police') %>%
  group_by(month) %>%
  count(word, sort = TRUE) %>%
  arrange(month,-n) %>%
  top_n(n=2, wt = n)

clean_df %>%
  # filter(word != 'police') %>%
  group_by(wday) %>%
  count(word, sort = TRUE) %>%
  arrange(wday,-n) %>%
  top_n(n=2, wt = n)
