cytometry <- function(data){
        dir.create("Cytometry", showWarnings = FALSE)
        rxDat <- filter(data, !grepl("Serum", Treatment))
        pairList <- t(combn(unique(data$Target), 2))
        for(i in seq_len(nrow(pairList))){
                cytDat <- dplyr::filter(rxDat, Target %in% pairList[i, ])
                cytCast <- reshape2::dcast(data = cytDat, Treatment + CellLine +
                                         TimePoint + Replicate + n ~ Target,
                                 value.var = "NormLog")

                plot <- ggplot2::ggplot(cytCast, ggplot2::aes(x = cytCast[, 6],
                                            y = cytCast[, 7],
                                            color = interaction(CellLine,
                                                                TimePoint))) +
                        ggplot2::geom_point() +
                        ggplot2::labs(color = "",
                             x = paste(pairList[i,1], "(Normalized Response)"),
                             y = paste(pairList[i,2], "(Normalized Response)"))

                tar1 <- substr(pairList[i,1], 1, 9)
                tar2 <- substr(pairList[i,2], 1, 9)
                ggplot2::ggsave(plot, filename = paste0("Cytometry/", tar1, " vs ",
                                               tar2, ".png"),
                       width = 8, height = 6)
        }
}
