% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggData.R
\name{aggData}
\alias{aggData}
\title{Aggregate M1 Data Files}
\usage{
aggData(loc = "plots", getLayoutFile = FALSE,
  filename = "groupNames_allClusters.csv", fsr = FALSE, fsrThresh = 3000,
  name)
}
\arguments{
\item{loc}{a string with directory name to save plots and data files}

\item{getLayoutFile}{a logical value indicating if the chip layout file
should be downloaded from Github}

\item{filename}{a string with the filename containing the chip layout}

\item{fsr}{a logical value indicating whether the data contains FSR shifts}

\item{fsrThresh}{a numerical value specifying the minimum difference
between two time points to be considered an FSF shift}

\item{name}{a string for naming files}
}
\value{
The function outputs a single csv file in the `loc` directory and is
named "NAME_allRings.csv", where NAME is defined using the main directory
name. If the main directory has is names "20171112_gaskTestData_MRR",
then the output file will be named "TestData_allRings.csv".
}
\description{
The purpose of this function is to aggregate all the individual ring files
into a single csv file. The function requires a chip layout file that
specifies the identity of each ring sensor.
}
