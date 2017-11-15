## Plot each treatment as Net Shift vs Target
plotEachTxt <- function(data){
        treatmentList <- unique(data$Treatment)

        for (i in treatmentList) {

                rxDat <- filter(data, Treatment == i)

                g <- ggplot(rxDat, aes(x = Target, y = NormLog))

                fig4 <- g +
                        geom_point(aes(color = Target), position = "jitter") +
                        facet_grid(CellLine~TimePoint) +
                        ggtitle(paste0("Treatment: ", i)) +
                        labs(y = "Normalized Response", color = "") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1))

                fig5 <- g +
                        geom_boxplot(aes(fill = Target)) +
                        facet_grid(CellLine~TimePoint) +
                        ggtitle(paste0("Treatment: ", i)) +
                        labs(y = "Normalized Response", fill = "") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1))

                dir.create("Treatment Plots", showWarnings = FALSE)

                ggsave(fig4, filename = paste0("Treatment Plots/",
                                               i, "_point.png"),
                       width = 12, height = 8)

                ggsave(fig5, filename = paste0("Treatment Plots/",
                                               i, "_boxplot.png"),
                       width = 12, height = 8)
        }
}
