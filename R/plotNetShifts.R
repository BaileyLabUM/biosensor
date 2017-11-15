plotNetShifts <- function(data, loc, step = 1, name){
        ch <- unique(data$Channel)
        if(length(ch) > 1) {ch <- "U"}
        # configure plot and legend
        plots <- ggplot2::ggplot(data,
                        ggplot2::aes(x = Target, y = NetShift, fill = Target)) +
                ggplot2::geom_boxplot() +
                ggplot2::theme(axis.text.x =
                                       ggplot2::element_text(angle = 45,
                                                             hjust = 1),
                               legend.position="none") +
                ggplot2::ylab(expression(paste("Net Shift (",Delta,"pm)"))) +
                ggplot2::ggtitle(paste0(name, " Ch: ", ch))

        allRings <- ggplot2::ggplot(data,
                           ggplot2::aes(x = factor(Ring), y= NetShift,
                               fill = Target)) +
                ggplot2::geom_bar(stat = "identity") +
                ggplot2::theme(axis.text.x =
                              ggplot2::element_text(angle = 90,
                                           hjust = 1, vjust = 0.5)) +
                ggplot2::ylab(expression(paste("Net Shift (",Delta,"pm)"))) +
                ggplot2::xlab("Ring") +
                ggplot2::ggtitle(paste0(name, " Ch: ", ch))

        # save plot, uncomment to save
        ggplot2::ggsave(plot = plots,
               file = paste0(loc, "/",  name, "_NetShift_",
                             "ch", ch, "_step", step, ".png"),
               width = 10, height = 6)
        ggplot2::ggsave(plot = allRings,
               file = paste0(loc, "/", name, "_IndyRings","_NetShift_",
                             "ch", ch, "_step", step, ".png"),
               width = 12, height = 6)
}
