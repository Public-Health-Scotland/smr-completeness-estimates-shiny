####################### Intro Page #######################

output$intro_page_ui <- renderUI({
  dashboardPage(
    dashboardHeader(title = "SMR Completeness"),
    dashboardSidebar(
      selectInput("health_board", "Health Board", choices = unique(data$HBName)),
      selectInput("smr_type", "SMR Type", choices = unique(data$SMRType))
    ),
    dashboardBody(
      fluidRow(
        title = glue("Completeness data as of {format(completeness_date, '%d %B %Y')}"),
        status = "primary",
        solidHeader = TRUE,
        textOutput("completeness_date")
      ),
      fluidRow(
        title = "Completeness by Health Board and SMR Type",
        status = "primary",
        solidHeader = TRUE,
        dataTableOutput("table")
      ),
      fluidRow(
        title = "Completeness by Health Board and SMR Type",
        status = "primary",
        solidHeader = TRUE,
        plotlyOutput("plot")
      )
    )
  )
}) # renderUI


output$completeness_date <- renderText({
  glue("Completeness data as of {format(completeness_date, '%d %B %Y')}")
})

output$table <- renderDataTable({
  data_hb() |>
    select(-HB, -completness_status, -Date)
})

output$plot <- renderPlotly({
  data_hb() |>
    ggplot(aes(x = Date, y = Completeness)) +
    geom_line() +
    geom_point(aes(colour = completness_status)) +
    # Apply the colour status to the colour of the point
    scale_colour_manual(values = c("red" = phs_colors("phs-graphite"), "yellow" = phs_colors("phs-blue"), "green" = phs_colors("phs-green"))) +
    # Format y as percent and limit between 0 and 1
    scale_y_continuous(labels = percent, limits = c(0, 1)) +
    scale_x_date() +
    labs(
      title = str_wrap(
        glue("Completeness by Quarter, for {input$health_board}, {input$smr_type}"), 
        width = 40),
      x = "Quarter",
      y = "Completeness"
    ) +
    theme_minimal() +
    theme(legend.position = "none")
})
