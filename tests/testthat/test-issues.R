test_that("use", {

  skip("Issue 90, Issue #90")
  filename <- get_babette_path(
    "Felinecoronavirus_Envelope_1.fas"
  )
  tipdates_filename <- get_babette_path(
    "Felinecoronavirus_Envelope_1_no_quotes.txt"
  )
  inference_model <- create_inference_model(
    tipdates_filename = tipdates_filename,
    clock_model = create_rln_clock_model()
  )

  # Could not find object associated with idref clockRate.c:Felinecoronavirus_Envelope_1          # nolint
  #                                                                                               # nolint
  # Error detected about here:                                                                    # nolint
  #                                                                                               # nolint
  # <beast>                                                                                       # nolint
  #   <run id='mcmc' spec='MCMC'>                                                                 # nolint
  #     <operator id='StrictClockRateScaler.c:Felinecoronavirus_Envelope_1' spec='ScaleOperator'> # nolint
  #       <input>                                                                                 # nolint

  expect_silent(
    bbt_run_from_model(
      fasta_filename = filename,
      beast2_options = create_beast2_options(verbose = TRUE),
      inference_model = inference_model
    )
  )
})

test_that("clockRate.c ID and ClockPrior.c ID added twice", {

  skip("Issue 93, Issue #93")

  if (!is_beast2_installed()) return()
  # From https://github.com/ropensci/beautier/issues/127
  # From https://github.com/ropensci/beautier/issues/128

  # clock_model
  clock_rate <- 0.0000001
  clock_model <- create_strict_clock_model(
    clock_rate_param = create_clock_rate_param(value = clock_rate),
    clock_rate_distr = create_log_normal_distr(
      value = clock_rate,
      m = 1,
      s = 1.25
    )
  )

  # MRCA PRIOR
  mrca_prior <- create_mrca_prior(
    is_monophyletic = TRUE,
    mrca_distr = create_laplace_distr(mu = 1990)
  )


  inference_model <- create_inference_model(
    clock_model = clock_model,
    mrca_prior = mrca_prior,
    tipdates_filename = beautier::get_beautier_path(
      "THAILAND_TEST.clust_1.dated.txt"
    ),
    mcmc = create_test_mcmc()
  )
  expect_error(
    bbt_run_from_model(
      fasta_filename = beautier::get_beautier_path(
        "THAILAND_TEST.clust_1.dated.fa"
      ),
      inference_model = inference_model
    ),
    "Two sequences with different length found"
  )
})
