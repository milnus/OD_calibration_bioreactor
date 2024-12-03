#### Function to allow user to select addition of a point through (0,0) ####
origin_point_box <- function() {
  checkboxInput(
    inputId = "origin_point",
    label = "Add (0,0) point",
    value = FALSE
  )
}
