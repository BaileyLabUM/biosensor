allCalMRRData <- function() {
        foldersList <- list.dirs(recursive = FALSE)
        directory <- getwd()
        lapply(foldersList, function(i){
                setwd(i)
                analyzeCalMRRData()
                setwd(directory)
        })
}
