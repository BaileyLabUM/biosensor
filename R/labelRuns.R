#' Label Runs
#'
#' Annotate aggregated net shift data with run information
#'
#' @param runsFile a string with the filename of the runs file that contains the
#' experimental information for each run
#' @param data a dataframe containing compiled experimental data generated from
#' the `aggRuns` function

labelRuns <- function(data, runsFile = 'runs.csv'){
        # gets run information, this file was manually created
        runInfo <- read.csv(runsFile)

        # generates list of treatments and removes NA data and blank runs
        treatments <- unique(runInfo$Treatment, na.rm = TRUE)
        remove <- c(NA, 'NA', 'Blank')
        treatments <- treatments[!treatments %in% remove]

        # iterates through each row in compiled data
        # assigns to data to by channel
        df <- apply(data, 1, function(i){
                a <- dplyr::filter(runInfo, Runs == i[6] & Channel == i[7])
        })

        df <- dplyr::bind_rows(df)
        df$Channel <- NULL # remove redundant column
        df <- cbind(data, df)

        # remove any NAs, Blank runs, and thermal rings
        df <- df[complete.cases(df),]
        df <- dplyr::filter(df, Treatment != "Blank" & Target != "thermal")

        # remove reduntant columns
        labelledRuns <- dplyr::select(df, Ring, Group, Target, Experiment,
                                      Channel, NetShift, Treatment, CellLine,
                                      TimePoint, Replicate)

        # saves data
        readr::write_csv(labelledRuns, "compiledLabeled.csv")

        # returns data frame of compiled, labelled data
        return(labelledRuns)
}
