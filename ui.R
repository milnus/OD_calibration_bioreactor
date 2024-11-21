library(shiny)
library(ggplot2)
options(shiny.maxRequestSize = 100*1024^2)

# Workaround for Chromium Issue 468227
downloadButton <- function(...) {
  tag <- shiny::downloadButton(...)
  tag$attribs$download <- NULL
  tag
}

sidebarPanel2 <- function (..., out = NULL, width = 4) 
{
  div(class = paste0("col-sm-", width), 
      tags$form(class = "well", ...),
      out
  )
}

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Calibration on OD using manual OD measurements"),
    
    sidebarPanel2(fluid = FALSE,
      # Box for uploading PioReactor data
      fileInput('upload_data', label = 'PioReactor OD table', accept = c('.csv', '.txt')),
      
      # Box for uploading Manual calibration data with information attached
      fileInput('upload_calibration', label = 'Manual OD measurments table', accept = c('.csv', '.txt')), 
      out = h5("Format of 'Manual OD table' should be comma separation of columns (csv). Two columns are required with key words: manual, reactor. manual: Manual OD measurement to be realted to PioReactor. reactor: Name of reactor corresponding to name of reactor in raw PioReactor OD reading file.
               A third column: pio can be given. The pio column should contain: OD from PioReactor to be related to manual OD."),
      
      # Create 'pop-up' box that takes the number of od readings to use for calibration
      uiOutput("calibration_points"),
      #""
      
      # Upon data upload
      ## Create a box for each reactor into which sample description and replicate number can be writen separated by semi-colon.
      ## Only a single value without semi-colon will indicate only sample description as given.
      
      radioButtons('fixed_intercept', label = "Intercept fixed in (0,0)", choices = c(TRUE, FALSE), selected = character(0)),
      uiOutput("zero_point_box"),
      
      # actionButton("process", "Process data"),
      
      
      sliderInput("height", "Plot height", min = 250, max = 1000, value = 500),
      sliderInput("width", "Plot width", min = 250, max = 1000, value = 500),
      
      # Insert version text
      div("version 0.0.4")
    ),
    
    mainPanel(
      downloadButton("download_table", label = "Download calibrated data"),
      plotOutput("zero_intercept_plot"),
      
      plotOutput("no_pio_values_plot")
    )
)
