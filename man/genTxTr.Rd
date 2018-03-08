% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-tools-txdct.R
\name{genTxTr}
\alias{genTxTr}
\title{Generate taxonomic tree}
\usage{
genTxTr(prinds, trids, root)
}
\arguments{
\item{prinds}{Vector of integers indicating preceding node.}

\item{root}{ID of root taxon}

\item{txids}{Vector of taxonomic IDs}
}
\value{
TreeMan
}
\description{
Generate a taxonomic tree for
easy look up of taxonomic parents and descendants.
}