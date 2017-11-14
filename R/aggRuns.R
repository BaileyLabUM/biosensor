#' Aggregate Runs
#'
#' This funciton aggregates data from a series of runs/exeriments into single
#' data frame. Set the working directory to a folder containing the the runs
#' you wish to compile. The function searches for any files with 'net' in the
#' name, and compiles the 'NetShift' values.
#'

aggRuns <- function(){
        # generate list of runs and empty data frame
        filesList <- list.files(recursive = TRUE, pattern = ".csv")
        netList <- filesList[grepl("net", filesList)]

        # iterates through each directory (i.e., run)
        df <- lapply(netList, function(i){
                names <- strsplit(basename(i), split = "_")[[1]][1]
                dat <- read.csv(i)
                dat$Run <- names # adds run name to data frame
                dat$Experiment <- as.character(dat$Experiment)
                dat
        })
        df <- dplyr::bind_rows(df)

        # saves data
        readr::write_csv(df, 'compiledData.csv')
        return(df)
}
