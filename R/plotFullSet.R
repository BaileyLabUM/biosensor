## Plot all data combined
plotFullSet <- function(data){
        g <- ggplot(data, aes(x = Target, y = NormLog))

        allPoint <- g +
                geom_point(aes(color = factor(TimePoint)),
                           position = "jitter", alpha = 0.7) +
                facet_grid(Treatment ~ CellLine) +
                theme(axis.text.x = element_text(angle = 45, hjust = 1),
                      legend.position = "bottom") +
                ggtitle("Full Dataset") +
                labs(y = "Normalized Response", color = "Time Point")

        ggsave(allPoint, filename = "everything_point.png",
               width = 20, height = 12)

        allBoxplot <- g +
                geom_boxplot(aes(fill = Treatment)) +
                facet_grid(CellLine~TimePoint) +
                theme(axis.text.x = element_text(angle = 45, hjust = 1),
                      legend.position = "bottom") +
                ggtitle("Full Dataset") +
                ylab("Normalized Response")

        ggsave(allBoxplot, filename = "everything_boxplot.png",
               width = 20, height = 12)

        allTarget <- ggplot(data, aes(x = Treatment, y = NormLog)) +
                geom_boxplot(aes(fill = interaction(TimePoint, CellLine))) +
                facet_wrap(~Target) +
                labs(y = "Normalized Response", fill = "") +
                theme(axis.text.x = element_text(angle = 45, hjust = 1),
                      legend.position = "bottom")

        ggsave(allTarget, filename = "everything_targetwrap.png",
               width = 20, height = 12)
}
