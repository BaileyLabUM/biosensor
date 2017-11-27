combineMultiShifts <- function(loc, net, name){

        `%>%` <- magrittr::`%>%`

        netList <- grep('net',
                        list.files(pattern = '.csv',
                                   recursive = TRUE),
                        value = TRUE)

        removeFiles <- grep("Combined", netList, value = TRUE)
        netList <- netList[!netList %in% removeFiles]

        netShifts <- lapply(netList, function(i){
                print(i)
                dat <- read.csv(i)
                dat$Target <- as.character(dat$Target)
                dat
        })

        netComb <- dplyr::bind_rows(netShifts)

        netCast <- reshape2::dcast(netComb, Ring + Group + Target + Experiment + Channel ~
                                 Step, value.var = "NetShift",
                                 fun.aggregate = mean)

        netCast <- netCast %>% dplyr::mutate(`25` = `20` + `25`,
                                      `30` = `25` + `30`,
                                      `35` = `30` + `35`,
                                      `40` = `35` + `40`,
                                      `45` = `40` + `45`)

        netMelt <- reshape2::melt(netCast, id.vars = c("Ring", "Group", "Target",
                                             "Experiment", "Channel"),
                        measure.vars = c("20", "25", "30", "35", "40", "45"),
                        variable.name = "Cycle",
                        value.name = "NetShift")

        filename <- paste0(loc, "/", name, "_netShiftsCombined", ".csv")

        readr::write_csv(netMelt, path = filename)
}
