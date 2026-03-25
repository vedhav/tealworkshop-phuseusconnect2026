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
  modules = modules,
  filter = teal_slices(teal_slice("MTCARS", "cyl"))
) |>
  modify_title("Modified title") |>
  modify_header("Modified header") |>
  modify_footer("Modified footer")

shinyApp(ui = app$ui, server = app$server)
