getNetShifts <- function(data, loc, time1, time2, step = 1, cntl){
        # generate list of rings and empty dataframe to store net shift data
        ringList <- unique(data$Ring)

        # locations for each time is determined using which, min, and abs func
        shiftPoints <- lapply(ringList, function(i){
                ringDat <- dplyr::filter(data, Ring == i)
                time1.loc <- which.min(abs(ringDat$Time - time1))

                time2.loc <- which.min(abs(ringDat$Time - time2))
                if(cntl == "raw"){
                        time1.val <- ringDat$Shift[time1.loc]
                        time2.val <- ringDat$Shift[time2.loc]
                } else {
                        time1.val <- ringDat$Corrected[time1.loc]
                        time2.val <- ringDat$Corrected[time2.loc]
                }
                ring <- i
                group <- unique(ringDat$Group)
                target <- unique(ringDat$Target)
                experiment <- unique(ringDat$Experiment)
                channel <- unique(ringDat$Channel)
                conc <- unique(ringDat$Concentration)
                tmp <- data.frame(i, group, target, time1.val,
                           time2.val, experiment, channel, conc, step)
                tmp$target <- as.character(tmp$target)
                tmp
        })

        # renames shiftPoints columns
        shiftPoints <- dplyr::bind_rows(shiftPoints)
        names(shiftPoints) <- c("Ring", "Group", "Target", "Shift.1", "Shift.2",
                              "Experiment", "Channel", "Concentration", "Step")

        # calculate nat shift and create new column in dataframe
        shiftPoints <- dplyr::mutate(shiftPoints, NetShift = Shift.1 - Shift.2)

        cntl <- unique(data$Cntl)
        ch <- unique(data$Ch)

        # save net shift data
        readr::write_csv(shiftPoints, paste0(loc, "/", name, "_netShifts_", cntl,
                                    "cntl_", "ch", ch, "_step", step, ".csv"))
}
