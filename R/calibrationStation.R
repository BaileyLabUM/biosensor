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
                               calibrate = FALSE,
                               filename = "groupNames_XPP.csv",
                               loc = "plots",
                               cntl = "thermal",
                               chopRun = 0,
                               fsr = FALSE,
                               chkRings = FALSE,
                               plotData = TRUE,
                               celebrate = FALSE,
                               netShifts = TRUE,
                               uchannel = FALSE,
                               party = TRUE) {
        foldersList <- list.dirs(recursive = FALSE)
        directory <- getwd()
        lapply(foldersList, function(i){
                setwd(i)
                analyzeBiosensorData(time1 = time1, time2 = time2,
                                     getLayoutFile = getLayoutFile,
                                     filename = filename, loc = loc,
                                     cntl = cntl, chopRun = chopRun,
                                     fsr = fsr, chkRings = chkRings,
                                     plotData = plotData, celebrate = celebrate,
                                     netShifts = netShifts, uchannel = uchannel)
                setwd(directory)
        })

        if(calibrate){
                x <- combineNetShifts()
                plotCombinedNetShifts(data = x)
                fitCalCurves(data = x)
        }
        if (party){shell.exec("https://youtu.be/L_jWHffIx5E?t=34s")}
}
