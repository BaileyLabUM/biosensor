## Plot Treatments
plotTxt <- function(data, control, treatment, targets, cellLine){
        cntlDat <- dplyr::filter(data, Treatment == control & TimePoint == "1h")
        allDat <- rbind(dplyr::filter(data, Treatment == treatment), cntlDat)
        allDat$Treatment <- factor(allDat$Treatment,
                                   levels = c("DMSO", "(-)-Serum",
                                              "Apitolisib", "Erlotinib",
                                              "Palbociclib", "GNE-317",
                                              "(+)-Serum"))

        # Plot all treatments for treatment
        gAll <- ggplot2::ggplot(allDat,
                                ggplot2::aes(x = interaction(TimePoint,
                                                             Treatment,
                                                             Target),
                                             y = NormLog,
                                             fill = Target)) +
                ggplot2::geom_boxplot() +
                ggplot2::facet_grid(CellLine~.) +
                ggplot2::labs(fill = "",
                     x = "Treatment Time",
                     y = "Normalized Response") +
                ggplot2::scale_x_discrete(labels = rep(c("0 h", "1 h", "24 h"),
                                        length(unique(allDat$Target)))) +
                ggplot2::ggtitle(paste0("Treatment: ", treatment)) +
                ggplot2::theme(axis.text.x =
                                       ggplot2::element_text(angle = 90,
                                                             hjust = 1,
                                                             vjust = 0.5))

        ggplot2::ggsave(gAll,
                        filename = paste0("Treatment Plots/",
                                          treatment, ".png"),
                        width = 12, height = 8)

        # Plot select treatments for treatment
        rxDat <- dplyr::filter(allDat, Target %in% targets &
                                CellLine == cellLine)

        txt <- ggplot2::ggplot(rxDat,
                               ggplot2::aes(x = interaction(TimePoint,
                                                            Treatment,
                                                            Target,
                                                            CellLine),
                                            y = NormLog,
                                            fill = Target)) +
                ggplot2::geom_boxplot() +
                ggplot2::labs(fill = "",
                              x = "Treatment Time",
                              y = "Normalized Response") +
                ggplot2::scale_x_discrete(labels = rep(c("0 h", "1 h", "24 h"),
                                                       length(targets))) +
                ggplot2::ggtitle(paste("Treatment:", treatment, cellLine)) +
                ggplot2::theme(axis.text.x =
                                       ggplot2::element_text(angle = 90,
                                                             hjust = 1,
                                                             vjust = 0.5))

        ggplot2::ggsave(txt,
               filename = paste0("Treatment Plots/", treatment, "_",
                                 cellLine, ".png"),
               width = 8, height = 6)
}
