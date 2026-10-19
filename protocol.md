# Draft pilot protocol

Version 0.1 — 19 October 2026. Finalize before screening; record subsequent changes with dates and reasons.

## Question and scope

How do light availability and nitrogen enrichment affect the physiology, symbiotic partners and microbial communities of *Lobaria pulmonaria*?

Population: *L. pulmonaria*, including identifiable symbiotic partners studied in connection with this species.
Exposure: light intensity, shading, canopy openness, nitrogen addition or nitrogen deposition.
Comparator: a control, another exposure level or a measured environmental gradient.
Outcomes: physiological, growth, photosynthetic, biochemical, molecular or microbial-community responses.

Include empirical field, laboratory and observational studies meeting these criteria. Record design and distinguish association from experimental effects. Include studies addressing either exposure; both are not required.

Exclude unrelated species with no separately extractable *L. pulmonaria* evidence, studies without a relevant exposure, and non-empirical publications. Retain reviews separately for background and citation searching. At title/abstract stage retain uncertain records for full-text review. Missing abstracts are not grounds for exclusion.

No initial publication-year restriction. Record language and translation needs rather than excluding silently. Do not claim an exhaustive systematic review from a convenience sample or a single database.

## Search plan

Draft concept: ("Lobaria pulmonaria" OR "lung lichen") AND (light OR shading OR irradiance OR canopy OR nitrogen OR ammonium OR nitrate OR deposition).

Adapt syntax to each database; preserve exact executed strings. Log source, date, filters, returned count and exported count in templates/search_log.csv. Supplement with backward and forward citation searching. Check retrieval of known relevant studies. Database coverage and access limitations must be reported.

Do not broaden eligibility solely to improve model performance. If records are scarce, amend the question transparently or evaluate a smaller pilot with explicit uncertainty.

## Screening

Pilot the criteria on 20 records and clarify ambiguities before the main screening. Use include/exclude/uncertain, a reason and reviewer identifier. Keep human decisions separate from model predictions. Independent assessment of a subset by another reviewer is desirable; if unavailable, report single-reviewer limitations.

Title/abstract inclusion means proceed to full text, not final eligibility. Record full-text exclusion reasons. Search records, publications and underlying studies are different units.

## Extraction

For eligible full texts record citation/DOI, study identifier, country/site, design, sample size, light exposure, nitrogen form/dose/duration, comparator, symbiotic partner, outcome, units, estimate and uncertainty. Attach a supporting passage and page/table reference to each extracted result. Use not_reported when absent; never infer an unreported value.

## Automation evaluation (planned)

Freeze a held-out set before feature fitting, prompt tuning or threshold selection. Keep duplicate publications and records from the same study in the same partition. Fit text vocabulary/TF-IDF and all learned transformations on training data only.

Evaluate precision, recall, confusion counts and uncertainty on held-out human labels. Define the positive class as retain for full-text assessment. Preserve uncertain human labels for adjudication rather than converting them silently. Report eligible-record prevalence and missed relevant studies. A tiny or single-class dataset may not support training or useful evaluation.

Log model/provider/version, dates, prompts, parameters and raw responses. Treat abstracts and documents as untrusted input. Verify extraction against cited passages. No automatic final exclusion. Do not claim time savings without measuring manual and automated work, including verification.
