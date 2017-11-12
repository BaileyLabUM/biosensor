plotNetShifts <- function(cntl, ch, loc, step = 1){
        ggplot2::theme_set(ggthemes::theme_few(base_size = 16))

        dat <- readr::read_csv(paste0(loc, "/", name, "_netShifts_", cntl, "cntl_",
                               "ch", ch, "_step", step, ".csv"))

        # configure plot and legend
        dat.nothermal <- dplyr::filter(dat, Target != "thermal")

        plots <- ggplot2::ggplot(dat.nothermal,
                        aes(x = Target, y = NetShift, fill = Target)) +
                ggplot2::geom_boxplot() +
                ggplot2::theme(axis.text.x =
                                       ggplot2::element_text(angle = 45,
                                                             hjust = 1),
                               legend.position="none") +
                ggplot2::ylab(expression(paste("Net Shift (",Delta,"pm)"))) +
                ggplot2::ggtitle(paste0(name, " Ch: ", ch, " Control: ", cntl))

        allRings <- ggplot2::ggplot(dat.nothermal,
                           aes(x = factor(Ring), y= NetShift,
                               fill = Target)) +
                ggplot2::geom_bar(stat = "identity") +
                ggplot2::theme(axis.text.x =
                              element_text(angle = 90,
                                           hjust = 1, vjust = 0.5)) +
                ggplot2::ylab(expression(paste("Net Shift (",Delta,"pm)"))) +
                ggplot2::xlab("Ring") +
                ggplot2::ggtitle(paste0(name, " Ch: ", ch, " Control: ", cntl))

        # save plot, uncomment to save
        ggplot2::ggsave(plot = plots,
               file = paste0(loc, "/",  name, "_NetShift_", cntl, "cntl_",
                             "ch", ch, "_step", step, ".png"),
               width = 10, height = 6)
        ggplot2::ggsave(plot = allRings,
               file = paste0(loc, "/", name, "_IndyRings","_NetShift_", cntl,
                             "cntl_", "ch", ch, "_step", step, ".png"),
               width = 12, height = 6)
}
