
#' This function smooths periodic (annual) data in the GHCN format.
#'
#' First, it converts all data to DOY data (366-day-year).
#' Then, it calculates a periodic generalized additive model
#' from the data using cyclic cubic regression splines for smoothing.
#' It then calculates the daily-wise standard deviations of the residuals,
#' and again smooths using the same type of GAM.
#' Optionally, you may plot the results.
#'
#' @param daily.data GHCN data
#' @param unwrapped Whether the data are already unwrapped
#' @param plot Whether to create a polar plot of the climatology.
#'
#' @return A list containing the day-of-year, mean, and sd.
#' @export
calcDailyMeanSD <- function(daily.data,
                            unwrapped = F,
                            plot = F) {
  if (!unwrapped) {
    # Unwrap data and convert to POSIX Day of Year (DoY)
    daily.data.unwrap <- data.frame(
      DOY = as.numeric(strftime(as.POSIXlt(paste(rep(daily.data$YEAR, each = 31),
        rep(daily.data$MONTH, each = 31),
        rep(1:31, times = nrow(daily.data)),
        sep = "."
      ),
      format = "%Y.%m.%d"
      ),
      format = "%j"
      )),
      DATA = as.numeric(t(daily.data[, -1:-2]))
    )
    daily.data.unwrap <- daily.data.unwrap[!is.na(daily.data.unwrap$DATA) & !is.na(daily.data.unwrap$DOY), ]
  } else {
    daily.data.unwrap <- daily.data
  }

  # fit a generalized additive model to data as smooth, periodic function of DoY
  mean.model <- mgcv::gam(DATA ~ s(DOY, bs = "cc"),
    data = daily.data.unwrap
  )

  # generate predictions from our DoY model
  mean.predictions <- stats::predict(
    mean.model,
    data.frame(DOY = 1:366)
  )

  # Get the standard deviation of the residuals for each day
  daily.data.unwrap$RES <- stats::residuals(mean.model)
  residual.sds <- stats::aggregate(daily.data.unwrap$RES,
    by = list(daily.data.unwrap$DOY),
    stats::sd
  )
  names(residual.sds) <- c("DOY", "SD")
  sd.model <- mgcv::gam(SD ~ s(DOY, bs = "cc"),
    data = residual.sds
  )
  sd.predictions <- stats::predict(
    sd.model,
    data.frame(DOY = 1:366)
  )

  if (plot) {
    plotrix::polar.plot(
      lengths = daily.data.unwrap$DATA,
      polar.pos = (daily.data.unwrap$DOY) * 360 / 365,
      labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
      label.pos = c(0, 32, 60, 92, 122, 153, 184, 214, 245, 275, 306, 336) * 360 / 365,
      rp.type = "s",
      clockwise = TRUE,
      start = 1,
      radial.lim = range(daily.data.unwrap$DATA),
      cex = 0.1
    )
    plotrix::polar.plot(
      lengths = as.numeric(mean.predictions),
      polar.pos = as.numeric(names(mean.predictions)) * 360 / 366,
      rp.type = "p",
      clockwise = TRUE,
      start = 0,
      radial.lim = range(daily.data.unwrap$DATA),
      lwd = 3,
      line.col = "dodgerblue",
      add = TRUE
    )
    plotrix::polar.plot(
      lengths = as.numeric(mean.predictions) + as.numeric(sd.predictions),
      polar.pos = as.numeric(names(mean.predictions)) * 360 / 366,
      rp.type = "p",
      clockwise = TRUE,
      start = 0,
      add = TRUE,
      lty = 1,
      radial.lim = range(daily.data.unwrap$DATA),
      line.col = "red",
      lwd = 2
    )
    plotrix::polar.plot(
      lengths = as.numeric(mean.predictions) - as.numeric(sd.predictions),
      polar.pos = as.numeric(names(mean.predictions)) * 360 / 366,
      rp.type = "p",
      clockwise = TRUE,
      start = 0,
      add = TRUE,
      lty = 1,
      radial.lim = range(daily.data.unwrap$DATA),
      line.col = "red",
      lwd = 2
    )
  }

  return(do.call(
    cbind,
    list(
      DOY = 1:366,
      MEAN = mean.predictions,
      SD = sd.predictions
    )
  ))
}
