<h1> Using Remote-Sensing Data to Predict Crop Yields </h1>

<h2> Project Overview </h2>

1. **Project goal:**
The goal of this project is to accurately predict yields of row crops (primarily corn and soybeans) from remote-sensed (satellite) data.

1. **Background/ existing work:**
Commodity futures market prices are dependent on two factors - supply and demand. Demand is dependent on general market conditions, price and availability of compliments and substitutes, as well as other factors. The supply side is dependent on the quantity of crops that are grown (harvest size). Historically, predictions of harvest size have been very low-tech. Typically, forecasts will be based on surveys from farmers, observations of crop health, and weather conditions during the growing season. However, the availability of high-quality remote-sensed data on surface reflectivity has opened up a new way to measure crop health and forecast harvest size. However, despite the original Landsat satellite being launched in 1981, use of this data was limited until recently. Now, companies such as Cargill, Descartes Labs, The Weather Company have begun using both public and private satellite data in their models.

1. **Why this project interests me:**
This project is extremely interesting to me because of juxtaposition of scale and precision, as well as the use of a novel data source. Over 200bn bushels of corn were harvested in the USA in 2017, involving 12% of land. The goal of this project is to distill such a large, complicated process into a single number. The use of remote-sensing data is also something I am very excited about - satellites have given our society an unprecedented overview of our planet and I believe that we are just scratching the surface of the potential of this technology.

<h2> The project itself </h2>

1. Research

_Language & platform to use for analysis:_
After some research, I found the ebook ["Geocomputation with R"](https://geocompr.robinlovelace.net/). This ebook by Robin Lovelace, Jakub Nowosad, and Jannes Muenchow provides a great introduction to interacting with geospatial data programatically. It also highlights the power of R for these projects over GUI-based programs like ArcGIS and other languages like Python, primarily because of the large number of geospatial libraries written in R (like Sp, etc.). I have used R for projects in the past but would not consider myself an expert, so this project will give me a good opportunity to sharpen my skills.

_Imagery:_
After some research, I learned that the primary metrics for crop health are NDVI, LAI, and FAPAR. These are all derived from multispectral imagery (typically some combination of the Red-Green spectrum). There are many satellites collecting this data, but the most complete and publicly-accessible dataset seems to be the one produced by the American NOAA and available [here](https://www.ncdc.noaa.gov/cdr/terrestrial/leaf-area-index-and-fapar). It is .05x.05 resolution, which is relatively poor. 30m resolution is available from satellites such as the LISS (indian), but the data is not easily available. There are likely other private satellites collecting even more high-resolution imagery.

_Market data:_
Though it isn't the primary focus of the project, I though it would be interesting to explore how market prices change throughout the growing season. I found a collection of the high/low/open/close/vol for the CBOT Corn Futures market from [investing.com](https://www.investing.com/commodities/us-corn-historical-data) and downloaded it (copy/ paste worked fine).

_Benchmarking data:_
The USDA produces [reports](https://quickstats.nass.usda.gov/api) weekly and monthly throughout the growing season measuring crop progress, quality, and yield (among others). The release of these reports has a large impact on the price of the commodity.

_Land cover data:_
The product that the NOAA produces gives the NDVI for the entire world. However, I am only interested in the values where crops are actually grown. After some research, I found the MRLC (MultiResolutionLandCharacteristics consortium). This group produces [data](https://www.mrlc.gov/nlcd11_leg.php) on how land in the USA is used. #22 should work well for my purposes.

_Weather data:_
Weather has a huge impact on the quality of a crop, so it is something that I'm interested in exploring. For historical weather data, I found the [US NOMADs database](https://www.ncdc.noaa.gov/nomads). For current forecasts, the NCDC produces a [rapid-refresh model](https://www.ncdc.noaa.gov/data-access/model-data/model-datasets/rapid-refresh-rap) every 6 hours.

2. Data collection
To collect the raster FAPAR data, I used an [API](https://coastwatch.pfeg.noaa.gov/erddap/griddap/documentation.html) provided by NOAA. I made a function in R to set a bounding box around the USA, then called the API and downloaded the resulting .tiff to a local folder, naming it with the date. To collect data over time, I looped through the desired dates, downloading each file.

For data on the outline of US states, I used the library USBoundaries. This made it incredibly easy to download data on state boundaries in a datatype that I could easily interact with.

3. Data cleaning and pre-processing
After all of the data was downloaded, I had raster data on FAPAR in the continental US for every day in 2009. First, I used the mask() and crop() functions to remove all data from areas that weren't used for agriculture. However, these .tiff images aren't quantitative and can't easily be incorporated into any type of analysis. To extract meaningful data from these images I decided to break them up into regions and calculate basic descriptive statistics (min/mean/median/max + NAcount) for each. At first I set these regions as states, but after realizing this led to very low-quality output I switched these regions to be counties. After this, I had a spreadsheet with the average FAPAR for each county in the US for every day of the year (approx 2 million rows). This seemed like a good enough point to start exploring this data with a tool like Tableau.

<h2> Future goals of this project <h2/> 

1. Exploratory analysis & visualization
1. (More) data collection
1. Machine learning model-building
1. Testing & improvement
1. Visualization
1. Conclusion & future analysis
