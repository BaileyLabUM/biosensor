aggData <- function(loc, filename, fsr, fsrThresh = 3000) {
        # get information of chip layout from github repository
        if (!file.exists(filename)){
                git <- "https://raw.githubusercontent.com/"
                hub <- "JamesHWade/XenograftProteinProfiling/master/"
                github <- paste0(git, hub)
                url <- paste0(github, filename)
                filename <- basename(url)
                utils::download.file(url, filename)
        }

        # read in recipe/chip layout
        recipe <- readr::read_csv(filename)
        colnames(recipe)[1] <- "Target" # rename col & remove byte order mark
        targets <- recipe$Target

        # generate list of rings to analyze (gets all *.csv files)
        rings <- list.files(pattern = "[[:digit:]].csv",
                            recursive = FALSE)

        # add data to data frame corresponding for each ring in rings
        df <- lapply(rings, function(i){
                dat <- readr::read_csv(i, col_names = FALSE)
                ringNum <- as.numeric(strsplit(i, "\\.")[[1]][1])
                recipeCol <- which(recipe$Ring == ringNum)
                tmp <- dat[,c(1,2)] # time and shift from raw data
                tmp$ring <- ringNum
                tmp$group <- recipe$Group[recipeCol]
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
                                        print("fuck, an fsr---kill it---got it")
                                        df[[i]][j, 2] <- df[[i]][j, 2] + 5980
                                }
                                pointShift <- df[[i]][j, 2]
                        }
                }
        }

        # combine data from list into single data frame
        df <- dplyr::bind_rows(df)

        # renames columns in df
        names(df) <- c("Time", "Shift", "Ring", "Group", "Target", "Channel",
                       "Experiment", "Time Point")

        # creates "plots" directory
        dir.create(loc, showWarnings = FALSE)

        # saves aggregated data with name_allRings.csv
        readr::write_csv(df, paste0(loc, '/', name, "_allRings.csv"))
}
