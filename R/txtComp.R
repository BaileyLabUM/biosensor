## Pairwise treatment comparisons
txtComp <- function(data, treatments, targets, cellLine){
        rxDat <- dplyr::filter(data, Treatment == treatments &
                                       Target %in% targets &
                                       CellLine == cellLine)
        g <- ggplot2::ggplot(rxDat, ggplot2::aes(x = Target,
                                                 group = interaction(Treatment,
                                                                     TimePoint,
                                                                     Target),
                                                 y = NormLog))

        figComp <- g +
                ggplot2::geom_boxplot(ggplot2::aes(fill = interaction(Treatment,
                                                                TimePoint))) +
                ggplot2::labs(fill = "",
                              x = "Target",
                              y = "Normalized Response") +
                ggplot2::ggtitle(paste0(treatments[1], " vs ",
                                        treatments[2])) +
                ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                                   hjust = 1))

        figComp2 <- g +
                ggplot2::geom_boxplot(ggplot2::aes(fill = Treatment)) +
                ggplot2::facet_wrap(~TimePoint) +
                ggplot2::labs(fill = "",
                              x = "Target",
                              y = "Normalized Response") +
                ggplot2::ggtitle(paste0(treatments[1], " vs ", treatments[2])) +
                ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                                   hjust = 1))

        dir.create(path = "Treatment Comparisons", showWarnings = FALSE)

        ggplot2::ggsave(figComp,
                        filename = paste0("Treatment Comparisons/",
                                          treatments[1], "_",
                                          treatments[2], "_",
                                          cellLine, ".png"),
                        width = 8, height = 6)
        ggplot2::ggsave(figComp2,
                        filename = paste0("Treatment Comparisons/",
                                          treatments[1], "_",
                                          treatments[2], "_",
                                          cellLine, "_2.png"),
                        width = 8, height = 6)
}
