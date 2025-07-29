library(httr)
library(jsonlite)
library(lubridate)
library(here)
library(purrr)

url <- "https://servicodados.ibge.gov.br/api/v1/produtos/estatisticas"
response <- GET(url)
data <- content(response, as = "text", encoding = "UTF-8")
survey_data <- fromJSON(data)
survey_names <- survey_data$catTitle
survey_alias <- setNames(survey_data$alias, survey_names)

# Fetch the JSON data
fetch_items <- function(code) {
  url <- paste0("https://servicodados.ibge.gov.br/api/v3/calendario/", code)
  response <- GET(url)
  data <- content(response, as = "text", encoding = "UTF-8")
  json_data <- fromJSON(data)
  
  # Extract the items
  return(json_data$items)
}

results <- map(.x = survey_alias, .f = fetch_items)
filtered_alias <- survey_alias[sapply(results, is.data.frame)]
results <- Filter(is.data.frame, results)

# Start building the .ics content

ics_list <- list()

# Loop through the items and create events
for (j in seq_along(results)) {
  ics_lines <- c("BEGIN:VCALENDAR", "VERSION:2.0", "CALSCALE:GREGORIAN")
  
    for (i in seq_len(nrow(results[[j]]))) {
    datetime <- dmy_hms(results[[j]]$data_divulgacao[i])
    datetime <- update(datetime, hour = 9, minute = 0, second = 0)  # Set to 9:00 AM
    datetime_str <- format(datetime, "%Y%m%dT%H%M%S")
    
    ics_lines <- c(ics_lines,
                   "BEGIN:VEVENT",
                   paste0("SUMMARY:", results[[j]]$titulo[i]),
                   paste0("DESCRIPTION:", results[[j]]$nome_produto[i]),
                   paste0("DTSTART;TZID=America/Sao_Paulo:", datetime_str),
                   paste0("DTEND;TZID=America/Sao_Paulo:", datetime_str),
                   "END:VEVENT")
    }
  ics_lines <- c(ics_lines,  "END:VCALENDAR")
  ics_list[[j]] <- ics_lines
}

calendar_names <- here("output", paste0(substr(filtered_alias, 1, 50), "_calendar.ics"))

# Write to file with UTF-8 encoding
map2(.x = ics_list, .y = calendar_names, .f = writeLines)
writeLines(ics_lines, "ipca15_calendar.ics", useBytes = TRUE)
