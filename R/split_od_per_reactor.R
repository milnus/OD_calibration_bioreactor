#### Function to take split each reactor measurements and construct linear regression models ####
split_od_per_reactor <- function(calibration_table, fixed_intercept, add_zero_point) {
  print("[split_od_per_reactor] - STARING")
  calibration_table <- calibration_table[["calibration_table"]]

  # Check if an origin point should be added
  if (length(add_zero_point) == 0) {
    add_zero_point <- FALSE
  }

  if (length(fixed_intercept) == 0) {
    return(NULL)
  }

  # Split the data into reactor datasets
  # split_reactor_table <- split(calibration_table, list(calibration_table[, reactor_name_col_num]))
  split_reactor_table <- split(calibration_table, list(calibration_table[, "reactor"]))

  print(paste("[split_od_per_reactor] - add_zero_point:", add_zero_point))
  if (add_zero_point & !fixed_intercept) {
    for (i in 1:length(split_reactor_table)) {
      split_reactor_table[[i]][nrow(split_reactor_table[[i]]) + 1, ] <- list(
        "reactor" = split_reactor_table[[i]][1, 1],
        "pio_od" = 0,
        "manual_od" = 0
      )
    }
  }

  # Construct a linear model for each

  # return list of linear models
  print(paste("[split_od_per_reactor] - fixed_intercept:", fixed_intercept))
  if (fixed_intercept) {
    reactor_lm_models <- lapply(split_reactor_table, lm, formula = manual_od ~ pio_od - 1)
  } else {
    reactor_lm_models <- lapply(split_reactor_table, lm, formula = manual_od ~ pio_od)
  }


  return_list <- list()
  for (ID in names(reactor_lm_models)) {
    return_list[[ID]] <- list(
      "calibration_model" = reactor_lm_models[[ID]],
      "calibtation_data" = split_reactor_table[[ID]]
    )
  }

  return(return_list)
}
