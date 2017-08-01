# Starting to explore the data 

library(data.table)

raw.data = fread('abcnews-date-text.csv')
head(raw.data)
df = raw.data
df$publish_date = as.Date(as.character(df$publish_date),'%Y%m%d')
