## Plot each target as Net Shift vs Treatment
plotEachTar <- function(data){
        targetList <- unique(data$Target)

        for(i in targetList) {

                tarDat <- dplyr::filter(data,
                                          Target == i &
                                          Treatment != "(+)-Serum" &
                                          Treatment != "(-)-Serum")

                g <- ggplot2::ggplot(tarDat, ggplot2::aes(x = Treatment,
                                                          y = NormLog))

                plotName <- unlist(strsplit(i, "/"))[1]

                targetPoint <- g +
                        ggplot2::geom_point(ggplot2::aes(color = TimePoint),
                                   position = "jitter") +
                        ggplot2::facet_grid(CellLine~.) +
                        ggplot2::ggtitle(paste0("Target: ", i)) +
                        ggplot2::labs(y = "Normalized Response", color = "") +
                        ggplot2::theme(axis.text.x =
                                               ggplot2::element_text(angle = 45,
                                                                     hjust = 1))

                targetBox <- g +
                        ggplot2::geom_boxplot(ggplot2::aes(fill = TimePoint)) +
                        ggplot2::facet_grid(CellLine~.) +
                        ggplot2::ggtitle(paste0("Target: ", i)) +
                        ggplot2::labs(y = "Normalized Response", fill = "") +
                        ggplot2::theme(axis.text.x =
                                               ggplot2::element_text(angle = 45,
                                                                     hjust = 1))

                targetBox2 <- g +
                        ggplot2::geom_boxplot(ggplot2::aes(fill =
                                                interaction(TimePoint,
                                                            CellLine))) +
                        ggplot2::ggtitle(paste0("Target: ", i)) +
                        ggplot2::labs(y = "Normalized Response", fill = "") +
                        ggplot2::theme(axis.text.x =
                                               ggplot2::element_text(angle = 45,
                                                                     hjust = 1))

                dir.create("Target Plots", showWarnings = FALSE)

                ggplot2::ggsave(targetPoint,
                                filename = paste0("Target Plots/",
                                         plotName, "_point.png"),
                                width = 8, height = 6)
                ggplot2::ggsave(targetBox,
                                filename = paste0("Target Plots/",
                                                  plotName, "_boxplot.png"),
                       width = 8, height = 6)
                ggplot2::ggsave(targetBox2,
                                filename = paste0("Target Plots/",
                                                  plotName, "_boxplot_2.png"),
                                width = 8, height = 6)
        }
}
