no_pio_ods_check <- function(calibration_table, raw_pio_od, x_measurements_oi){
  print("[no_pio_ods_check] - STARTING")
  print(paste("x_measurements_oi:", x_measurements_oi))
  
  # Create a return list with first and last ten for later plotting.
  first_last_x_list <- list()
  
  # Check if no PioReactor ODs were given
  if (all(is.na(calibration_table[,"pio_od"]))){
    for (reactor in unique(calibration_table[,"reactor"])){
      print(paste("[no_pio_ods_check] - ", reactor))
      # grep out the column
      od_column_oi <- grep(paste0("od_reading.", reactor), colnames(raw_pio_od))
      
      od_readings_oi <- raw_pio_od[, od_column_oi]
      
      # Remove NAs
      od_readings_oi <- od_readings_oi[!is.na(od_readings_oi)]
      
      # Identify first and last 10 (or X)
      x_measurements_oi
      first_od_oi <- od_readings_oi[1:x_measurements_oi]
      last_od_oi <- od_readings_oi[(length(od_readings_oi)-x_measurements_oi+1):length(od_readings_oi)]

      # Save the top and last 10 in return list
      first_last_x_list[[reactor]] <- data.frame("position" = rep(c("First", "Last"), each = x_measurements_oi),
                                                 "od_reading" = c(first_od_oi, last_od_oi),
                                                 "reactor" = reactor)
      
      # Calculate the average (median or IQR mean) and insert into the fitting manual OD.
      first_od_value <- NA
      last_od_value <- NA
      mean_type <- "Innerquantile mean"
      if (mean_type == "Mean"){
        first_od_value <- mean(first_od_oi)
        last_od_value <- mean(last_od_oi)
      } else {
        if (mean_type == "Innerquantile mean"){
          first_od_value <- mean(first_od_oi[first_od_oi >= quantile(first_od_oi, 0.25) & 
                                               first_od_oi <= quantile(first_od_oi, 0.75)])
          last_od_value <- mean(last_od_oi[last_od_oi >= quantile(last_od_oi, 0.25) &
                                             last_od_oi <= quantile(last_od_oi, 0.75)])
        }
      }
      reading_order <- order(calibration_table[calibration_table[,"reactor"] == reactor, "manual_od"])
      calibration_table[calibration_table[,"reactor"] == reactor, "pio_od"][reading_order] <- c(first_od_value, last_od_value)
    }
  }
  
  first_last_x_df <- do.call("rbind", first_last_x_list)
  
  return(list("calibration_table" = calibration_table, "first_last_x_df" = first_last_x_df))
}