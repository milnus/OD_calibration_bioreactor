#### Function to use calibration models to predict calibrated od values ####
predict_calibrated_ods <- function(calibration_models, raw_data){
  reactor_names <- names(calibration_models)
  
  calibrated_od_list <- list()
  
  for (name in reactor_names){
    raw_data_isolate <- raw_data[,c(1, grep(name, names(raw_data)))]
    
    colnames(raw_data_isolate)[2] <- 'pio_od'
    model <- calibration_models[[name]]$calibration_model
    
    calibrated_od_list[[name]] <- data.frame('hours' = raw_data_isolate[,1],
                                             'Calibrated_OD' = predict(model, raw_data_isolate),
                                             'raw_time' = raw_data_isolate[,3])
  }

  return(calibrated_od_list)
}