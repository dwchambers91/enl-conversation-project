# Learning R with a Behavioral Dataset

A practice project where I taught myself the basics of R and RStudio, working with a
small **synthetic** dataset modeled on the kind of research done at CHOP's Center for
Autism Research studying facial expression and conversational behavior in autistic
and non-autistic adolescents.

I built this to get hands-on with the everyday data tasks a clinical research role
involves: loading a data file, checking it, computing summary statistics, comparing
groups, and producing a chart.

> **All data here are synthetic** (`data/practice_data.csv`) no real participants,
> no protected health information. It's practice data I used to learn the tools.

---

## What I did

Working one command at a time in RStudio, I:

- Loaded a CSV into R and inspected it (`read.csv`, `head`, `str`, `summary`)
- Computed descriptive statistics — mean, min, max, standard deviation
- Calculated group averages (`aggregate`)
- Ran a **two-sample t-test** to compare conversation-success scores between groups
- Produced and saved a labeled **boxplot** (`conv_success_plot.png`)
- Put the whole project under version control with Git and published it to GitHub

The result: the non-autistic group scored meaningfully higher on conversation success
than the autistic group, and the t-test confirmed the difference was statistically
significant (this is a designed feature of the synthetic data, so finding it was a way
to check my analysis was working).

## Files in this repo

| File | What it is |
|------|-----------|
| `practice_analysis.R` | My analysis script the code I wrote and ran, step by step |
| `data/practice_data.csv` | The synthetic practice data set |
| `conv_success_plot.png` | The chart I produced |
| `analysis.qmd` | In progress report exploring the same question in more depth. I'm using it to keep learning beyond the basics |
| `R/00_generate_data.R` | Script that generates a larger synthetic dataset for `analysis.qmd` |

## How to reproduce

With [R] installed, open `practice_analysis.R` in
RStudio and run it top to bottom. It uses only base R, no extra packages needed.
(Update the file path at the top to wherever you saved the folder.)

## What I'm learning next

- The `tidyverse` (`dplyr`, `ggplot2`) — the modern toolkit for R data work
- Reproducible reports with Quarto (the direction `analysis.qmd` is headed)

---

*Skills practiced: R · RStudio · descriptive statistics · t-tests · data visualization · Git/GitHub · working with de-identified/synthetic data.*
