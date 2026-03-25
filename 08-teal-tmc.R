library(teal)
library(teal.module.clinical)
# https://insightsengineering.github.io/teal.modules.clinical/latest-tag/reference/index.html

data <- teal_data()
data <- within(data, {
  ADSL <- tmc_ex_adsl
  ADTTE <- tmc_ex_adtte
})
join_keys(data) <- default_cdisc_join_keys[names(data)]

ADSL <- data[["ADSL"]]
ADTTE <- data[["ADTTE"]]

arm_ref_comp <- list(
  ACTARMCD = list(
    ref = "ARM B",
    comp = c("ARM A", "ARM C")
  ),
  ARM = list(
    ref = "B: Placebo",
    comp = c("A: Drug X", "C: Combination")
  )
)

app <- init(
  data = data,
  modules = modules(
    tm_g_km(
      label = "Kaplan-Meier Plot",
      dataname = "ADTTE",
      arm_var = choices_selected(
        variable_choices(ADSL, c("ARM", "ARMCD", "ACTARMCD")),
        "ARM"
      ),
      paramcd = choices_selected(
        value_choices(ADTTE, "PARAMCD", "PARAM"),
        "OS"
      ),
      arm_ref_comp = arm_ref_comp,
      strata_var = choices_selected(
        variable_choices(ADSL, c("SEX", "BMRKR2")),
        "SEX"
      ),
      facet_var = choices_selected(
        variable_choices(ADSL, c("SEX", "BMRKR2")),
        NULL
      )
    )
  )
)

shinyApp(app$ui, app$server)
