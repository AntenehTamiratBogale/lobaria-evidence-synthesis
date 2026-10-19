# Run from repository root. Install httr2 and jsonlite first.
# API documentation: https://europepmc.org/RestfulWebService
for (pkg in c("httr2", "jsonlite")) {
  if (!requireNamespace(pkg, quietly = TRUE)) stop("Install package: ", pkg)
}
if (!file.exists("protocol.md")) stop("Set working directory to the repository root.")
query <- '("Lobaria pulmonaria" OR "lung lichen") AND (light OR shading OR irradiance OR canopy OR nitrogen OR ammonium OR nitrate OR deposition)'
endpoint <- "https://www.ebi.ac.uk/europepmc/webservices/rest/search"
if (file.exists("data/raw/records.csv")) stop("records.csv already exists; archive it before a new search.")
run_id <- format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC")
run_dir <- file.path("data/raw", paste0("europepmc_", run_id))
if (dir.exists(run_dir)) stop("Run directory already exists.")
dir.create(run_dir, recursive = TRUE)
writeLines(query, file.path(run_dir, "query.txt"))
cursor <- "*"
seen <- character()
records <- list()
page <- 0L
expected <- NULL
repeat {
  if (cursor %in% seen) stop("Repeated cursor; incomplete run retained for inspection.")
  seen <- c(seen, cursor)
  req <- httr2::request(endpoint)
  req <- httr2::req_url_query(req, query = query, format = "json",
                              resultType = "core", pageSize = 1000,
                              cursorMark = cursor)
  req <- httr2::req_timeout(req, 120)
  req <- httr2::req_retry(req, max_tries = 4)
  resp <- httr2::req_perform(req)
  raw <- httr2::resp_body_string(resp)
  page <- page + 1L
  writeLines(raw, file.path(run_dir, sprintf("page_%03d.json", page)),
             useBytes = TRUE)
  obj <- jsonlite::fromJSON(raw, simplifyVector = FALSE)
  if (is.null(obj$hitCount)) stop("Missing hitCount; inspect saved response.")
  count <- as.integer(obj$hitCount)
  if (is.null(expected)) expected <- count
  if (!identical(count, expected)) stop("Result count changed during retrieval; rerun later.")
  batch <- obj$resultList$result
  if (is.null(batch)) batch <- list()
  records <- c(records, batch)
  if (length(records) >= expected) break
  next_cursor <- obj$nextCursorMark
  if (!length(batch) || is.null(next_cursor) || !nzchar(next_cursor) ||
      identical(next_cursor, cursor)) stop("Pagination ended before all records were retrieved.")
  cursor <- next_cursor
  Sys.sleep(0.25)
}
value <- function(r, key) {
  v <- r[[key]]
  if (is.null(v) || !length(v)) "" else as.character(v[[1L]])
}
columns <- c("title", "abstract", "doi", "year", "source", "source_id",
             "authors", "journal", "pmcid", "retrieved_at_utc")
if (length(records)) {
  x <- do.call(rbind, lapply(records, function(r) {
    data.frame(title = value(r, "title"), abstract = value(r, "abstractText"),
      doi = value(r, "doi"), year = value(r, "pubYear"),
      source = paste0("Europe PMC:", value(r, "source")),
      source_id = value(r, "id"), authors = value(r, "authorString"),
      journal = if (is.null(r$journalInfo$journal$title)) "" else r$journalInfo$journal$title,
      pmcid = value(r, "pmcid"), retrieved_at_utc = run_id,
      stringsAsFactors = FALSE)
  }))
} else {
  x <- as.data.frame(setNames(rep(list(character()), length(columns)), columns))
}
if (nrow(x) != expected) stop("Retrieved count differs from advertised hit count.")
if (anyDuplicated(paste(x$source, x$source_id))) stop("Repeated source identifiers; inspect raw pages.")
write.csv(x, file.path(run_dir, "records.csv"), row.names = FALSE, na = "",
          fileEncoding = "UTF-8")
log <- data.frame(search_id = run_id, source = "Europe PMC", search_date = run_id,
  exact_query = query, filters = "None explicitly applied",
  returned_count = expected, exported_count = nrow(x),
  export_filename = file.path(run_dir, "records.csv"),
  notes = "Single-source pilot; core metadata; raw responses retained")
write.csv(log, file.path(run_dir, "search_log.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")
writeLines(c(paste("Endpoint:", endpoint), capture.output(sessionInfo())),
           file.path(run_dir, "session_info.txt"))
if (nrow(x)) {
  if (!file.copy(file.path(run_dir, "records.csv"), "data/raw/records.csv",
                 overwrite = FALSE)) stop("Could not create records.csv.")
}
message("Retrieved ", nrow(x), " records. Search archive: ", run_dir)
message("Abstracts may contain markup; inspect them before screening.")
