plotRingData <- function(cntl, ch, loc, splitPlot = FALSE){
        ggplot2::theme_set(ggthemes::theme_few(base_size = 16))

        # use thermally controlled data if desired
        if (cntl != "raw"){
                dat <- readr::read_csv(paste(loc, "/", name, "_", cntl, "Control",
                                      "_ch", ch,".csv", sep=''))
        } else if (cntl == "raw") {
                dat <- readr::read_csv(paste(loc, "/", name, "_allRings.csv", sep=''))
                if (ch != "U") {dat <- dplyr::filter(dat, Channel == ch)}
        }

        # configure plot and legend
        plots <- ggplot2::ggplot(dat, ggplot2::aes(x = Time, y = Shift,
                                 color = Target, group = Ring)) +
                ggplot2::labs(x = "Time (min)",
                     y = expression(paste("Relative Shift (",Delta,"pm)")),
                     color = "Target") +
                ggplot2::geom_line() +
                ggplot2::ggtitle(paste(name, "Ch:", ch,
                                       "Control:", cntl, sep = " "))

        # alternative plots with averaged clusters

        dat.2 <-dplyr::group_by(dat, Target, `Time Point`)
        dat.2 <- dplyr::summarise_at(dat.2, dplyr::vars(Time, Shift),
                                     dplyr::funs(mean, sd = stats::sd))

        plot2 <- ggplot2::ggplot(dat.2, ggplot2::aes(x = Time_mean, y = Shift_mean,
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
                plots <- plots + ggplot2::facet_grid(. ~ Channel)
        }

        # save plots
        ggplot2::ggsave(plot = plots,
               file = paste0(loc, "/", name, "_", cntl,
                             "Control_ch", ch, ".png"),
               width = 10, height = 6)
        ggplot2::ggsave(plot = plot2,
               file = paste0(loc, "/", name, "_", cntl,
                             "Control", "_ch", ch, "_avg.png"),
               width = 10, height = 6)
        ggplot2::ggsave(plot = plot3,
               file = paste0(loc, "/", name, "_", cntl,
                             "Control", "_ch", ch, "_avg.png"),
               width = 10, height = 6)
}
