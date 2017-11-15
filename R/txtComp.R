## Pairwise treatment comparisons
txtComp <- function(data, treatments, targets, cellLine){
        rxDat <- filter(data, Treatment == treatments & Target %in% targets &
                                CellLine == cellLine)
        g <- ggplot(rxDat, aes(x = Target,
                               group = interaction(Treatment,
                                                   TimePoint,
                                                   Target),
                               y = NormLog))

        figComp <- g +
                geom_boxplot(aes(fill = interaction(Treatment, TimePoint))) +
                labs(fill = "", x = "Target", y = "Normalized Response") +
                ggtitle(paste0(treatments[1], " vs ", treatments[2])) +
                theme(axis.text.x = element_text(angle = 45, hjust = 1))

        figComp2 <- g +
                geom_boxplot(aes(fill = Treatment)) +
                facet_wrap(~TimePoint) +
                labs(fill = "", x = "Target", y = "Normalized Response") +
                ggtitle(paste0(treatments[1], " vs ", treatments[2])) +
                theme(axis.text.x = element_text(angle = 45, hjust = 1))

        dir.create(path = "Treatment Comparisons", showWarnings = FALSE)

        ggsave(figComp,
               filename = paste0("Treatment Comparisons/", treatments[1], "_",
                                 treatments[2], "_", cellLine, ".png"),
               width = 8, height = 6)
        ggsave(figComp2,
               filename = paste0("Treatment Comparisons/", treatments[1], "_",
                                 treatments[2], "_", cellLine, "_2.png"),
               width = 8, height = 6)
}
