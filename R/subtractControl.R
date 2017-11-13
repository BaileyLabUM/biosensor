subtractControl <- function(data, loc, ch, cntl){
        # filter data by Channel
        if (ch != "U"){data <- dplyr::filter(data, Channel == ch)}

        data <- dplyr::filter(data, Target != "Ignore")

        # get thermal control averages
        controls <- dplyr::filter(data, Target == cntl)
        controls <- dplyr::group_by(controls, TimePoint)
        controls <- dplyr::summarise_at(controls, "Shift", mean)
        controls <- unlist(dplyr::select(controls, Shift) )
        data$Cntl <- rep(controls, length(unique(data$Ring)))

        # subtracts thermal controls from each ring
        cntlDat <- dplyr::mutate(data, Corrected = Shift - Cntl)

        # remove control column and control rings
        cntlDat <- dplyr::filter(cntlDat, Target != cntl &
                                          Target != "thermal")
        cntlDat$Cntl <- cntl
        cntlDat$Ch <- ch

        # save data to new file
        readr::write_csv(cntlDat,
                         paste(loc,"/", name, "_", cntl, "Control", "_ch",
                                  ch, ".csv", sep = ''))
        return(cntlDat)
}
