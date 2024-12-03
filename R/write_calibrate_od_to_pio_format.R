write_calibrate_od_to_pio_format <- function(calibrated_data) {
  filtered_calibrated_data <- lapply(calibrated_data, function(x) x[!is.na(x[, 2]), ])

  write_frame <- data.frame(
    "timestamp_localtime" = unlist(lapply(filtered_calibrated_data, function(x) as.character(x[, 3]))),
    "experiment" = NA,
    "pioreactor_unit" = unlist(sapply(1:length(filtered_calibrated_data), function(i) rep(names(filtered_calibrated_data)[i], nrow(filtered_calibrated_data[[i]])), simplify = F)),
    "timestamp" = NA,
    "od_reading" = unlist(lapply(filtered_calibrated_data, function(x) x[, 2])),
    "angle" = NA,
    "channel" = NA
  )
  # Convert hours to date
  # write_frame$timestamp_location <- as.Date(as.POSIXct(write_frame$timestamp_localtime, tz = 'GMT'))
  write_frame$timestamp <- write_frame$timestamp_localtime

  write_frame <- write_frame[order(write_frame[, "timestamp_localtime"]), ]

  return(write_frame)
}
