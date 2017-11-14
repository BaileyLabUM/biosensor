normLabelRuns <- function(data){

        dat <- dplyr::mutate(data,
                             n = Ring %% 4,
                             LogTransformed = log(NetShift))

        datScaled <- dplyr::group_by(dat, Target)
        datScaled <- dplyr::mutate(datScaled,
                                   NormLog = scale(LogTransformed),
                                   Normalized = scale(NetShift))

        cv <- function(x){sd(x)/mean(x) * 100}

        datSum <- dplyr::group_by(datScaled, Target, CellLine,
                                  Treatment, TimePoint)
        datSum <- dplyr::summarize_at(datScaled,
                                      dplyr::vars("NetShift", "Normalized",
                                                  "NormLog", "LogTransformed"),
                                      dplyr::funs(mean, sd, cv, length))

        readr::write_csv(datScaled, "compiledNormalized.csv")
        readr::write_csv(datSum, "compiledSummed.csv")

        datList <- list()
        datList[["scaled"]] <- datScaled
        datList[["summarized"]] <- datSum

        return(datList)
}
