#' Calibration Station
#'
#' Analyze series of runs on M1 and generate calibration curves for each target
#'
#' @inheritParams analyzeBiosensorData
#' @param party a logical value that alerts you when your runs is done when TRUE
#' @param calibrate a logical value indicating if data shoudl be fit to logistic
#' function as calibration curve
#'
#' @export
calibrationStation <- function(time1 = 51,
                               time2 = 39,
                               getLayoutFile = FALSE,
                               calibrate = TRUE,
                               filename = "groupNames_XPP.csv",
                               loc = "plots",
                               cntl = "thermal",
                               chopRun = 0,
                               fsr = TRUE,
                               chkRings = FALSE,
                               plotData = TRUE,
                               celebrate = FALSE,
                               netShifts = TRUE,
                               uchannel = FALSE,
                               party = TRUE,
                               name = "Calibration",
                               indyRuns = TRUE) {

        # set theme for all plots
        ggplot2::theme_set(ggplot2::theme_classic(base_size = 16))

        foldersList <- list.dirs(recursive = FALSE)
        directory <- getwd()
        if(indyRuns){
        lapply(foldersList, function(i){
                        setwd(i)
                        analyzeBiosensorData(time1 = time1, time2 = time2,
                                             getLayoutFile = getLayoutFile,
                                             filename = filename, loc = loc,
                                             cntl = cntl, chopRun = chopRun,
                                             fsr = fsr, chkRings = chkRings,
                                             plotData = plotData,
                                             celebrate = celebrate,
                                             netShifts = netShifts,
                                             uchannel = uchannel)
                        setwd(directory)
                })
        }

        if(calibrate){
                x <- combineNetShifts()
                plotCombinedNetShifts(data = x, name = name)
                fitCalCurves(data = x)
        }
        if (party){shell.exec("https://youtu.be/L_jWHffIx5E?t=34s")}
}
