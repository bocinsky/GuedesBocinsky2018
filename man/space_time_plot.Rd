% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/space_time_plot.R
\name{space_time_plot}
\alias{space_time_plot}
\title{A space-time plot.}
\usage{
space_time_plot(the_brick, the_brick_upper = NULL, the_brick_lower = NULL,
  out_file, line = 75, title = NULL, time, timelim, timeaxis,
  timelab = "Year AD", zbreaks = NULL, zlab, zaxis,
  zcolors = rev(RColorBrewer::brewer.pal(11, "RdYlBu")), fig_width = 6.5,
  graph_height = 1.5, margin = 0.1, pt_size = 8, smooth = FALSE,
  extra_plot_fun = NULL, extra_legend_fun = NULL)
}
\arguments{
\item{the_brick}{The data to plot}

\item{the_brick_upper}{The upper CI data}

\item{the_brick_lower}{The lower CI data}

\item{out_file}{Where to write the output}

\item{title}{The Title of the plot}

\item{time}{The timeseries of the plot}

\item{timelim}{The time limits of the plot}

\item{timeaxis}{The time limits of the axis}

\item{timelab}{The label of the time axis}

\item{zbreaks}{The color breaks for plotting}

\item{zlab}{The label for the data}

\item{zaxis}{The axis breaks for the data}

\item{zcolors}{The colors for the data}

\item{fig_width}{The width of the figure}

\item{graph_height}{The height of the time series graph}

\item{margin}{The margin}

\item{pt_size}{The point size}

\item{smooth}{Should the timeseries be smoothed by kernel estimation}

\item{extra_plot_fun}{Any extra plotting functions}

\item{extra_legend_fun}{Any extra legend functions}
}
\description{
Given a raster brick (and possibly uncertainties/errors),
plot a map of the average across time, and a
graph of the average across space.
}
\keyword{internal}
