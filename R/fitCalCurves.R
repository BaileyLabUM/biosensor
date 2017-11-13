fitCalCurves <- function(data, loc = 'plots', tarList){
        ggplot2::theme_set(ggthemes::theme_few(base_size = 16))

        tarList <- unique(data$Target)
        fit <- list()
        for(i in tarList) {
                tarDat <- dplyr::filter(data, Target == i)
                y <- tarDat$NetShift
                x <- tarDat$Concentration
                tarFit <- tryCatch({fit.info <- nls(formula = y ~ A + (B - A) /
                                                            (1 + (x / C) ^ D),
                                                    start = list(A = 10000,
                                                                 B = 100,
                                                                 C = 4000,
                                                                 D = 1))
                },
                error = function(e) {"failed"},
                finally = print(i))
                if(tarFit[1] != "failed"){
                        fit[[i]] <- broom::tidy(fit.info)
                        fit[[i]]$Target <- unique(tarDat$Target)
                        A <- as.numeric(coef(fit.info)[1])
                        B <- as.numeric(coef(fit.info)[2])
                        C <- as.numeric(coef(fit.info)[3])
                        D <- as.numeric(coef(fit.info)[4])

                        testFun <- function(x) {A + (B - A) / (1 + (x / C) ^ D)}

                        plot <- ggplot2::ggplot(tarDat,
                                                ggplot2::aes(x = Concentration,
                                                             y = NetShift,
                                                             group = Concentration)) +
                                ggplot2::geom_boxplot(fill = "red") +
                                ggplot2::stat_function(fun = testFun,
                                                       color = "blue", size = 1) +
                                ggplot2::scale_x_log10(breaks = scales::trans_breaks("log10",
                                                                                     function(x) 10^x),
                                                       labels = scales::trans_format("log10",
                                                                scales::math_format(10 ^ .x))) +
                                ggplot2::labs(x = "Analyte Concentration (pg/mL)",
                                              y = expression(paste("Relative Shift (",
                                                                   Delta,
                                                                   "pm)"))) +
                                ggplot2::annotation_logticks()

                        ggplot2::ggsave(plot,
                                        filename = paste0(i, "CalCurve.png"),
                                        width = 8, height = 6)
                }
        }

        fit <- dplyr::bind_rows(fit)

        capture.output(fit, file = "fitInfo.txt")
        readr::write_csv(fit, path = "fitInfo.csv")
}
