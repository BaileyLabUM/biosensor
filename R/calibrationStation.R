#' Calibration Station
#'
#' Analyze series of runs on M1 and generate calibration curves for each target
#'
#' @inheritParams analyzeBiosensorData
#'
#' @export
calibrationStation <- function(time1 = 51,
                               time2 = 39,
                               getLayoutFile = FALSE,
                               filename = "groupNames_XPP.csv",
                               loc = "plots",
                               cntl = "thermal",
                               chopRun = 0,
                               fsr = FALSE,
                               chkRings = FALSE,
                               plotData = TRUE,
                               celebrate = FALSE,
                               netShifts = TRUE,
                               party = TRUE) {
        foldersList <- list.dirs(recursive = FALSE)
        directory <- getwd()
        lapply(foldersList, function(i){
                setwd(i)
                analyzeBiosensorData()
                setwd(directory)
        })
        x <- combineNetShifts()
        plotCombinedNetShifts(data = x)
        fitCalCurves(data = x)
        if (party){shell.exec("https://youtu.be/L_jWHffIx5E?t=34s")}
}
