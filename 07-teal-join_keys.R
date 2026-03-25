library(teal)
library(teal.modules.clinical)

data <- teal_data()
data <- within(data, {
  ADSL <- tmc_ex_adsl
  ADTTE <- tmc_ex_adtte
})
join_keys(data) <- default_cdisc_join_keys[names(data)]

join_keys(
  join_key("ADSL", "ADSL", c("STUDYID", "USUBJID")),
  join_key("ADTTE", "ADTTE", c("STUDYID", "USUBJID", "PARAMCD")),
  join_key("ADSL", "ADTTE", c("STUDYID", "USUBJID"))
)

identical(
  default_cdisc_join_keys[names(data)],
  join_keys(
    join_key("ADSL", "ADSL", c("STUDYID", "USUBJID")),
    join_key("ADTTE", "ADTTE", c("STUDYID", "USUBJID", "PARAMCD")),
    join_key("ADSL", "ADTTE", c("STUDYID", "USUBJID"))
  )
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
