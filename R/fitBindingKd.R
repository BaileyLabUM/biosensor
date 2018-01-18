fitBindingKd <- function(netFile, loc, name){
        ggplot2::theme_set(ggthemes::theme_few(base_size = 16))

        data <- read.csv(netFile, header = TRUE)
        ringList <- unique(data$Ring)
        fit <- list()
        fitAvg <- list()
        for(i in ringList) {
                ringDat <- dplyr::filter(data, Ring == i)
                startBmax <- max(ringDat$NetShift)
                startKd <- max(ringDat$NetShift)/2
                y <- ringDat$NetShift
                x <- as.numeric(ringDat$Step)
                nls.control(minFactor = 5)
                tarFit <- tryCatch({fit.info <- nls(formula = y ~ Bmax * x /(Kd + x),
                                                    start = list(Bmax = startBmax,
                                                                 Kd = startKd))},
                                   error = function(e) {"failed"})

                if(tarFit[1] != "failed"){
                        fit[[i]] <- broom::tidy(fit.info)
                        fit[[i]]$Ring <- unique(ringDat$Ring)
                        fit[[i]]$Target <- unique(ringDat$Target)
                        Bmax <- as.numeric(coef(fit.info)[1])
                        Kd <- as.numeric(coef(fit.info)[2])}
        }

        fit <- dplyr::bind_rows(fit)
        fit <- dplyr::group_by(fit, Target, term)
        fitAvg <- dplyr::summarise_at(fit, dplyr::vars(estimate),
                                      dplyr::funs(mean, sd = stats::sd))
        print(fitAvg)

        plot <- ggplot2::ggplot(data, ggplot2::aes(x = Step, y = NetShift,
                                                   colour = Target))+
                ggplot2::theme(legend.position ="none") +
                ggplot2::stat_summary(fun.y = mean, geom = "point", size = 3,
                                      fun.ymin=function(x) mean(x) - sd(x),
                                      fun.ymax=function(x) mean(x) + sd(x))+
                ggplot2::stat_summary(fun.y = mean, geom="errorbar", width=50,
                                      fun.ymin=function(x) mean(x) - sd(x),
                                      fun.ymax=function(x) mean(x) + sd(x),
                                      color="black") +
                ggplot2::facet_wrap(~Target, ncol=4) +
                ggplot2::labs(x = "Concentration (nM)",
                              y = expression(paste("Relative Shift (", Delta,"pm)")))+
                ggplot2::geom_smooth(method = "nls", linetype = "dashed", colour= "black",
                                     se = FALSE, size = 1,
                                     method.args = list(formula = y ~ Bmax * x / (Kd + x),
                                                        start= list(Bmax = startBmax,
                                                                    Kd = startKd)))

        capture.output(fit, file = paste0(loc, "/", name,"fitInfo.txt", sep = ""))
        readr::write_csv(fit, path = paste0(loc, "/", name,"fitInfo.csv", sep = ""))
        readr::write_csv(fitAvg, path = paste0(loc, "/", name,"fitInfoAvg.csv", sep = ""))

        fitAvg <- dplyr::filter(fitAvg, term == "Kd")

        Kd <- ggplot2::ggplot(fitAvg, ggplot2::aes(x = Target,  y = mean, fill = Target)) +
                ggplot2::geom_bar(stat = "identity", color = "black")+
                ggplot2::geom_errorbar(ggplot2::aes(ymin = fitAvg$mean - fitAvg$sd,
                                                    ymax = fitAvg$mean + fitAvg$sd),
                                       width = 0.85, color="black", size=1)+
                ggplot2::labs(y = expression(bold(paste("K"[d], " (nM)", sep=" "))))+
                ggplot2::scale_x_discrete(name= "Nanodisc Composition")+
                ggplot2::theme(legend.position = "none")


        ggplot2::ggsave(plot, width = 8, height = 6,
                        filename = paste0(loc, "/", "CalCurve.png", sep = ""))
        ggplot2::ggsave(Kd, width = 8, height = 6,
                        filename = paste0(loc, "/", "KdPlot.png", sep = ""))

}
