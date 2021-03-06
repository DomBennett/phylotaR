% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tools-entrez.R
\name{getGIs}
\alias{getGIs}
\title{Return random set of sequence IDs}
\usage{
getGIs(txid, drct, sqcnt, ps, retmax = 100, hrdmx = 1e+05)
}
\arguments{
\item{txid}{NCBI taxon identifier}

\item{drct}{Node-level only or subtree as well? Default FALSE.}

\item{sqcnt}{Sequence count as determined with nSqs()}

\item{ps}{Parameters}

\item{retmax}{Maximum number of sequences when querying model
organisms. The smaller the more random, the larger the faster.}

\item{hrdmx}{Absolute maximum number of sequence IDs to download
in a single query.}
}
\value{
vector ot IDs
}
\description{
For a given txid return a random set of 
sequences associated.
}
\details{
For model organisms downloading all IDs can a take long time
or even cause an xml parsing error. For any search with more than
hrdmx sequences, this function we will run multiple small searches
downloading retmax seq IDs at a time with different retstart values
to generate a semi-random vector of sequence IDs. For all other
searches, all IDs will be retrieved.
Note, it makes no sense for mdlthrs in parameters to be greater
than hrdmx in this function.
}
