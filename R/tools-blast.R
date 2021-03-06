#' @name mkBlstDB
#' @title Make a BLAST database
#' @description Generate BLAST database in wd 
#' for given sequences.
#' @param sqs Sequences
#' @param dbfl Outfile for database
#' @param ps Parameters
mkBlstDB <- function(sqs, dbfl, ps) {
  if(length(sqs@sqs) < 2) {
    error(ps=ps, 'Need more than 2 sequences for BLAST.')
  }
  blst_d <- file.path(ps[['wd']], 'blast')
  if(!file.exists(blst_d)) {
    dir.create(blst_d)
  }
  fl <- file.path(blst_d, dbfl)
  file.create(fl)
  for(i in seq_along(sqs@ids)) {
    sq <- sqs@sqs[[i]]
    write(paste0("> ", sq@id, "\n", rawToChar(sq@sq)),
                 file=fl, append=TRUE)
  }
  args <- c('-in', fl, '-dbtype', 'nucl')
  info(lvl=3, ps=ps, "Running makeblastdb")
  res <- cmdLn(cmd=ps[['mkblstdb']], args=args,
               lgfl=fl)
  if(res != 0) {
    error(ps=ps, paste0('makeblastdb failed to run. Check BLAST log files.'))
  }
  # Check success
  extensions <- c('nhr', 'nin', 'nsq')
  fnames <- sapply(extensions, function(e) paste0(fl, '.', e))
  if(!all(sapply(fnames, file.exists))) {
    error(ps=ps, 'Command did not produce output files [',
          paste(fnames), ']')
  }
  NULL
}

#' @name blstN
#' @title BLAST all vs all
#' @description Use \code{blastn} to BLAST all vs all using
#' a BLAST database
#' @param dbfl Database file
#' @param outfl Output file
#' @param ps Parameters
blstN <- function(dbfl, outfl, ps) {
  blst_d <- file.path(ps[['wd']], 'blast')
  if(!file.exists(blst_d)) {
    error(ps=ps, 'No `blast` dir in wd.')
  }
  outfl <- file.path(blst_d, outfl)
  dbfl <- file.path(blst_d, dbfl)
  if(!file.exists(dbfl)) {
    error(ps=ps, paste0('[', dbfl, '] does not exist. '))
  }
  outfmt <- "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovs qcovhsp"
  # Disable DUST filtering, limit to same-strang matching
  # TODO: We don't really need all these outfmt columns...
  args <- c('-query', dbfl, '-db', dbfl, '-outfmt', outfmt,
            '-dust', 'no', '-strand', 'plus', '-evalue', ps[['mxevl']],
            '-out', outfl)
  info(lvl=3, ps=ps, "Running blastn")
  res <- cmdLn(cmd=ps[['blstn']], args=args, lgfl=dbfl)
  if(res != 0) {
    error(ps=ps, 'blastn failed to run. Check BLAST log files.')
  }
  if(!file.exists(outfl)) {
    info(lvl=3, ps=ps, "No BLAST output, returning NULL")
    return(NULL)
  }
  if(file.info(outfl)[['size']]==0) {
    info(lvl=3, ps=ps, "No BLAST output, returning NULL")
    return(NULL)
  }
  blst_rs <- read.table(outfl)
  colnames(blst_rs) <- c('query.id', 'subject.id', 'identity',
                         'alignment.length', 'mismatches',
                         'gap.opens', 'q.start', 'q.end',
                         's.start', 's.end', 'evalue',
                         'bit.score', 'qcovs', 'qcovhsp')
  blst_rs
}

# FILTER NOTES
# First filter out HSPs with lower than min.coverage
# Get query-subject pairs with too low coverage
# Remove both, query-subject and subject-query pair of low coverage hits!!
# Otherwise, we will end up with clusters with uneven sequence lengths!
# TODO does it make a difference to filter for qcovhsp ??
#' @name fltrBlstRs
#' @title Filter BLAST results
#' @description Given a BLAST output, filters query-subject pairs such
#' that only HSPs with a coverage greater than \code{mncvrg} (specified
#' in the pipeline parameters) remain. Filters both: query-subject and
#' subject-query pairs, if one of the coverages is insufficient. HSP
#' coverage is obtained from the BLAST column \code{qcovs}.
#' @param blst_rs BLAST results
#' @param ps Parameters
fltrBlstRs <- function(blst_rs, ps) {
  pull <- blst_rs[['qcovs']] < ps[['mncvrg']]
  if(any(pull)) {
    # drop all with < mncvrg
    # ensure both qry-sbj and sbj-qry are dropped
    qsids <- blst_rs[pull, c('query.id', 'subject.id')]
    pull <- (blst_rs[['query.id']] %in% qsids[['subject.id']] &
      blst_rs[['subject.id']] %in% qsids[['query.id']]) | pull
  }
  ndrp <- sum(pull)
  info(lvl=3, ps=ps, "Removed [", ndrp, "/",
       nrow(blst_rs), "] BLAST hits due to insufficient coverage")
  if(sum(pull) > 0) {
    blst_rs <- blst_rs[!pull, ]
  }
  blst_rs
}
