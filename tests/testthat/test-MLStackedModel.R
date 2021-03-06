context("StackedModel")

model <- StackedModel(GBMModel, GLMNetModel(lambda = 0.01))

test_that("model fitting", {
  skip_if_not(TEST_MODEL_FITTING)
  with_parallel({
    expect_output(test_model_factor(model))
    expect_output(test_model_factor2(model))
    expect_output(test_model_numeric(model))
    expect_output(test_model_ordered(model))
    expect_output(test_model_Surv(model))
  })
})
