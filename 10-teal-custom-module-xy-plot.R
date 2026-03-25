library(teal)
library(plotly)

tm_xy_plot <- function(label = "XY Scatter Plot",
                       dataname,
                       x = "Sepal.Length",
                       y = "Sepal.Width") {
  module(
    label = label,
    datanames = dataname,
    ui = function(id) {
      ns <- NS(id)
      plotlyOutput(ns("scatter"))
    },
    server = function(id, data) {
      moduleServer(id, function(input, output, session) {
        output$scatter <- renderPlotly({
          df <- data()[[dataname]]
          plot_ly(df,
            x = ~ get(x), y = ~ get(y),
            type = "scatter", mode = "markers"
          ) |>
            layout(
              xaxis = list(title = x),
              yaxis = list(title = y)
            )
        })
      })
    }
  )
}

data <- teal_data() |>
  within({
    MTCARS <- mtcars
    IRIS <- iris
  })


app <- init(
  data = data,
  modules = modules(
    tm_xy_plot(dataname = "IRIS", x = "Sepal.Length", y = "Sepal.Width"),
    tm_xy_plot(dataname = "IRIS", x = "Petal.Length", y = "Petal.Width")
  )
)

shinyApp(ui = app$ui, server = app$server)
