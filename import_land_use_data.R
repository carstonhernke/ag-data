# script to import land use data
library(sf)
library(raster)
library(tidyverse)
library(spData)
library(spDataLarge)
library(SpaDES.tools)
library(parallel)
library(snow)

fname <- "nlcd_2011_landcover_2011_edition_2014_10_10.img"
land_use <- raster(fname)
# the land use file is extremely large, so we need to run processing in parallel on different tiles
beginCluster(7)
y1 <- splitRaster(land_use,5,5)
endCluster()

m <- c(11, 0, 12, 0, 21, 0, 22, 0, 23, 0, 24, 0, 31, 0, 41, 0, 42, 0, 43, 0, 51, 0, 52, 0, 71, 0, 72, 0, 73, 0, 74, 0, 81, 0, 82, 1, 90, 0, 91, 0)
rclmat <- matrix(m, ncol=2, byrow=TRUE)

r <- raster(ncol=40, nrow=20)
r[10:20,20:25] <- 82
rc <- reclassify(r, rclmat)
plot(rc)

for (i in 1:50){
  file <- paste("nlcd_2011_landcover_2011_edition_2014_10_10/nlcd_2011_landcover_2011_edition_2014_10_10_tile",i,sep = '')
  r <- raster(file)
  r[r != 82] <- FALSE # 82 is the code that denotes agricultural uses in the dataset
  r[r != FALSE] <- TRUE
  output_file <- paste("nlcd_2011_landcover_2011_edition_2014_10_10/processed/tile",i,sep = '')
  writeRaster(x = r, filename = output_file, datatype = "LOG1S")
  rm(ag_land)
}

# reformat raster images so 1 represents cropland, save as gtiff
m <- c(11, 0, 12, 0, 21, 0, 22, 0, 23, 0, 24, 0, 31, 0, 41, 0, 42, 0, 43, 0, 51, 0, 52, 0, 71, 0, 72, 0, 73, 0, 74, 0, 81, 0, 82, 1, 90, 0, 91, 0)
rclmat <- matrix(m, ncol=2, byrow=TRUE)
beginCluster(7)
for (i in 15:25){
  file <- paste("nlcd_2011_landcover_2011_edition_2014_10_10/nlcd_2011_landcover_2011_edition_2014_10_10_tile",i,sep = '')
  r <- raster(file)
  rc <- reclassify(r, rclmat)
  output_file <- paste("nlcd_2011_landcover_2011_edition_2014_10_10/processed/tile",i,sep = '')
  writeRaster(x = rc, filename = output_file, datatype = "INT1U", format = "GTiff")
  rm(r)
  rm(rc)
  print(i)
}
endCluster()

# stitch the images back together
r1 <- raster("nlcd_2011_landcover_2011_edition_2014_10_10/processed/tile1.tif")
r2 <- raster("nlcd_2011_landcover_2011_edition_2014_10_10/processed/tile2.tif")
merge(r1, r2)
beginCluster(7)
m <- merge(r1, r2)
endCluster()
