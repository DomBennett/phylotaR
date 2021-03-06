% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pipeline.R
\name{run}
\alias{run}
\title{Run PhyLoTa pipeline}
\usage{
run(wd, nstages = 4)
}
\arguments{
\item{wd}{Working directory}

\item{nstages}{Number of total stages to run, max 4.}
}
\description{
Run the entire PhyLoTa pipeline.
All generated files will be stored in the wd.
The process can be stopped at anytime and 
restarted with \code{restart}.
\code{nstages} must be a numeric value representing
the number of stages that will be run. Stages are run
in the following order:  1 - taxise, 2 - download,
3 - cluster and 4 - align.
For example, specifying \code{nstages} = 3, will run
taxise, download and cluster.
Stages can also be run individually, see linked
functions below.
}
\seealso{
\code{\link{restart}}, \code{\link{runTaxise}},
\code{\link{runDownload}}, \code{\link{runClusters}},
\code{\link{runClusters2}}
}
