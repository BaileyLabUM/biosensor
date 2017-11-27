multiNetShift <- function(netFile, data, cntl, loc, name){
        netShiftDat <- read.csv(netFile)
        for(i in seq_len(nrow(netShiftDat))){
                time1 <- netShiftDat[i, 2]
                time2 <- netShiftDat[i, 3]
                step <- netShiftDat[i, 4]
                netDat_chU <- getNetShifts(data = data,
                                           time1 = time1,
                                           time2 = time2,
                                           step = step,
                                           loc = loc,
                                           cntl = cntl,
                                           name = name)

                plotNetShifts(data = netDat_chU,
                              step = step,
                              loc = loc,
                              name = name)
        }
}
