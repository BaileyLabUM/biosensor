## Plot Treatments
plotTxt <- function(data, control, treatment, targets, cellLine){
        cntlDat <- filter(data, Treatment == control & TimePoint == "1h")
        allDat <- rbind(filter(data, Treatment == treatment), cntlDat)
        allDat$Treatment <- factor(allDat$Treatment,
                                   levels = c("DMSO", "(-)-Serum",
                                              "Apitolisib", "Erlotinib",
                                              "Palbociclib", "GNE-317",
                                              "(+)-Serum"))

        # Plot all treatments for treatment
        gAll <- ggplot(allDat,
                       aes(x = interaction(TimePoint, Treatment, Target),
                           y = NormLog,
                           fill = Target)) +
                geom_boxplot() +
                facet_grid(CellLine~.) +
                labs(fill = "",
                     x = "Treatment Time",
                     y = "Normalized Response") +
                scale_x_discrete(labels = rep(c("0 h", "1 h", "24 h"),
                                              length(unique(allDat$Target)))) +
                ggtitle(paste0("Treatment: ", treatment)) +
                theme(axis.text.x =
                              element_text(angle = 90, hjust = 1, vjust = 0.5))

        ggsave(gAll,
               filename = paste0("Treatment Plots/", treatment, ".png"),
               width = 12, height = 8)

        # Plot select treatments for treatment
        rxDat <- filter(allDat, Target %in% targets &
                                CellLine == cellLine)

        txt <- ggplot(rxDat,
                      aes(x = interaction(TimePoint, Treatment,
                                          Target, CellLine),
                          y = NormLog,
                          fill = Target)) +
                geom_boxplot() +
                labs(fill = "",
                     x = "Treatment Time",
                     y = "Normalized Response") +
                scale_x_discrete(labels = rep(c("0 h", "1 h", "24 h"),
                                              length(targets))) +
                ggtitle(paste("Treatment:", treatment, cellLine)) +
                theme(axis.text.x =
                              element_text(angle = 90, hjust = 1, vjust = 0.5))

        ggsave(txt,
               filename = paste0("Treatment Plots/", treatment, "_",
                                 cellLine, ".png"),
               width = 8, height = 6)
}
