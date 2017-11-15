plotCombinedNetShifts <- function(data, name){
        ggplot2::theme_set(ggthemes::theme_few(base_size = 16))

        plot <- ggplot2::ggplot(data,
                                ggplot2::aes(x = Concentration,
                                             y = NetShift,
                                             color = Target,
                                             group = Concentration)) +
                ggplot2::ggtitle(name) +
                ggplot2::scale_x_log10() +
                ggplot2::labs(x = "Analyte Concentration (pg/mL)",
                              y = expression(paste("Relative Shift (",
                                                   Delta,"pm)")),
                              color = "Target")

        plot1 <- plot + ggplot2::geom_point()
        plot1a <- plot1 + ggplot2::facet_wrap(~Target)
        plot2 <- plot + ggplot2::geom_boxplot() +
                ggplot2::facet_wrap(~Target)

        ggplot2::ggsave(plot = plot1,
                        filename = paste0("netShiftsCombined_point.png"),
                        width = 16, height = 12)
        ggplot2::ggsave(plot = plot1a,
                        filename = paste0("netShiftsCombined_pointwrap.png"),
                        width = 16, height = 12)
        ggplot2::ggsave(plot = plot2,
                        filename = paste0("netShiftsCombined_box.png"),
                        width = 16, height = 12)
}
