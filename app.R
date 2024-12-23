##########################################################
# SMR Completeness Estimates
# Original author(s): James McMahon
# Original date: 2024-12-23
# Written/run on RStudio server 2022.7.2.576.12 and R 4.1.2
# Description of content
##########################################################


# Get packages
source("setup.R")

# UI
ui <- fluidPage(
  tagList(
    tags$html(lang = "en"), # Set the language of the page - important for accessibility
    # Specify most recent fontawesome library - change version as needed
    tags$style("@import url(https://use.fontawesome.com/releases/v6.6.0/css/all.css);"),
    navbarPage(
      id = "intabset", # id used for jumping between tabs
      title = div(
        tags$a(
          img(
            src = "phs-logo.png", height = 40,
            alt = "Go to Public Health Scotland (external site)"
          ),
          href = "https://www.publichealthscotland.scot/",
          target = "_blank"
        ), # PHS logo links to PHS website
        style = "position: relative; top: -5px;"
      ),
      windowTitle = "SMR Completness Estimates", # Title for browser tab
      header = tags$head(
        includeCSS("www/styles.css"), # CSS stylesheet
        tags$link(rel = "shortcut icon", href = "favicon_phs.ico") # Icon for browser tab
      ),
      ############################################## .
      # INTRO PAGE ----
      ############################################## .
      tabPanel(
        title = "SMR Completenness",
        icon = icon_no_warning_fn("circle-info"),
        value = "intro",
        h1("Welcome to the dashboard"),
        uiOutput("intro_page_ui")
      ), # tabpanel
      ############################################## .
      # CONTACT PAGE ----
      ############################################## .
      tabPanel(
        title = "Contact",
        icon = icon_no_warning_fn("envelope"),
        value = "contact",
        h1("Contact us"),
        uiOutput("contact_page_ui")
      ) # tabpanel
    ) # navbar
  ) # taglist
) # ui fluidpage

# Server ----

server <- function(input, output, session) {
  # Make a reactive object for the HB filter
  data_hb <- reactive({
    data |>
      filter(HBName == input$health_board) |>
      filter(SMRType == input$smr_type)
  })
  
  # Get content for individual pages
  source(file.path("pages/intro_page.R"), local = TRUE)
  source(file.path("pages/contact_page.R"), local = TRUE)
}

# Run the application
shinyApp(ui = ui, server = server)

### END OF SCRIPT ###
