# take the csv file created by retrive_process_NDVI.R and plot it

data <- read.csv("/Users/carstonhernke/Downloads/cdr_lai_fapar_by_time_latitude_longitude_7a5f_210b_235e.csv")
head(data)
library(ggplot2)
m <- ggplot(data,aes(latitude,longitude))
m = m + geom_raster(aes(fill = FAPAR))
m
