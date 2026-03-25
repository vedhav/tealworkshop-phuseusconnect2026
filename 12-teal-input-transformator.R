library(teal)

data_transformators <- list(
  teal_transform_module(
    label = "Interactive transformator for iris",
    datanames = "iris",
    ui = function(id) {
      ns <- NS(id)
      tags$div(
        numericInput(ns("n_cols"), "Show n columns", value = 5, min = 1, max = 5, step = 1)
      )
    },
    server = function(id, data) {
      moduleServer(id, function(input, output, session) {
        reactive({
          within(data(),
            {
              iris <- iris[, 1:n_cols]
            },
            n_cols = input$n_cols
          )
        })
      })
    }
  )
)

output_decorator <- teal_transform_module(
  server = make_teal_transform_server(
    expression(
      object <- rev(object)
    )
  )
)

app <- init(
  data = teal_data(iris = iris),
  modules = example_module(
    transformators = data_transformators,
    decorators = list(output_decorator)
  )
)

shinyApp(app$ui, app$server)
