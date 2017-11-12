getNetShifts <- function(cntl, ch, loc, time1, time2, step = 1){
        # use thermally controlled data if desired
        if (cntl != "raw"){
                dat <- readr::read_csv(paste0(loc, "/", name, "_", cntl,
                                              "Control", "_ch", ch, ".csv"))
        } else {
                dat <- readr::read_csv(paste0(loc, "/", name, "_",
                                              "allRings.csv"))
        }

        # generate list of rings and empty dataframe to store net shift data
        ringList <- unique(dat$Ring)

        # locations for each time is determined using which, min, and abs func
        dat.rings <- lapply(ringList, function(i){
                dat.ring <- dplyr::filter(dat, Ring == i)
                time1.loc <- which.min(abs(dat.ring$Time - time1))
                time1.val <- dat.ring$Shift[time1.loc]
                time2.loc <- which.min(abs(dat.ring$Time - time2))
                time2.val <- dat.ring$Shift[time2.loc]
                ring <- i
                group <- unique(dat.ring$Group)
                target <- unique(dat.ring$Target)
                experiment <- unique(dat.ring$Experiment)
                channel <- unique(dat.ring$Channel)
                data.frame(i, group, target, time1.val,
                           time2.val, experiment, channel, step)
        })

        # renames dat.rings columns
        dat.rings <- dplyr::bind_rows(dat.rings)
        names(dat.rings) <- c("Ring", "Group", "Target", "Shift.1", "Shift.2",
                              "Experiment", "Channel", "Step")

        # calculate nat shift and create new column in dataframe
        dat.rings <- dat.rings %>%
                dplyr::mutate(NetShift = Shift.1 - Shift.2)

        # save net shift data
        readr::write_csv(dat.rings, paste0(loc, "/", name, "_netShifts_", cntl,
                                    "cntl_", "ch", ch, "_step", step, ".csv"))
}
