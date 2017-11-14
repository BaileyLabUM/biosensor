#' Compile, Label, and Normalize Data
#'
#' Runs three functions successively: `aggRuns`, `lableRuns`, & `normLabelRuns`
#'
#' @export

compLabelNorm <- function(){
        x <- aggRuns()
        y <- labelRuns(data = x, runsFile = "runs.csv")
        normLabelRuns(data = y)
}
