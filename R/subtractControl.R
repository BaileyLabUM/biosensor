subtractControl <- function(loc, ch, cntl){
        # get ring data and filter by channel
        dat <- readr::read_csv(paste0(loc, "/", name, "_", "allRings.csv"))
        if (ch != "U"){dat <- dplyr::filter(dat, Channel == ch)}
        dat <- dplyr::filter(dat, Target != "Ignore")

        # get thermal control averages
        controls <- dplyr::filter(dat, Target == cntl)
        controls <- dplyr::group_by(controls, `Time Point`)
        controls <- dplyr::summarise_at(controls, "Shift", mean)
        controls <- unlist(dplyr::select(controls, Shift) )
        dat$Cntl <- rep(controls, length(unique(dat$Ring)))

        # subtracts thermal controls from each ring
        dat.cntl <- dplyr::mutate(dat, Shift = Shift - Cntl)

        # remove control column and control rings
        dat.cntl <- dplyr::filter(dat.cntl, Target != cntl &
                                          Target != "thermal")
        dat.cntl$Cntl <- NULL

        # save data to new file
        readr::write_csv(dat.cntl, paste(loc,"/", name, "_", cntl, "Control", "_ch",
                                  ch, ".csv", sep = ''))
}
