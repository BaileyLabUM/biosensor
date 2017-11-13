#' Process M1 Raw Data
#'
#' The purpose of this program is to process with the raw data from the
#' Maverick M1 detection system (Genalyte, Inc., San Diego, CA) and output
#' simple line graphs, bar charts, and box plots. The functions also generate
#' companion csv files containning processed the prcoessed data for subsequent
#' analysis. The folder containing output from the M1 typically consists of:
#'    1. a csv file for each ring and
#'    2. a comments file the describes the experimental run
#' The comments file is not needed for this program. In addition to the csv
#' files for each ring, a separate file containing the chip layout is required.
#' An example of a chip layout file is provided in the "BaileyLabMRRs"
#' repository located at https://github.com/BaileyLabUM/BaileyLabMRRs. See the
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
#' dir <- system.file("extdata", "20171112_gaskTestData_MRR",
#'                    package = "biosensor")
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
        aggDat <- aggData(filename = filename, loc = loc, fsr = fsr)
        subDat_ch1 <- subtractControl(data = aggDat,
                                      ch = 1,
                                      cntl = "thermal",
                                      loc = loc)
        subDat_ch2 <- subtractControl(data = aggDat,
                                      ch = 2,
                                      cntl = "thermal",
                                      loc = loc)
        subDat_chU <- subtractControl(data = aggDat,
                                      ch = "U",
                                      cntl = "thermal",
                                      loc = loc)

        netDat_ch1 <- getNetShifts(data = subDat_ch1,
                                   time1 = time1,
                                   time2 = time2,
                                   step = 1,
                                   loc = loc)
        netDat_ch2 <- getNetShifts(data = subDat_ch2,
                                   time1 = time1,
                                   time2 = time2,
                                   step = 1,
                                   loc = loc)

        if(plotData){
                plotRingData(data = subDat_chU,
                             splitPlot = FALSE,
                             loc = loc,
                             raw = TRUE)
                plotRingData(data = subDat_chU,
                             splitPlot = TRUE,
                             loc = loc,
                             raw = FALSE)
                plotRingData(data = subDat_ch1,
                             splitPlot = FALSE,
                             loc = loc,
                             raw = FALSE)
                plotRingData(data = subDat_ch2,
                             splitPlot = FALSE,
                             loc = loc,
                             raw = FALSE)
                plotNetShifts(data = netDat_ch1, step = 1, loc = loc)
                plotNetShifts(data = netDat_ch2, step = 1, loc = loc)
        }

        if (chkRings){
                checkRingQuality(data = aggData,
                                 chkTime1 = 20,
                                 chkTime2 = 30,
                                 loc = loc)}

        if (celebrate){shell.exec("https://youtu.be/dQw4w9WgXcQ")}
}
