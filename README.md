# biosensor - A Library for Biosensor Data Analysis

***

## Introduction

The purpose of this library is to process with the raw data from the
Maverick M1 detection system (Genalyte, Inc., San Diego, CA) and output simple
line graphs, bar charts, and box plots. The functions also generate companion
csv files containning processed the prcoessed data for subsequent analysis.
Additional functions are available to general calibration curves.
The folder containing output from the M1 typically consists of:

1. a csv file for each ring and
2. a comments file the describes the experimental run

The comments file is not needed for this program. In addition to the csv files
for each ring, a separate file containing the chip layout is required. An
example of a chip layout file is provided in the sample data. To access this 
data, execute the following code:
```{r}
library(biosensor)
dir <- setwd(system.file("extdata", "sampleChipLayout", package = "biosensor"))
example <- read.csv("groupNames_Example.csv")
View(example)
```

Note: This version of the software is optimized for the Bailey lab's HRP
assay. See dx.doi.org/10.1021/acscentsci.5b00250 for a description. However,
input variables can be altered to accomodate many alternative experiments.

***

## Getting started

### To get started, follow these steps:

1. If you have not already done so, download and install R and RStudio. There 
are many online tutorials available with instructions.
2. Ensure all of your packages are up to date. To update all packages, run 
`update.packages()` in the Console in RStudio.
3. All files for this library are located 
[here](https://github.com/BaileyLabUM/biosensor). To install this library on
your local machine requires the `devtools` library. Run the following code to
install `devtools` and the `biosensor` package.
```
# uncomment the line below if devtools is not installed
# install.packages("devtools")
devtools::install_github("BaileyLabUM/biosensor")
```

***

## Library Instructions

The functions within this library include:

1. `analyzeBiosensorData` - This function processes raw data from a single 
biosensor experiment and outputs simple line graphs, bar charts, and box plots.
In principle, this code should also work for any bionsensor data that ouputs
Time in column one and Signal in column two. The function call also generates
companion csv files containning processed the prcoessed data for subsequent 
analysis.
2. `calibrationStation` - This function processes a series of experiments 
using the `analyzeBiosensorData` function. Then, the data from each experiment
is combined to generate a calibration curve for each target of interest.

### To use `analyzeBiosensorData`:

1. Ensure the you have the necessary libraries installed and up to date.

2. Copy the chip layout file (e.g., "groupNames_XPP.csv") into the directory
containing the raw ring data you wish to analyze.
     Note: This program has the highest chance of success if the directory 
     only contains:  
     1. raw ring data files (e.g., "03.csv", "04.csv", etc.) and
     2. the chip layout file (e.g., "groupNames_XPP.csv")

3. Set the working directory to the directory containing your raw data and chip
layout file. See instructions on setting the working directory
in R [here](https://www.statmethods.net/interface/workspace.html). For example,
if you are using a Windows machine and your ring data is on your `Desktop` 
folder, you could set your working directory by executing the following line 
in the console: 
`setwd("C:/Users/USERNAME/Desktop/CHIPNAME_gaskGASKNAME_DATE")`.

4. Execute the code by running the `analyzeBiosensorData` function. This 
function requires 5 input variable:
    1. **time1** - a number specifying the later time for net shift 
    calculations
    2. **time2** - a number specifying the earlier time for net shift 
    calculations
    3. **filename** - a string with the filename containing the chip layout
    4. **loc** - a string with directory name to save plots and data files
    5. **fsr** - a logical value indicating whether the data contains FSR shifts
    6. **chkRings** -  a logical value indicating if rings should be removed
    7. **plotData** - a logical value indicating if data should be plotted, 
    which will save a series of png files
    8. **celebrate** - a logical value, set it to TRUE for to be alerted when
    your script has finished
    
    Note: to calculate net shift measurements, the relative shift at *time2 is 
    subtracted from time1* (netshift = time1 - time2).  

Here is an example of code to run: 
```{r}
library(biosensor)
setwd("C:/Users/USERNAME/Desktop/CHIPNAME_gaskGASKNAME_DATE")
#  this will run with code defaults
analyzeBiosensorData()
```

To see an example with data provided as part of this library execute the 
following code:

```{r}
library(biosensor)
dir <- system.file("extdata", "20171112_gaskTestData_MRR", package = "biosensor")
setwd(dir)
analyzeBiosensorData()
```

### To use `calibrationStation`:

1. Set the working directory to a directory containing experiments for your
calibration curve.
    Note: Each experiment should be in its own subdirectory.
2. Load the library and run the `calibrationStation` function. The function
has a single input variable:
    1. **celebrate** - a logical value, set it to TRUE for to be alerted when
    your script has finished

Here is an example of code to run:

```{r}
library(biosensor)
setwd("C:/Users/USERNAME/Desktop/CalibrationData")
calibrationStation(celebrate = TRUE)
```
