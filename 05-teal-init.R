library(teal)

data <- teal_data(
  MTCARS = head(mtcars),
  IRIS = iris
)
modules <- modules(
  example_module(),
  example_module(label = "second module")
)

app <- init(
  data = data,
  modules = modules
)

shinyApp(ui = app$ui, server = app$server)
