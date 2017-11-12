#' Process M1 Raw Data
#'
#' The purpose of this program is to process with the raw data from the
#' Maverick M1 detection system (Genalyte, Inc., San Diego, CA) and output simple
#' line graphs, bar charts, and box plots. The functions also generate companion
#' csv files containning processed the prcoessed data for subsequent analysis.
#' The folder containing output from the M1 typically consists of:
#'    1. a csv file for each ring and
#'    2. a comments file the describes the experimental run
#' The comments file is not needed for this program. In addition to the csv files
#' for each ring, a separate file containing the chip layout is required. An
#' example of a chip layout file is provided in the "BaileyLabMRRs" repository
#' located at https://github.com/BaileyLabUM/BaileyLabMRRs. See the
#' "groupNames_allClusters.csv" file for an example.
#'
#' @param time1 a number specifying the later time for net shift calculations
#' @param time2 a number specifying the earlier time for net shift calculations
#' @param filename a string with the filename containing the chip layout
#' @param loc a string with directory name to save plots and data files
#' @param fsr a logical value indicating whether the data contains FSR shifts
#' @param chkRings a logical value indicating if rings should be removed
#' @param plotData a logical value indicating if data should be plotted, which
#' will save a series of png files
#' @param celebrate a logical value, set it to TRUE for to be alerted when your
#' script has finished
#'
#' @return This function returns csv files containing processed data along with
#' a number of png files containing plots of the processed data.
#'
#' @examples
#' dir <- system.file("extdata", "20171112_gaskTestData_MRR", package = "biosensor")
#' setwd(dir)
#' analyzeMRRData(time1 = 51, time2 = 39,
#'                filename = "groupNames_XPP.csv",
#'                loc = "plots", fsr = FALSE,
#'                chkRings = FALSE, plotData = FALSE, celebrate = FALSE)
#' \donttest{analyzeMRRData(time1 = 51, time2 = 39,
#'                          filename = "groupNames_XPP.csv",
#'                          loc = "plots", fsr = TRUE,
#'                          chkRings = TRUE, plotData = TRUE,
#'                          celebrate = FALSE)}
#'
#' @export
#'

analyzeMRRData <- function(time1 = 51, time2 = 39,
                        filename = "groupNames_XPP.csv",
                        loc = "plots",
                        fsr = FALSE,
                        chkRings = FALSE,
                        plotData = TRUE,
                        celebrate = TRUE) {
        getName()
        aggData(filename = filename, loc = loc, fsr = fsr)
        subtractControl(ch = 1, cntl = "thermal", loc = loc)
        subtractControl(ch = 2, cntl = "thermal", loc = loc)
        subtractControl(ch = "U", cntl = "thermal", loc = loc)

        getNetShifts(cntl = "thermal", ch = 1,
                     time1 = time1, time2 = time2, step = 1, loc = loc)
        getNetShifts(cntl = "thermal", ch = 2,
                     time1 = time1, time2 = time2, step = 1, loc = loc)
        if(plotData){
                plotRingData(cntl = "raw", ch = "U",
                             splitPlot = TRUE, loc = loc)
                plotRingData(cntl = "thermal", ch = "U",
                             splitPlot = TRUE, loc = loc)
                plotRingData(cntl = "thermal", ch = 1,
                             splitPlot = FALSE, loc = loc)
                plotRingData(cntl = "raw", ch = 1,
                             splitPlot = FALSE, loc = loc)
                plotRingData(cntl = "thermal", ch = 2,
                             splitPlot = FALSE, loc = loc)
                plotRingData(cntl = "raw", ch = 2,
                             splitPlot = FALSE, loc = loc)
                plotNetShifts(cntl = "thermal", ch = 1, step = 1, loc = loc)
                plotNetShifts(cntl = "thermal", ch = 2, step = 1, loc = loc)
        }
        if (chkRings){checkRingQuality(time1 = 20, time2 = 30, loc = loc)}
        if (celebrate){shell.exec("https://youtu.be/dQw4w9WgXcQ")}
}
