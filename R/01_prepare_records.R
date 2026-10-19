# Run from the repository root with source("R/01_prepare_records.R").
# This script prepares records; it does not make eligibility decisions.
input <- "data/raw/records.csv"
out <- "data/processed"
if (!file.exists(input)) stop("Place your UTF-8 bibliographic export at ", input)
if (dir.exists(out) && length(list.files(out)) > 0L) {
  stop("Output folder is not empty. Archive previous outputs before rerunning.")
}
x <- read.csv(input, stringsAsFactors = FALSE, check.names = FALSE,
              colClasses = "character", na.strings = "", fileEncoding = "UTF-8")
required <- c("title", "abstract", "doi", "year", "source", "source_id")
if (!all(required %in% names(x))) {
  stop("Missing columns: ", paste(setdiff(required, names(x)), collapse = ", "))
}
if (nrow(x) == 0L) stop("The input contains no records.")
for (nm in required) {
  x[[nm]][is.na(x[[nm]])] <- ""
  x[[nm]] <- trimws(x[[nm]])
}
if (any(x$title == "")) stop("Every record needs a title.")
x$record_id <- sprintf("LP%05d", seq_len(nrow(x)))
doi <- tolower(x$doi)
doi <- sub("^https?://(dx\\.)?doi\\.org/", "", doi)
doi <- sub("^doi:[[:space:]]*", "", doi)
x$doi_normalized <- trimws(doi)
title_key <- tolower(gsub("[[:space:]]+", " ", trimws(x$title)))
# Flag rather than remove: matching titles can be different publications.
repeated <- function(v) nzchar(v) & (duplicated(v) | duplicated(v, fromLast = TRUE))
x$duplicate_doi <- repeated(x$doi_normalized)
x$duplicate_title <- repeated(title_key)
x$missing_abstract <- !nzchar(x$abstract)
screen <- x
screen$decision <- ""
screen$reason <- ""
screen$reviewer <- ""
screen$screened_on <- ""
dir.create(out, recursive = TRUE, showWarnings = FALSE)
write.csv(screen, file.path(out, "screening.csv"), row.names = FALSE, na = "",
          fileEncoding = "UTF-8")
write.csv(x[x$duplicate_doi | x$duplicate_title, , drop = FALSE],
          file.path(out, "duplicate_candidates.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")
writeLines(c(paste("Prepared:", format(Sys.time(), tz = "UTC")),
             paste("Input MD5:", unname(tools::md5sum(input))),
             paste("Records:", nrow(x)),
             paste("Duplicate candidates:", sum(x$duplicate_doi | x$duplicate_title)),
             paste("Missing abstracts:", sum(x$missing_abstract)),
             capture.output(sessionInfo())),
           file.path(out, "preparation_log.txt"))
message("Prepared ", nrow(x), " records. Review duplicate candidates before screening.")
