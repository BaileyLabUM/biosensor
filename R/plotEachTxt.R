## Plot each treatment as Net Shift vs Target
plotEachTxt <- function(data){
        treatmentList <- unique(data$Treatment)

        for (i in treatmentList) {

                rxDat <- dplyr::filter(data, Treatment == i)

                g <- ggplot2::ggplot(rxDat, ggplot2::aes(x = Target,
                                                         y = NormLog))

                fig4 <- g +
                        ggplot2::geom_point(ggplot2::aes(color = Target),
                                            position = "jitter") +
                        ggplot2::facet_grid(CellLine~TimePoint) +
                        ggplot2::ggtitle(paste0("Treatment: ", i)) +
                        ggplot2::labs(y = "Normalized Response", color = "") +
                        ggplot2::theme(axis.text.x =
                                               ggplot2::element_text(angle = 45,
                                                                     hjust = 1))

                fig5 <- g +
                        ggplot2::geom_boxplot(ggplot2::aes(fill = Target)) +
                        ggplot2::facet_grid(CellLine~TimePoint) +
                        ggplot2::ggtitle(paste0("Treatment: ", i)) +
                        ggplot2::labs(y = "Normalized Response", fill = "") +
                        ggplot2::theme(axis.text.x =
                                               ggplot2::element_text(angle = 45,
                                                                     hjust = 1))

                dir.create("Treatment Plots", showWarnings = FALSE)

                ggplot2::ggsave(fig4, filename = paste0("Treatment Plots/",
                                               i, "_point.png"),
                       width = 12, height = 8)

                ggplot2::ggsave(fig5, filename = paste0("Treatment Plots/",
                                               i, "_boxplot.png"),
                       width = 12, height = 8)
        }
}
