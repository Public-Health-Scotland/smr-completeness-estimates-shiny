####################### Setup #######################

# Shiny packages ----
library(shiny)
library(shinydashboard)
library(shinycssloaders)

# Data wrangling packages ----
library(phsopendata)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)

# Plotting packages ----
library(plotly)
library(DT)
library(glue)
library(scales)

# PHS styling packages ----
library(phsstyles)


# Load core functions ----
source("functions/core_functions.R")

## Plotting ----
# Style of x and y axis
xaxis_plots <- list(
  title = FALSE, tickfont = list(size = 14), titlefont = list(size = 14),
  showline = TRUE, fixedrange = TRUE
)

yaxis_plots <- list(
  title = FALSE, rangemode = "tozero", fixedrange = TRUE, size = 4,
  tickfont = list(size = 14), titlefont = list(size = 14)
)

# Buttons to remove from plotly plots
bttn_remove <- list(
  "select2d", "lasso2d", "zoomIn2d", "zoomOut2d",
  "autoScale2d", "toggleSpikelines", "hoverCompareCartesian",
  "hoverClosestCartesian"
)

# LOAD IN DATA HERE ----

# Get the Health Board names
hb_names <- get_resource("652ff726-e676-4a20-abda-435b98dd7bdc") |>
  select(HB, HBName) |>
  distinct()

# Get the data
data <- get_resource("03cf3cb7-41cc-4984-bff6-bbccd5957679") |>
  select(HB, SMRType, Quarter, Completeness) |>
  drop_na(Completeness) |>
  mutate(
    SMRType = factor(SMRType),
    HB = factor(HB),
    # Take the Quarter and make it a month:  Q1 = Apr, Q2 = Jul, Q3 = Oct, Q4 = Jan
    month = case_match(
      str_sub(Quarter, start = 6),
      "1" ~ 4L,
      "2" ~ 7L,
      "3" ~ 10L,
      "4" ~ 1L
    ),
    year = as.integer(str_sub(Quarter, end = 4)),
    Date = make_date(year + (month == 1L), month, 1),
    completness_status = case_when(
      Completeness >= 0.95 ~ "green",
      Completeness >= 0.85 ~ "yellow",
      Completeness < 0.85 ~ "red"
    ) |> ordered(levels = c("red", "yellow", "green"))
  ) |>
  arrange(Date) |>
  left_join(hb_names, by = "HB") |>
  drop_na(HBName)

completeness_date <- get_resource("03cf3cb7-41cc-4984-bff6-bbccd5957679",
  rows = 1,
  col_select = "HB",
  include_context = TRUE
) |>
  pull(ResModifiedDate)
