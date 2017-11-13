getName <- function(){
        # get the filename from the current working directory
        directory <- basename(getwd())

        # directory naming from MRR: "CHIPNAME_gaskGASK_DATE"
        # extracts and returns GASK from directory name
        name <- unlist(strsplit(directory, split = "_"))[2]

        # define name as global variable for use in other functions
        name <<- gsub('gask','',name) # removes "gask" from name
}
