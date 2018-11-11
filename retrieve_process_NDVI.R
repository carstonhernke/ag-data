library(sf)
library(raster)
library(tidyverse)
library(spData)
library(spDataLarge)
library(tmap)
library(USAboundaries)

# function to download FAPAR data, with parameters as arguments
import_data <- function(start_time, end_time, lat_start, lat_end, lon_start, lon_end) {
call <- paste(base,"FAPAR[(",start_time,"):1:(",end_time,")][(",lat_start,"):1:(",lat_end,")][(",lon_start,"):1:(",lon_end,")]",sep = "")
print(paste("downloading file from: ",call))
filename <- paste("raw_data/",start_time,".tif",sep = "")
try(download.file(url = call,destfile = filename))
return(filename)
}

# plot imported data to verify
plot(fapar_layer)
qtm(fapar_layer, style = 'cobalt') #alternative method

# iterate through entities (states, counties, etc.), aggregating data by using descriptive stats at the entity level
process_entities <- function(entities,fapar_layer,date){ # entities must be a sf object
temp_data <- data.frame(matrix(ncol = 9, nrow = 0))
for (entity_num in 1:nrow(entities)){
  ent = entities[entity_num,]
  ent_geometry = ent$geometry
  ent_name <- ent$name
  print(ent_name)
  fapar_crop <- crop(fapar_layer,as(ent_geometry,'Spatial')) # crop fapar data for geometry only
  fapar_mask <- mask(fapar_crop,as(ent_geometry,'Spatial')) # mask so all data outside of boundary is NA
  #plot(fapar_mask)
  #summary(mn_mask)
  v <- values(fapar_mask)
  vn <- v[!is.na(v)]
  stats = list(format(as.Date(date,origin="1970-01-01")),ent_name, min(vn), mean(vn), median(vn), max(vn), sd(vn), sum(vn), sum(is.na(v)))
  temp_data <- rbind(temp_data, t(stats))
}
return(temp_data)
}

#### IMPORT STUFF ###

# import state data (better way)
contemporary_us <- us_states()
lower_48 <- contemporary_us[-c(2,8,10,47),]

### SET STUFF UP ###

# set up dataframe
fapar_data <-  data.frame(matrix(ncol = 9, nrow = 0))
column_names <- c('Date','Name','Min','Mean','Median','Max','Standard Deviation','Sum','Count of NA')
colnames(fapar_data) <- column_names

# set import parameters
base = "https://www.ncei.noaa.gov/erddap/griddap/cdr_lai_fapar_by_time_latitude_longitude.geotif?"
date = "2009-06-01"
lat_start = "48.987386" # default parameters for a bounding box around the lower 48
lat_end = "18.005611"
lon_start = "-124.626080"
lon_end = "-62.3610148"

dates <- seq(as.Date("2009-01-01"), as.Date("2010-01-01"), by=1)

### MAIN CODE ###

# download data

for(d in dates) {
date = as.Date(d,origin="1970-01-01")
fname <- import_data(date, date, lat_start, lat_end, lon_start, lon_end)
print(paste(fname,"downloaded"))
}

# process data
for(d in dates) {
date = as.Date(d,origin="1970-01-01")
print(paste("processing",format(as.Date(date,origin="1970-01-01"))))
fname <- paste("raw_data/",date,".tif",sep = "")
fapar_layer <-  raster(fname)
temp_data <- process_entities(lower_48, fapar_layer, date)
fapar_data <- rbind(fapar_data, temp_data)
}

# afterwards, save the resulting dataframe
fdc <- fapar_data
fdcm <- as.matrix(fdc)

column_names <- c('Date','Name','Min','Mean','Median','Max','Standard Deviation','Sum','Count of NA')
colnames(fapar_data) <- column_names
write.table(fdcm,'state_fapar_date_2009.csv',row.names = FALSE)
