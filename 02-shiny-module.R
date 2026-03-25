library(shiny)

module_ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("greeting"))
}
module_server <- function(id, greet) {
  moduleServer(id, function(input, output, session) {
    output$greeting <- renderUI(greet)
  })
}

ui <- div(
  uiOutput("greeting_1"),
  uiOutput("greeting_2")
)
server <- function(input, output, session) {
  output$greeting_1 <- renderUI("Hello")
  output$greeting_2 <- renderUI("Ahoy")
}
shinyApp(ui, server)
