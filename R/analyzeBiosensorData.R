#' Process Raw Biosensor Data
#'
#' The purpose of this program is to process with the raw data from the
#' Maverick M1 detection system (Genalyte, Inc., San Diego, CA) and output
#' simple line graphs, bar charts, and box plots. In principle, this code should
#' also work for any bionsensor data that ouputs Time in column one and Signal
#' in column two. The function call also generates companion csv files
#' containning processed the prcoessed data for subsequent analysis.
#' The folder containing output from the M1 typically consists of:
#'    1. a csv file for each ring and
#'    2. a comments file the describes the experimental run
#' A "comments.csv" file is also exported, but it is not needed.
#' In addition to the csv files for each ring, a separate file containing the
#' chip layout is required. An example of a chip layout file is provided in the
#' "BaileyLabMRRs" repository located at
#' https://github.com/BaileyLabUM/BaileyLabMRRs. See the
#' "groupNames_allClusters.csv" file for an example.
#'
#' @param time1 a number specifying the later time for net shift calculations
#' @param time2 a number specifying the earlier time for net shift calculations
#' @param cntl a string indicating the target to be used for control; the
#' default value is "thermal"; use "raw" if you do not want to use a control
#' @param filename a string with the filename containing the chip layout
#' @param loc a string with directory name to save plots and data files
#' @param fsr a logical value indicating whether the data contains FSR shifts
#' @param chkRings a logical value indicating if rings should be removed
#' @param plotData a logical value indicating if data should be plotted, which
#' will save a series of png files
#' @param celebrate a logical value, set it to TRUE for to be alerted when your
#' script has finished
#' @param netShifts a logical value indicating if net shift values should be
#' calculated and plotted
#' @param getLayoutFile a logical value indicating if the chip layout file
#' should be downloaded from Github
#' @param chopRun the numerical value on where to start the run, and the data
#' will only be "chopped" (subsetted) if `chopRun` > 0
#'
#' @return This function returns csv files containing processed data along with
#' a number of png files containing plots of the processed data.
#'
#' @examples
#' dir <- system.file("extdata", "20171112_gaskTestData_MRR",
#'                    package = "biosensor")
#' setwd(dir)
#' analyzeBiosensorData()
#'
#' @export
#'

analyzeBiosensorData <- function(time1 = 51, time2 = 39,
                        filename = "groupNames_XPP.csv",
                        loc = "plots",
                        cntl = "thermal",
                        chopRun = 0,
                        fsr = FALSE,
                        chkRings = FALSE,
                        plotData = TRUE,
                        celebrate = FALSE,
                        netShifts = TRUE,
                        getLayoutFile = FALSE) {
        name <- getName()
        dat <- aggData(filename = filename, loc = loc, fsr = fsr,
                       getLayoutFile = getLayoutFile, name = name)

        if(chopRun > 0){
                aggDat <- chopUpRun(data = dat,
                                    startRun = chopRun,
                                    loc = loc,
                                    name = name)
        } else {aggDat <- dat}


        channels <- unique(aggDat$Channel)
        if(1 %in% channels){
                subDat_ch1 <- subtractControl(data = aggDat,
                                              ch = 1,
                                              cntl = cntl,
                                              loc = loc,
                                              name = name)
        }
        if(2 %in% channels){
                subDat_ch2 <- subtractControl(data = aggDat,
                                              ch = 2,
                                              cntl = cntl,
                                              loc = loc,
                                              name = name)
        }
        subDat_chU <- subtractControl(data = aggDat,
                                      ch = "U",
                                      cntl = cntl,
                                      loc = loc,
                                      name = name)

        if(plotData){
                if(exists("subDat_chU")){
                        plotRingData(data = subDat_chU,
                                     splitPlot = FALSE,
                                     loc = loc,
                                     raw = TRUE,
                                     name = name)
                        plotRingData(data = subDat_chU,
                                     splitPlot = TRUE,
                                     loc = loc,
                                     raw = FALSE,
                                     name = name)
                }

                if(exists("subDat_ch1")){
                        plotRingData(data = subDat_ch1,
                                     splitPlot = FALSE,
                                     loc = loc,
                                     raw = FALSE,
                                     name = name)
                }

                if(exists("subDat_ch2")){
                        plotRingData(data = subDat_ch2,
                                     splitPlot = FALSE,
                                     loc = loc,
                                     raw = FALSE,
                                     name = name)
                }
        }

        if(netShifts){
                if(exists("subDat_ch1")){
                        netDat_ch1 <- getNetShifts(data = subDat_ch1,
                                                   time1 = time1,
                                                   time2 = time2,
                                                   step = 1,
                                                   loc = loc,
                                                   cntl = cntl,
                                                   name = name)
                        plotNetShifts(data = netDat_ch1,
                                      step = 1,
                                      loc = loc,
                                      name = name)
                }
                if(exists("subDat_ch2")){
                        netDat_ch2 <- getNetShifts(data = subDat_ch2,
                                                   time1 = time1,
                                                   time2 = time2,
                                                   step = 1,
                                                   loc = loc,
                                                   cntl = cntl,
                                                   name = name)
                        plotNetShifts(data = netDat_ch2,
                                      step = 1,
                                      loc = loc,
                                      name = name)
                }
        }

        netDat_chU <- getNetShifts(data = subDat_chU,
                                   time1 = time1,
                                   time2 = time2,
                                   step = 1,
                                   loc = loc,
                                   cntl = cntl,
                                   name = name)
        plotNetShifts(data = netDat_chU,
                      step = 1,
                      loc = loc,
                      name = name)


        if (chkRings){
                checkRingQuality(data = aggData,
                                 chkTime1 = 20,
                                 chkTime2 = 30,
                                 loc = loc,
                                 name = name)}

        if (celebrate){shell.exec("https://youtu.be/dQw4w9WgXcQ")}
}
