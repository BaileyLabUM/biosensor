#' Chop Up Run
#'
#' Cuts off all data before the time defines by $startRun variable. The the
#' response variables $Shift and $Time are set to zero at the $startRun point.
#'
#' @inheritParams analyzeBiosensorData
#' @param data a dataframe containing at least two columns; the 1st is Time &
#' the second is Shift (signal from M1 Maverick Detection System)
#' @param startRun the numerical value on where to start the run, only used if
#' chopRun is TRUE
#' @param name a string for naming files
#'
#' @return Returns a data frame of the chopped up data, and it saves a csv file
#' of this data.

chopUpRun <- function(data, startRun, loc, name){
        startLoc <- which(abs(data$Time - startRun) ==
                                  min(abs(data$Time - startRun)))
        startTP <- data$TimePoint[startLoc]

        `%>%` <- magrittr::`%>%`

        subDat <- data %>%
                subset(data, TimePoint > startTP) %>%
                dplyr::group_by(Ring) %>%
                dplyr::mutate(Shift = Shift - Shift[1],
                              Time = Time -Time[1])

         readr::write_csv(subDat,
                         path = paste0(loc, "/", name, "_allRings_chopped.csv"))
        return(subDat)
}
