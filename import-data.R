library(lubridate)
library(dplyr)
library(readr)
library(clockify)
library(gt)



CLOCKIFY_API_KEY = Sys.getenv("Clockify")

clockify::set_api_key(CLOCKIFY_API_KEY)




current_date <- Sys.Date()

current_date

current_date_adj <- current_date -7

current_date_adj

last_week <- lubridate::week(current_date)


last_week





pro <- projects()

pro



weekly_review <- time_entries(start=current_date_adj, concise = FALSE) %>%
  dplyr::select(-1, -2, -3, -8) %>%
  dplyr::mutate(week_num =lubridate::week(time_start)) %>%
  dplyr::left_join(pro, weekly_review, by="project_id") %>%
  dplyr::select(project_name, billable.x, duration, week_num) %>%
  dplyr::rename(billable = billable.x) %>% 
  dplyr::rename(project = project_name)

weekly_review
names(weekly_review)


weekly_review <- weekly_review %>%
  dplyr::filter(week_num == last_week) %>%
  group_by(project)

weekly_review

readr::write_csv(weekly_review, "weekly-review.csv")

weekly_review_tbl <- weekly_review %>%
  gt::gt()

weekly_review_tbl


sum_weekly <- weekly_review %>%
  group_by(project) %>%
  dplyr::summarise(total = sum(duration))

sum_weekly


sum_weekly_tbl <- sum_weekly %>%
  gt::gt()


sum_weekly_tbl



avg_weekly <- weekly_review %>%
  group_by(project) %>%
  dplyr::summarise(total = mean(duration))

avg_weekly

avg_weekly_tbl <- avg_weekly %>%
  gt::gt()

avg_weekly_tbl


