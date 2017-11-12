checkRingQuality <- function(loc, time1, time2, nrings = 10) {
        # read in data and subset for a flat part of the run
        dat <- readr::read_csv(paste0(loc,"/", name, "_allRings.csv"))
        dat <- subset(dat, Time > time1 & Time < time2)

        # fn to take absolute value of max signal
        absmax <- function(x) { x[which.max( abs(x) )]}

        # calculate variance and max signal for each ring
        dat.var <- dat %>% dplyr::group_by(Ring) %>%
                dplyr::summarise_at(vars(Shift),
                                    funs(Variance = stats::var, Max = absmax))

        # plot Variance vs Max signal (on log axis)
        g1 <- ggplot2::ggplot(dat.var, aes(x = Variance, y = Max,
                                  color = factor(Ring))) +
                ggplot2::geom_point() +
                ggplot2::scale_x_log10() +
                ggplot2::scale_y_log10()

        # create variables for rings with variance above/below given variance
        ringWinners <- dplyr::arrange(dat.var, Variance) %>%
                dplyr::select(Ring) %>%
                utils::head(nrings)
        ringLosers <- dplyr::arrange(dat.var, Variance) %>%
                dplyr::select(Ring) %>%
                utils::tail(nrings)

        # save files with list of good and bad rings base on given variance
        readr::write_csv(ringWinners, paste0(loc, '/', name, "_ringWinners.csv"))
        readr::write_csv(ringLosers, paste0(loc, '/', name, "_ringLosers.csv"))

        # save plot generated above
        ggplot2::ggsave(g1, filename = "Variance vs Max Signal.png",
               width = 8, height = 6)
}
