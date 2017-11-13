checkRingQuality <- function(loc = "plots",
                             chkTime1 = 5,
                             chkTime2 = 10,
                             nrings = 10) {
        # read in data and subset for a flat part of the run
        dat <- readr::read_csv(paste0(loc,"/", name, "_allRings.csv"))
        dat <- subset(dat, Time > chkTime1 & Time < chkTime2)

        # fn to take absolute value of max signal
        absmax <- function(x) { x[which.max( abs(x) )]}

        # calculate variance and max signal for each ring
        dat.var <- dplyr::group_by(dat, Ring)
        dat.var <- dplyr::summarise_at(dat.var, dplyr::vars(Shift),
                                       dplyr::funs(Variance = stats::var,
                                            Max = absmax))

        # plot Variance vs Max signal (on log axis)
        g1 <- ggplot2::ggplot(dat.var, ggplot2::aes(x = Variance, y = Max,
                                  color = factor(Ring))) +
                ggplot2::geom_point() +
                ggplot2::scale_x_log10() +
                ggplot2::scale_y_log10()

        # create variables for rings with variance above/below given variance
        ringVar <- dplyr::arrange(dat.var, Variance)
        ringWinners <- utils::head(dplyr::select(ringVar, Ring), nrings)
        ringLosers <- utils::tail(dplyr::select(ringVar, Ring), nrings)

        # save files with list of good and bad rings base on given variance
        readr::write_csv(ringWinners, paste0(loc, '/', name, "_ringWinners.csv"))
        readr::write_csv(ringLosers, paste0(loc, '/', name, "_ringLosers.csv"))

        # save plot generated above
        ggplot2::ggsave(g1, filename = "Variance vs Max Signal.png",
               width = 8, height = 6)
}
