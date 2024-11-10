library(lubridate)
library(dplyr)
library(readr)
library(clockify)
library(gt)


### set the api keys
CLOCKIFY_API_KEY = Sys.getenv("Clockify")

clockify::set_api_key(CLOCKIFY_API_KEY)



#### Deal with Dates
current_date <- Sys.Date()

current_date

current_date_adj <- current_date -7

current_date_adj

###Get last week
last_week <- lubridate::week(current_date)


last_week




### List Projects
pro <- projects()

pro


### Data Wrangle
weekly_review <- time_entries(start=current_date_adj, concise = FALSE) %>%
  dplyr::select(-1, -2, -3, -8) %>%
  dplyr::mutate(week_num =lubridate::week(time_start)) %>%
  dplyr::left_join(pro, weekly_review, by="project_id") %>%
  dplyr::select(project_name, billable.x, duration, week_num) %>%
  dplyr::rename(billable = billable.x) %>% 
  dplyr::rename(project = project_name) 

weekly_review
names(weekly_review)

### Summarize the data
weekly_review <- weekly_review %>%
  dplyr::filter(week_num == last_week) %>%
  dplyr::group_by(project) |> 
  summarise(total = sum(duration))


weekly_review

readr::write_csv(weekly_review, "weekly-review.csv")
