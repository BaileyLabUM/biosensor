#' Aggregate M1 Data Files
#'
#' The purpose of this function is to aggregate all the individual ring files
#' into a single csv file. The function requires a chip layout file that
#' specifies the identity of each ring sensor.
#'
#' @param fsrThresh a numerical value specifying the minimum difference
#' between two time points to be considered an FSF shift
#' @param name a string for naming files
#' @inheritParams analyzeBiosensorData
#'
#' @return The function outputs a single csv file in the `loc` directory and is
#' named "NAME_allRings.csv", where NAME is defined using the main directory
#' name. If the main directory has is names "20171112_gaskTestData_MRR",
#' then the output file will be named "TestData_allRings.csv".

aggData <- function(loc = "plots", getLayoutFile = FALSE,
                    filename = "groupNames_allClusters.csv",
                    fsr = FALSE, fsrThresh = 3000, name) {

        # get information of chip layout from github repository
        if (getLayoutFile){
                git <- "https://raw.githubusercontent.com/"
                hub <- "JamesHWade/XenograftProteinProfiling/master/"
                github <- paste0(git, hub)
                url <- paste0(github, filename)
                filename <- basename(url)
                utils::download.file(url, filename)
        } else { filename <- grep("groupNames",
                                  list.files(pattern = ".csv"),
                                  value = TRUE) }

        # read in recipe/chip layout
        recipe <- read.csv(filename)

        # generate list of rings to analyze (gets all *.csv files)
        rings <- list.files(pattern = "[[:digit:]].csv",
                            recursive = FALSE)

        # add data to data frame corresponding for each ring in rings
        df <- lapply(rings, function(i){
                dat <- read.csv(i, header = FALSE)
                ringNum <- as.numeric(strsplit(i, "\\.")[[1]][1])
                recipeCol <- which(recipe$Ring == ringNum)
                tmp <- dat[,c(1,2)] # time and shift from raw data
                tmp$ring <- ringNum
                tmp$group <- recipe$Group[recipeCol]
		tmp$conc <- recipe$Concentration[recipeCol]
                tmp$groupName <- as.character(recipe$Target[[recipeCol]])
                tmp$channel <- recipe$Channel[[recipeCol]]
                tmp$run <- name
                tmp$timePoint <- seq(1:nrow(dat))
                tmp
        })

        # correct for fsr
        if(fsr){
                for(i in seq_len(length(df))){
                        pointShift <- 0
                        for(j in seq_len(nrow(df[[i]]))){
                                shiftDiff <- pointShift - df[[i]][j, 2]
                                if(shiftDiff > fsrThresh){
                                        df[[i]][j, 2] <- df[[i]][j, 2] + 5980
                                }
                                pointShift <- df[[i]][j, 2]
                        }
                }
        }

        # combine data from list into single data frame
        df <- dplyr::bind_rows(df)

        # renames columns in df
         names(df) <- c("Time", "Shift", "Ring", "Group", "Concentration",
                       "Target", "Channel", "Experiment", "TimePoint")

        # creates "plots" directory
        dir.create(loc, showWarnings = FALSE)

        # saves aggregated data with name_allRings.csv
        readr::write_csv(df, paste0(loc, '/', name, "_allRings.csv"))

        return(df)
}
