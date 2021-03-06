
#' @name getTxids
#' @title Searches for descendent taxonomic IDs
#' @description Searches NCBI taxonomy for all descendent
#' taxonomic nodes.
#' @return Vector of txids
#' @param ps Parameter list
getTxids <- function(ps) {
  # TODO: handle multiple txids
  # TODO: handle taxa of more than 1E4
  trm <- paste0('txid', ps[['txid']],'[Subtree]')
  args <- list(db='taxonomy', term=trm, retmax=1E4)
  srch_rs <- srchNCch(func=rentrez::entrez_search, args=args,
                      fnm='search', ps=ps)
  if(srch_rs[['count']] > 1E4) {
    error('Too large a clade.')
  }
  srch_rs[['ids']]
}

#' @name dwnldTxRcrds
#' @title Download and parse taxonomic records
#' @description Downloads taxonomic records from a vector
#' of IDs. Parses the returned records to control for
#' lowest rank.
#' @return List of taxonomic records
#' @param txids Vector of taxonomic IDs
#' @param ps Parameter list
dwnldTxRcrds <- function(txids, ps) {
  # TODO: add nsqs info
  # TODO: drop all records below given rank
  btchDwnldTxRcrds(txids=txids, ps=ps)
}

#' @name genTxDct
#' @title Generate taxonomic dictionary
#' @description Takes a vector of txids and a list
#' of taxonomic records and returns a taxonomic dictionary.
#' @return TxDct
#' @param txids Vector of taxonomic IDs
#' @param rcrds List of taxonomic records
genTxDct <- function(txids, rcrds) {
  # TODO: allow paraphyly
  # identify pre-node IDs
  # based upon: https://github.com/DomBennett/treeman/wiki/trmn-format
  # drop singletons
  # create index to recover original IDs, indx
  prids <- vapply(txids, function(x) rcrds[[x]]@prnt, '')
  names(prids) <- NULL
  root_bool <- !prids %in% txids
  root <- txids[root_bool]
  prids[root_bool] <- root
  root_trid <- as.character(which(root_bool))
  trids <- seq_along(txids)
  n_ptnds <- table(prids)
  to_drop <- NULL
  while(any(n_ptnds == 1)) {
    # get singletons
    sngltns <- names(n_ptnds)[n_ptnds == 1]
    sngltns_indx <- match(sngltns, txids)
    sngltns_trids <- match(sngltns, prids)
    # replace singleton prid in tree IDs
    trids[sngltns_indx] <- sngltns_trids
    # replace singleton prid in prids
    prids[sngltns_trids] <- prids[sngltns_indx]
    to_drop <- c(to_drop, sngltns)
    n_ptnds <- table(prids)
  }
  indx <- trids
  to_drop <- !txids %in% to_drop
  prids <- prids[to_drop]
  trids <- as.character(trids[to_drop])
  prinds <- match(prids, txids[to_drop])
  prinds <- as.integer(prinds)
  # create tax tree
  txtr <- genTxTr(prinds=prinds, trids=trids, root=root_trid)
  # create tax dict
  new('TxDct', txids=txids, rcrds=list2env(rcrds), txtr=txtr,
      prnt=root, indx=indx)
}
