## Plot all data combined
plotFullSet <- function(data){
        g <- ggplot2::ggplot(data, ggplot2::aes(x = Target, y = NormLog))

        allPoint <- g +
                ggplot2::geom_point(ggplot2::aes(color = factor(TimePoint)),
                           position = "jitter", alpha = 0.7) +
                ggplot2::facet_grid(Treatment ~ CellLine) +
                ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                                   hjust = 1),
                               legend.position = "bottom") +
                ggplot2::labs(y = "Normalized Response", color = "Time Point")

        ggplot2::ggsave(allPoint, filename = "everything_point.png",
               width = 20, height = 12)

        allBoxplot <- g +
                ggplot2::geom_boxplot(ggplot2::aes(fill = Treatment)) +
                ggplot2::facet_grid(CellLine~TimePoint) +
                ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                                   hjust = 1),
                               legend.position = "bottom") +
                ggplot2::labs(y = "Normalized Response")

        ggplot2::ggsave(allBoxplot, filename = "everything_boxplot.png",
                        width = 20, height = 12)

        allTarget <- ggplot2::ggplot(data, ggplot2::aes(x = Treatment,
                                                        y = NormLog)) +
                ggplot2::geom_boxplot(ggplot2::aes(fill = interaction(TimePoint,
                                                        CellLine))) +
                ggplot2::facet_wrap(~Target) +
                ggplot2::labs(y = "Normalized Response", fill = "") +
                ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                                   hjust = 1),
                               legend.position = "bottom")

        ggplot2::ggsave(allTarget, filename = "everything_targetwrap.png",
                        width = 20, height = 12)
}
