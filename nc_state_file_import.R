# a small file to import .nc files from NOAA and state outline data

#import .nc files from NOAA website
library(ncdf4)
nc <- raster("AVHRR-Land_v004_AVH15C1_NOAA-19_20140705_c20150730160152.nc",varname="FAPAR")
plot(nc)

# import state data (better way)
contemporary_us <- us_states()
lower_48 <- contemporary_us[-c(2,8,10,47),]
il =  lower_48[10,] # get Illinois as a test

nc <- crop(nc,as(il$geometry,'Spatial')) # crop fapar data for geometry only
fapar_mask <- mask(nc,as(il$geometry,'Spatial')) # mask so all data outside of boundary is NA
plot(fapar_mask)
l <- crop(nc,as(lower_48$geometry,'Spatial'))
plot(lower_48$geometry)
plot(l)
