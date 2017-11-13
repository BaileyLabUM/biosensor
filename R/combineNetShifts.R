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
        
        netComb <- dplyr::bind_rows(netShifts)
        netComb <- dplyr::filter(netComb, 
                                 !grepl("thermal|Ignore|Control", Target))
        
        netCombAvg <- dplyr::group_by(netComb, Target, Concentration)
        netCombAvg <- dplyr::summarise_at(netCombAvg, 
                                          dplyr::vars(NetShift),
                                          dplyr::funs(mean, stats::sd))

        readr::write_csv(netComb, path = "combinedNetShifts.csv")
        readr::write_csv(netCombAvg, path = "combinedNetShifts_Avg.csv")
        return(netComb)
}

