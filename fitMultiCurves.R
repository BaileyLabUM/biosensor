fitMultiCurves <- function(data, loc){
        tarList <- unique(data$Target)
        fit <- list()
        for(i in tarList) {
                tarDat <- dplyr::filter(data, Target == i)
                y <- tarDat$NetShift
                x <- as.numeric(as.character(tarDat$Cycle))

                tarFit <- tryCatch({fit.info <- nls(formula = y ~ A + (B - A) /
                                                            (1 + (x / C) ^ D),
                                                    start = list(A = max(tarDat$NetShift),
                                                                 B = min(tarDat$NetShift),
                                                                 C = 25,
                                                                 D = 2))
                },
                error = function(e) {"failed"},
                finally = print(i))
                if(tarFit[1] != "failed"){
                        print(paste(i, "fit was successful"))
                        fit[[i]] <- broom::tidy(fit.info)
                        fit[[i]]$Target <- unique(tarDat$Target)
                        A <- as.numeric(coef(fit.info)[1])
                        B <- as.numeric(coef(fit.info)[2])
                        C <- as.numeric(coef(fit.info)[3])
                        D <- as.numeric(coef(fit.info)[4])
                        print(paste(A, B, C, D))

                        testFun <<- function(x) {A + (B - A) / (1 + (x / C) ^ D)}

                        plot <-
                                ggplot2::ggplot(tarDat,
                                                ggplot2::aes(x = Cycle,
                                                             y = NetShift,
                                                             group = Cycle)) +
                                ggplot2::geom_boxplot(fill = "red") +
                                ggplot2::stat_function(fun = testFun,
                                                       color = "blue", size = 1) +
                                ggplot2::labs(x = "Cycle Number",
                                              y = expression(paste("Relative Shift (",
                                                                   Delta,
                                                                   "pm)")))

                        ggplot2::ggsave(plot,
                                        filename = paste0(i, "CalCurve.png"),
                                        width = 8, height = 6)
                }
        }

        fit <- dplyr::bind_rows(fit)

        capture.output(fit, file = "fitInfo.txt")
        readr::write_csv(fit, path = "fitInfo.csv")
}
