## Plot each target as Net Shift vs Treatment
plotEachTar <- function(data){
        targetList <- unique(data$Target)

        for(i in targetList) {

                tarDat <- filter(data, Target == i & Treatment != "(+)-Serum" &
                                         Treatment != "(-)-Serum")

                g <- ggplot(tarDat, aes(x = Treatment, y = NormLog))

                plotName <- unlist(strsplit(i, "/"))[1]

                targetPoint <- g +
                        geom_point(aes(color = TimePoint),
                                   position = "jitter") +
                        facet_grid(CellLine~.) +
                        ggtitle(paste0("Target: ", i)) +
                        labs(y = "Normalized Response", color = "") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1))

                targetBox <- g +
                        geom_boxplot(aes(fill = TimePoint)) +
                        facet_grid(CellLine~.) +
                        ggtitle(paste0("Target: ", i)) +
                        labs(y = "Normalized Response", fill = "") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1))

                targetBox2 <- g +
                        geom_boxplot(aes(fill = interaction(TimePoint,
                                                            CellLine))) +
                        ggtitle(paste0("Target: ", i)) +
                        labs(y = "Normalized Response", fill = "") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1))

                dir.create("Target Plots", showWarnings = FALSE)

                ggsave(targetPoint,
                       filename = paste0("Target Plots/",
                                         plotName, "_point.png"),
                       width = 8, height = 6)
                ggsave(targetBox,
                       filename = paste0("Target Plots/",
                                         plotName, "_boxplot.png"),
                       width = 8, height = 6)
                ggsave(targetBox2,
                       filename = paste0("Target Plots/",
                                         plotName, "_boxplot_2.png"),
                       width = 8, height = 6)
        }
}
