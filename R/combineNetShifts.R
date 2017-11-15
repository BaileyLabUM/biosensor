combineNetShifts <- function(){
        netList <- grep('net',
                        list.files(pattern = '.csv', recursive = TRUE),
                        value = TRUE)

        netShifts <- lapply(netList, function(i){
                netShift <- read.csv(i)
                # convert Target and Experiment to character type to avoid
                # warnings when using bind_rows function below
                netShift$Target <- as.character(netShift$Target)
                netShift$Experiment <- as.character(netShift$Experiment)
                netShift
        })

        `%>%` <- magrittr::`%>%`

        netComb <- netShifts %>% dplyr::bind_rows(netShifts) %>%
                dplyr::filter(netComb,
                              !grepl("thermal|Ignore|Control", Target))

        netCombAvg <- netComb %>%
                dplyr::group_by(netComb, Target, Concentration) %>%
                dplyr::summarise_at(dplyr::vars(NetShift),
                                    dplyr::funs(mean, sd = stats::sd))

        readr::write_csv(netComb, path = "combinedNetShifts.csv")
        readr::write_csv(netCombAvg, path = "combinedNetShifts_Avg.csv")
        return(netComb)
}

