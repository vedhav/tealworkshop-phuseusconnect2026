library(teal)

my_data <- teal_data(
  MTCARS = head(mtcars),
  code = "MTCARS <- head(mtcars)"
)


names(my_data)

verify(my_data)

get_code(my_data, )

within(my_data, {
  IRIS <- head(iris)
})


my_data <- teal_data() |>
  within({
    MTCARS <- head(mtcars)
  })
