# First live search in RStudio

## Download and open

On the repository page choose Code > Download ZIP, extract it and open the extracted folder in RStudio. Use Session > Set Working Directory > Choose Directory and select the folder containing README.md and protocol.md.

Run these commands in the RStudio console:

```r
install.packages(c("httr2", "jsonlite"))
source("R/00_search_europepmc.R")
source("R/01_prepare_records.R")
```

Install packages only once. The search requires internet access but no API key. Package versions and R session details are saved with the run.

## What the scripts do

The search requests core metadata (including available abstracts) from Europe PMC and follows cursor pagination. It saves the exact query, raw JSON pages, record counts, retrieval time and session details locally. If retrieval fails or counts do not match, it stops rather than presenting the result as complete.

The preparation script flags repeated DOIs and titles without deleting records. It creates a screening table with blank human decision fields. Both scripts refuse to overwrite their principal existing outputs.

## Send back the first result

After running, report the number of retrieved records and any error message. Do not screen yet: first inspect duplicate candidates and confirm that known relevant papers were retrieved.

If no records are returned, the search archive still contains the query and zero-result log. Do not run preparation until records exist.

## Limitations

This is a pilot search, not a complete systematic search. Europe PMC may omit environmental/ecological literature. Supplementary databases and citation searching remain necessary. Search terms are provisional; log amendments and their reasons.

No results have been generated or verified in the development environment, which has no R runtime. These scripts need their first live R execution on your computer. There is no model training or AI screening at this stage.

Raw responses, abstracts and reviewer files remain local under data/raw and data/processed, which Git ignores. Review provider and publisher terms before sharing texts.
