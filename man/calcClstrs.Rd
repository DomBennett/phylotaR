% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stage-cluster.R
\name{calcClstrs}
\alias{calcClstrs}
\title{Calculate clusters for all sequences in WD}
\usage{
calcClstrs(txdct, ps)
}
\arguments{
\item{txdct}{Taxonomic dictionary}

\item{ps}{Parameters}
}
\description{
Loop through downloaded sequences
for each clade and hierarchically find clusters
using BLAST.
}
