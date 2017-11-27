plotMulitShifts <- function(data, loc, name){
                g1 <- ggplot2::ggplot(data,
                                      ggplot2::aes(x = Cycle,
                                                   y = NetShift,
                                                   color = Target,
                                                   group = Cycle)) +
                        ggplot2::geom_boxplot() +
                        ggplot2::ggtitle(name) +
                        ggplot2::facet_wrap(~Target)

                g2 <- ggplot2::ggplot(data,
                                     ggplot2::aes(x = Cycle,
                                                  y = NetShift,
                                                  Color = Target,
                                                  group = Ring)) +
                        ggplot2::geom_point() +
                        ggplot2::ggtitle(name) +
                        ggplot2::facet_wrap(~Target)

                ggplot2::ggsave(plot = g1, filename = paste0(loc, "/", name,
                                                    "_netShiftsCombined",
                                                    "_boxplot.png"),
                       width = 8, height = 6)

                ggplot2::ggsave(plot = g2, filename = paste0(loc, "/", name,
                                                    "_netShiftsCombined",
                                                    ".png"),
                       width = 8, height = 6)
}
