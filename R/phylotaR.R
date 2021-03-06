#' @importFrom methods is new getSlots initialize slot slotNames show
#' @importFrom stats median 
#' @importFrom utils head packageVersion read.table tail write.table

#' @name parameters
#' @title Default parameters
#' @description Returns a parameter list with default
#' parameter values.
#' @param wd The working directory where all output files are saved.
#' @param txid Taxonomic group of interest, allows vectors.
#' @param mkblstdb File path to makeblastdb
#' @param blstn File path to blastn
#' @param btchsz Batch size when querying NCBI
#' @param date Date when pipeline was initiated
#' @param v Print progress statements to console?
#' Statements will always be printed to log.txt.
#' @param ncps The number of CPUs to run clustering in parallel.
#' If 1, no parallelisation performed.
#' @param mxnds The maximum number of nodes descending from a taxonomic group.
#' If there are more than this number, nodes at the lower taxonomic level are analysed.
#' @param mdlthrs 'Model organism threshold'. Taxa with more sequences than this number
#' will be considered model organisms and a random mdlthrs subset of their sequences will
#' be downloaded.
#' @param mnsql The minimum length of sequence in nucleotide base pairs to download.
#' @param mxsql The maximum length of sequence in nucleotide base pairs to download.
#' Any longer sequences will be ignored.
#' @param mxrtry The maximum number of attempts to make when downloading.
#' @param mxsqs The maximum number of sequences to BLAST in all-vs-all searches.
#' If there are more sequences for a node, BLAST is performed at the lower taxonomic level.
#' @param mxevl The maximum E-value for a successful BLAST.
#' @param mncvrg The maximum percentile coverage defining an overlapping BLAST hit.
#' Sequences with BLAST matches with lower values are not considered orthologous.
#' @export
parameters <-function(wd='.', txid=numeric(),
                      mkblstdb='', blstn='',
                      v=FALSE, ncps=1,
                      mxnds=100000, mdlthrs=3000,
                      mnsql=250, mxsql=2000, 
                      mxrtry=100, mxsqs=50000,
                      mxevl=1.0e-10, mncvrg=51,
                      btchsz=300, date=Sys.Date()) {
  ps <- as.list(environment())
  ps[['wt_tms']] <- c(1, 3, 6, 10, 60, 300)
  ps
}

#' @name list_ncbi_ranks
#' @title List all NCBI Ranks
#' @description Returns a vector of all
#' NCBI taxonomic ranks in descending order.
#' @return vector
#' @export
list_ncbi_ranks <- function() {
  c("superkingdom", "kingdom", "phylum",
    "subphylum", "class", "superorder",
    "order", "suborder", "infraorder",
    "parvorder", "family", "genus",
    "species", "subspecies")
}

#' @name list_sqrcrd_slots
#' @title List all SqRcrd slots
#' @description Returns a vector of all
#' available SqRcrd slots.
#' @return vector
#' @export
list_sqrcrd_slots <- function() {
  slt_typs <- getSlots('SqRcrd')
  pull <- slt_typs %in% c('character', 'integer', 'raw', 'numeric')
  names(slt_typs[pull])
}

#' @name list_clrcrd_slots
#' @title List all ClRcrd slots
#' @description Returns a vector of all
#' available ClRcrd slots.
#' @return vector
#' @export
list_clrcrd_slots <- function() {
  slt_typs <- getSlots('ClRcrd')
  pull <- slt_typs %in% c('character', 'integer', 'raw', 'numeric')
  names(slt_typs[pull])
}

#' @name list_txrcrd_slots
#' @title List all TxRcrd slots
#' @description Returns a vector of all
#' available TxRcrd slots.
#' @return vector
#' @export
list_txrcrd_slots <- function() {
  slt_typs <- getSlots('TxRcrd')
  pull <- slt_typs %in% c('character', 'integer', 'raw', 'numeric')
  names(slt_typs[pull])
}
