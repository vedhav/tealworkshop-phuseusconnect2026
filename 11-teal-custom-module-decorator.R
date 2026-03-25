library(teal)
library(plotly)

tm_xy_plot <- function(label = "XY Scatter Plot",
                       dataname,
                       x = "Sepal.Length",
                       y = "Sepal.Width",
                       decorators = list()) {
  # teal.module.clinical uses this pattern
  # teal::assert_decorators(decorators, "plot")
  # select_decorators <- utils::getFromNamespace("select_decorators", "teal")
  # select_decorators(decorators, "plot")

  module(
    label = label,
    datanames = dataname,
    ui = function(id) {
      ns <- NS(id)
      tagList(
        teal::ui_transform_teal_data(
          ns("decorator"),
          transformators = decorators[["plot"]]
        ),
        plotlyOutput(ns("scatter"))
      )
    },
    server = function(id, data) {
      moduleServer(id, function(input, output, session) {
        plot_q <- reactive({
          req(data())
          within(
            data(),
            {
              plot <- plot_ly(dataname,
                x = ~ get(x_var), y = ~ get(y_var),
                type = "scatter", mode = "markers"
              ) |>
                plotly::layout(
                  xaxis = list(title = x_var),
                  yaxis = list(title = y_var)
                )
            },
            dataname = data()[[dataname]],
            x_var = x,
            y_var = y
          )
        })

        decorated_q <- teal::srv_transform_teal_data(
          id = "decorator",
          data = plot_q,
          transformators = decorators[["plot"]]
        )

        output$scatter <- renderPlotly({
          req(decorated_q())
          decorated_q()[["plot"]]
        })
      })
    }
  )
}

change_color <- teal_transform_module(
  label = "Change Plot Color",
  ui = function(id) {
    ns <- NS(id)
    selectInput(
      ns("color"), "Marker Color",
      choices = c("red", "blue", "green", "orange", "purple"),
      selected = "red"
    )
  },
  server = function(id, data) {
    moduleServer(id, function(input, output, session) {
      reactive({
        req(data())
        within(
          data(),
          {
            plot <- plotly::style(plot, marker = list(color = color))
          },
          color = input$color
        )
      })
    })
  }
)

data <- teal_data() |>
  within({
    IRIS <- iris
  })

app <- init(
  data = data,
  modules = modules(
    tm_xy_plot(
      label = "Sepal",
      dataname = "IRIS",
      x = "Sepal.Length",
      y = "Sepal.Width",
      decorators = list(plot = change_color)
    ),
    tm_xy_plot(
      label = "Petal",
      dataname = "IRIS",
      x = "Petal.Length",
      y = "Petal.Width",
      decorators = list(plot = change_color)
    )
  )
)

shinyApp(ui = app$ui, server = app$server)
