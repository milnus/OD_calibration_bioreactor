ui_num_od_read <- function(calibration_table) {
  print("TEST")
  print(calibration_table)
  if (is.null(calibration_table)) {
    return()
  } else {
    if (all(is.na(calibration_table["pio_od"]))) {
      print("in")
      out_ui <- numericInput(
        inputId = "x_pio_ods",
        label = "Number of first and last PioReactor OD readings to use for calibration",
        value = 10, min = 1, max = 50
      )
      return(out_ui)
    }
  }
}
