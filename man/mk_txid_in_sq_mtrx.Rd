% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-tools-phylota-special.R
\name{mk_txid_in_sq_mtrx}
\alias{mk_txid_in_sq_mtrx}
\title{Return matrix of txid in sequence}
\usage{
mk_txid_in_sq_mtrx(phylota, txids, sids = phylota@sids)
}
\arguments{
\item{phylota}{PhyLoTa object}

\item{txids}{Taxonomic IDs}

\item{sids}{Sequence IDs}
}
\value{
matrix
}
\description{
Searches through lineages of sequences'
source organisms to determine whether each txid
is represented by the sequence.
}
