plotRingData <- function(data, raw = FALSE, loc, splitPlot = FALSE){
        # set theme for all plots
        ggplot2::theme_set(ggthemes::theme_few(base_size = 16))

        # assign parameters for plots and plot names
        if(raw){
                yAxis <- as.symbol("Shift")
                yAxisAvg <- as.symbol("Shift_mean")
                cntl <- "Raw"
        } else {
                yAxis <- as.symbol("Corrected")
                yAxisAvg <- as.symbol("Corrected_mean")
                cntl <- unique(data$Cntl)
        }
        ch <- unique(data$Ch)

        # configure plot and legend
        plot1 <- ggplot2::ggplot(data,
                                 ggplot2::aes(x = Time,
                                              y = eval(yAxis),
                                              color = Target,
                                              group = Ring)) +
                ggplot2::labs(x = "Time (min)",
                     y = expression(paste("Relative Shift (",Delta,"pm)")),
                     color = "Target") +
                ggplot2::geom_line() +
                ggplot2::ggtitle(paste(name, "Ch:", ch,
                                       "Control:", cntl, sep = " "))

        # alternative plots with averaged clusters

        avgDat <- dplyr::group_by(data, Target, TimePoint)
        avgDat <- dplyr::summarise_at(avgDat, dplyr::vars(Time, Shift, Corrected),
                                     dplyr::funs(mean, sd = stats::sd))

        plot2 <- ggplot2::ggplot(avgDat,
                                 ggplot2::aes(x = Time_mean,
                                              y = eval(yAxisAvg),
                                              color = Target)) +
                ggplot2::geom_line() +
                ggplot2::labs(x = "Time (min)",
                              y = expression(paste("Relative Shift (",
                                                   Delta,"pm)"))) +
                ggplot2::ggtitle(paste(name, "Ch:", ch, "Control:",
                                       cntl, sep = " "))

        plot3 <- plot2 +
                ggplot2::geom_ribbon(ggplot2::aes(ymin = Shift_mean - Shift_sd,
                                ymax = Shift_mean + Shift_sd,
                                linetype = NA),
                            fill = "slategrey", alpha = 1/8)

        if (splitPlot){
                plot1 <- plot1 + ggplot2::facet_grid(. ~ Channel)
        }

        # save plots
        ggplot2::ggsave(plot = plot1,
               file = paste0(loc, "/", name, "_", cntl,
                             "Control_ch", ch, ".png"),
               width = 10, height = 6)
        ggplot2::ggsave(plot = plot2,
               file = paste0(loc, "/", name, "_", cntl,
                             "Control", "_ch", ch, "_avg.png"),
               width = 10, height = 6)
        ggplot2::ggsave(plot = plot3,
               file = paste0(loc, "/", name, "_", cntl,
                             "Control", "_ch", ch, "_avg_2.png"),
               width = 10, height = 6)
}
