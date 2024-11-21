#### Plot linear regressions for calibration ####
calibration_plot <- function(od_calibration_readings, fixed_intercept, add_zero_point){
  print("[calibration_plot] - STARING")
  print(paste("[calibration_plot] - fixed_intercept:", fixed_intercept))
  print(paste("[calibration_plot] - add_zero_point:", add_zero_point))
  print(paste("[calibration_plot] - length(add_zero_point):", length(add_zero_point)))
  
  if (length(add_zero_point) == 0){
    add_zero_point <- FALSE
  }

  
  linear_regress_plots <- lapply(od_calibration_readings, function(x) {
    # Set the intercept and slope of the model
    if (fixed_intercept){
      slope_coefficient <- summary(x$calibration_model)$coefficients[1]
      intercept_coefficient <- 0
    } else {
      slope_coefficient <- summary(x$calibration_model)$coefficients[2]
      intercept_coefficient <- summary(x$calibration_model)$coefficients[1]
    }
    
    if (add_zero_point & !fixed_intercept){
      col_vec <- c(rep("black", nrow(x$calibtation_data)-1), "red")
    } else {
      col_vec <- rep("black", nrow(x$calibtation_data))
    }
    
    # Plot
    ggplot(x$calibtation_data, aes(pio_od, manual_od)) +
      geom_point(col = col_vec) + 
      geom_abline(slope = slope_coefficient, intercept = intercept_coefficient, linetype = 'dashed', colour = 'red') +
      geom_text(data=data.frame(), aes(label = paste0('slope=', round(slope_coefficient, 2)), x = -Inf, y = Inf),
                hjust = 0, vjust = 1) +
      geom_text(data=data.frame(), aes(label = paste0('R^2=',round(summary(x$calibration_model)$r.squared, 3)), x = -Inf, y = Inf),
                hjust = 0, vjust = 2.5) +
      ggtitle(x$calibtation_data$reactor[1]) + 
      scale_y_continuous(limits = c(-0.1,NA)) +
      scale_x_continuous(limits = c(-0.1,NA))
    }
  )
  
  do.call(gridExtra::grid.arrange, c(linear_regress_plots))
}