#' Chop Up Run
#'
#' Cuts off all data before the time defines by $startRun variable. The the
#' response variables $Shift and $Time are set to zero at the $startRun point.
#'
#' @inheritParams analyzeBiosensorData
#' @param data a dataframe containing at least two columns; the 1st is Time &
#' the second is Shift (signal from M1 Maverick Detection System)
#'
#' @return Returns a data frame of the chopped up data, and it saves a csv file
#' of this data.

chopUpRun <- function(data, startRun, loc){
        startLoc <- which(abs(data$Time - startRun) ==
                                  min(abs(data$Time - startRun)))
        startTP <- data$TimePoint[startLoc]
        subDat <- subset(data, TimePoint > startTP)
        subDat <- dplyr::group_by(subDat, Ring)
        subDat <- dplyr::mutate(subDat,
                         Shift = Shift - Shift[1],
                         Time = Time -Time[1])
        readr::write_csv(subDat,
                         path = paste0(loc, "/", name, "_allRings_chopped.csv"))
        return(subDat)
}
