# Function to calculate innerquantile mean (IQM)
IQM <- function(x) {
  y = mean(x[x >= quantile(x, 0.25) &
                          x <= quantile(x, 0.75)])
}

first_last_od_plot <- function(first_last_x_df){
  print(first_last_x_df)
  first_last_x_df <- first_last_x_df[["first_last_x_df"]]
  if (is.null(first_last_x_df)){
    ggplot()
  } else{
  x_nudge <- 0.1
  
  
  ggplot(first_last_x_df, aes(reactor, od_reading)) +
    geom_point(position = position_nudge(x = x_nudge)) +
    # stat_summary(geom = "point", fun = "median", colour = "red", shape = 17, position = position_nudge(x = -x_nudge)) +
    stat_summary(geom = "point", fun = "mean", colour = "red", shape = 16, position = position_nudge(x = -x_nudge)) +
    # stat_summary(geom = "point", fun = IQM, colour = "red", shape = 19, position = position_nudge(x = -x_nudge)) +
    facet_grid(.~position)
  }
}