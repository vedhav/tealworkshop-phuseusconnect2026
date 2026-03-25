library(teal)

tm_greeting <- function(label = "Greeting Module", greet = "Hello") {
  module(
    label = label,
    ui = function(id) {
      ns <- NS(id)
      uiOutput(ns("greeting"))
    },
    server = function(id, data) {
      moduleServer(id, function(input, output, session) {
        output$greeting <- renderUI(h2(greet))
      })
    }
  )
}

data <- teal_data() |>
  within({
    MTCARS <- mtcars
    IRIS <- iris
  })


modules <- modules(
  tm_greeting(),
  tm_greeting(label = "second module", greet = "Ahoy")
)

app <- init(
  data = data,
  modules = modules
)

shinyApp(ui = app$ui, server = app$server)
