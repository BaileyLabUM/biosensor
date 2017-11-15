#' Plot Everything
#'
#' Just run this to run everything
#'
#' @export

plotDataRoutine <- function(){
        # set theme for all plots
        plotTheme <- ggplot2::theme_bw(base_size = 16) +
                ggplot2::theme(panel.grid = ggplot2::element_blank())

        ggplot2::theme_set(plotTheme)

        # change working directory to data location
        setwd("D:/Box Sync/XPP_Data")

        # Load in data to make plots
        x <- compLabelNorm()
        compDat <- x[[1]]

        # Save current wd to return to later and setwd to plots folder
        directory <- getwd()
        setwd("../XPP_Plots/")

        plotFullSet(data = compDat)

        plotEachTxt(data = compDat)

        plotEachTar(data = compDat)

        control <- "DMSO"
        txtList <- unique(compDat$Treatment)
        compTargets <- c("pAktSer473", "pS6Ser235/6", "pS6Ser240/4",
                         "pp70S6KThr389", "pRbSer780", "pRbSer807/11")

        lapply(txtList, function(i){
                plotTxt(data = compDat, control = control, treatment = i,
                              targets = compTargets, cellLine = "GBM6")
                plotTxt(data = compDat, control = control, treatment = i,
                              targets = compTargets, cellLine = "GBM26")
        })

        # Pairwise treatment list
        txtPairs <- combn(unique(compDat$Treatment), 2, simplify = FALSE)

        # Run through pair-wise list to plot treatment comparisons
        lapply(txtPairs, function(i){
                txtComp(data = compDat, treatments = as.vector(i),
                              targets = compTargets, cellLine = "GBM6")
                txtComp(data = compDat, treatments = as.vector(i),
                              targets = compTargets, cellLine = "GBM26")
        })

        cytometry(data = compDat)

        setwd(directory)
}
