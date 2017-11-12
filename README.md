# BaileyLabMRRs
***
## Introduction

The purpose of this program is to process with the raw data from the
Maverick M1 detection system (Genalyte, Inc., San Diego, CA) and output simple
line graphs, bar charts, and box plots. The functions also generate companion
csv files containning processed the prcoessed data for subsequent analysis.
The folder containing output from the M1 typically consists of:

1. a csv file for each ring and
2. a comments file the describes the experimental run

The comments file is not needed for this program. In addition to the csv files
for each ring, a separate file containing the chip layout is required. An
example of a chip layout file is provided in the "BaileyLabMRRs" repository
located at https://github.com/BaileyLabUM/BaileyLabMRRs. See
"groupNames_allClusters.csv" for an example.

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
install.packages("devtools")
library(devtools)
install_github("BaileyLabUM/biosensor")
```

***

## Library Instructions

### To use the program:

1. Ensure the you have the necessary libraries installed. See note above for 
instructions on installing libraries.

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

4. Execute the code by running the analyzeMRRData function. This function 
requires 5 input variable:
    1. _time1_ - a number specifying the later time for net shift calculations
    2. _time2_ - a number specifying the earlier time for net shift calculations
    3. _filename_ - a string with the filename containing the chip layout
    4. _loc_ - a string with directory name to save plots and data files
    5. _fsr_ - a logical value indicating whether the data contains FSR shifts
    6. _chkRings_ -  a logical value indicating if rings should be removed
    7. _plotData_ - a logical value indicating if data should be plotted, which
    will save a series of png files
    8. _celebrate_ a logical value, set it to TRUE for to be alerted when your
    script has finished
    Note: to calculate net shift measurements, the relative shift at *time2 is 
    subtracted from time1* (netshift = time1 - time2).  

Here is an example of code to run: 
```{r}
setwd("C:/Users/USERNAME/Desktop/CHIPNAME_gaskGASKNAME_DATE")
analyzeData(filename = "groupNames_XPP.csv",
            time1 = 51,
            time2 = 39,
            loc = "plots",
            fsr = FALSE, 
            chkRings = FALSE,
            plotData = TRUE,
            celebrate = TRUE)
```

To see an example with data provided as part of this library execute the 
following code:

```{r}
dir <- system.file("extdata", "20171112_gaskTestData_MRR", package = "biosensor")
setwd(dir)
analyzeMRRData(time1 = 51, time2 = 39,
               filename = "groupNames_XPP.csv",
               loc = "plots", fsr = FALSE,
               chkRings = FALSE, plotData = FALSE, celebrate = FALSE)
analyzeMRRData(time1 = 51, time2 = 39,
               filename = "groupNames_XPP.csv",
               loc = "plots", fsr = TRUE,
               chkRings = TRUE, plotData = TRUE,
               celebrate = FALSE)
```
