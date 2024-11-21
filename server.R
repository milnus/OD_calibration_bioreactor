library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
function(input, output, session) {
  # Observe upload events
  observeEvent(input$upload_calibration, {
    print(paste("upload_calibration:", input$upload_calibration[1,4]))
  })
  
  observeEvent(input$upload_data, {
    print(paste("upload_data:", input$upload_data[1,4]))
  })
  
  # observeEvent(input$process, {
  #   print(paste("process:", input$process))
  # })
  
  observeEvent(input$origin_point, {
    print(paste("Origin point addition:", input$origin_point))
  })
  
  # observeEvent(input$process, {
  #   print(paste("Origin point addition:", input$origin_point))
  # })
  
  observeEvent(input$fixed_intercept, {
    print(paste("input$fixed_intercept:", input$fixed_intercept))
    })
  
  # Read in data from PioReactors
  od_data_frame <- reactive(raw_pio_od_data_to_wide_frame_keep_raw_time(input$upload_data[1,4]))

  output$zero_point_box <- renderUI({
    if (length(input$fixed_intercept)){
    if (!as.logical(input$fixed_intercept)){
      origin_point_box()
      }
    }
  })

  # manual_od_readings <- eventReactive(eventExpr = {
  #   input$origin_point
  #   input$process
  #   # input$
  # },{
  #   read_manual_ods(input$upload_calibration[1,4])
  # })
  
  manual_od_readings <- reactive(read_manual_ods(input$upload_calibration[1,4]))
  
  output$calibration_points <- renderUI({ui_num_od_read(manual_od_readings())})
  
  # Check if no pio reactor ODs have given, if so calculate these.
  complete_od_data <- reactive(no_pio_ods_check(manual_od_readings(), od_data_frame(), input$x_pio_ods))
  
  manual_lm_models <- reactive(split_od_per_reactor(complete_od_data(), as.logical(input$fixed_intercept), input$origin_point))
  
  # Use linear models to predict "true" values for PioReactors
  od_calibration_readings <- reactive(predict_calibrated_ods(manual_lm_models(), od_data_frame())) ## TODO - Change the od_data_frame() to be the return from the no_pio_ods_check
  
  #### Plots ####
  # Plot the regressions underlying the calibration
  output$no_pio_values_plot <- renderPlot({
    if (length(input$fixed_intercept) == 0){
      ggplot()
    } else{
    calibration_plot(manual_lm_models(), as.logical(input$fixed_intercept), input$origin_point)
      }
  }, res = 96,
  width = function() input$width,
  height = function() input$height)
  
  # Plot the points used from piorector OD, if none are given by the user
  output$zero_intercept_plot <- renderPlot({
    first_last_od_plot(complete_od_data())
  }, res = 96)
  
  
  output$download_table <- downloadHandler(
    filename = function() {
      "Calibrated_OD_reading.csv"
    },
    content = function(file) {
      write.table(write_calibrate_od_to_pio_format(od_calibration_readings()), file, row.names = F, col.names = T, sep = ",", na = "", quote = F)
    }
  )

}
