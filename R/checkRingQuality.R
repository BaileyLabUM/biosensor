checkRingQuality <- function(data,
                             loc = "plots",
                             chkTime1 = 5,
                             chkTime2 = 10,
                             nrings = 10,
                             name) {
        # subset for a "flat" part of the run to assess ring performance
        data <- subset(data, Time > chkTime1 & Time < chkTime2)

        # fn to take absolute value of max signal
        absmax <- function(x) { x[which.max( abs(x) )]}

        # calculate variance and max signal for each ring
        `%>%` <- magrittr::`%>%`

        varDat <- data %>%
                dplyr::group_by(Ring) %>%
                dplyr::summarise_at(varDat,
                                    dplyr::vars(Shift),
                                    dplyr::funs(Var = stats::var, Max = absmax))

        # plot Variance vs Max signal (on log axis)
        g1 <- ggplot2::ggplot(varDat, ggplot2::aes(x = Var, y = Max,
                                  color = factor(Ring))) +
                ggplot2::geom_point() +
                ggplot2::scale_x_log10() +
                ggplot2::scale_y_log10()

        # create variables for rings with variance above/below given variance
        ringVar <- dplyr::arrange(varDat, Var)
        ringWinners <- utils::head(dplyr::select(ringVar, Ring), nrings)
        ringLosers <- utils::tail(dplyr::select(ringVar, Ring), nrings)

        # save files with list of good and bad rings base on given variance
        readr::write_csv(ringWinners, paste0(loc, '/', name, "_ringWinners.csv"))
        readr::write_csv(ringLosers, paste0(loc, '/', name, "_ringLosers.csv"))

        # save plot generated above
        ggplot2::ggsave(g1, filename = "Variance vs Max Signal.png",
               width = 8, height = 6)

        return(ringWinners)
}
