# -----------------------------------------------------------------------------
# 00_generate_data.R
# Generate a synthetic dataset mirroring an ENL conversational-behavior study.
#
# NO real human subjects. NO PHI. Everything below is simulated.
#
# Produces two raw CSVs in ./data :
#   - participants.csv : one row per participant (group + facial-behavior features)
#   - csq_items.csv    : raw Conversation Satisfaction Questionnaire item responses
#                        (wide, un-scored, with reverse-coded items and missingness)
#
# The two files are deliberately kept separate and "raw" so that analysis.qmd has
# a realistic cleaning/merging/scoring job to do.
# -----------------------------------------------------------------------------

suppressPackageStartupMessages(library(tidyverse))

set.seed(42)  # reproducibility

n <- 120  # participants

# ---- Group assignment --------------------------------------------------------
group <- sample(
  c("autistic", "non-autistic"),
  size = n, replace = TRUE, prob = c(0.5, 0.5)
)
group_num <- if_else(group == "autistic", 1L, 0L)

# ---- Facial action units (OpenFace-style mean intensities, ~0-5) -------------
# AU12 = lip corner puller (smiling); AU06 = cheek raiser (Duchenne marker);
# AU04 = brow lowerer. Smiling is modestly lower on average in the autistic group
# in this synthetic world (this is a *simulated* effect, not a claim about people).
au12_lip_corner_puller <- pmax(0, rnorm(n, mean = 2.4 - 0.5 * group_num, sd = 0.9))
au06_cheek_raiser       <- pmax(0, 0.7 * au12_lip_corner_puller + rnorm(n, 0, 0.4))
au04_brow_lowerer       <- pmax(0, rnorm(n, mean = 1.3 + 0.3 * group_num, sd = 0.7))

# ---- Smile reciprocity (0-1): share of participant smiles mirrored by partner
smile_reciprocity <- plogis(
  -0.2 + 0.6 * scale(au12_lip_corner_puller)[, 1] - 0.4 * group_num + rnorm(n, 0, 0.5)
)

# ---- Outcome: conversational success (continuous, ~0-100) --------------------
# Built-in ground truth: smiling + reciprocity help; there is a group x smiling
# interaction (smiling "pays off" a bit less strongly in the autistic group here).
conversational_success <- 50 +
  8.0 * scale(au12_lip_corner_puller)[, 1] +
  10.0 * scale(smile_reciprocity)[, 1] +
  -3.0 * scale(au04_brow_lowerer)[, 1] +
  -4.0 * group_num +
  -3.5 * scale(au12_lip_corner_puller)[, 1] * group_num +   # interaction
  rnorm(n, 0, 8)
conversational_success <- round(pmin(100, pmax(0, conversational_success)), 1)

participants <- tibble(
  participant_id = sprintf("ENL-%03d", seq_len(n)),
  group,
  au06_cheek_raiser       = round(au06_cheek_raiser, 3),
  au12_lip_corner_puller  = round(au12_lip_corner_puller, 3),
  au04_brow_lowerer       = round(au04_brow_lowerer, 3),
  smile_reciprocity       = round(smile_reciprocity, 3),
  conversational_success
)

# ---- Conversation Satisfaction Questionnaire (CSQ), 8 items ------------------
# Likert 1-5. Latent satisfaction correlates with conversational success.
# Items 3 and 7 are REVERSE-CODED (higher raw = LOWER satisfaction) so the
# cleaning step has to reverse them. We also inject a little missingness.
latent_sat <- scale(conversational_success)[, 1] + rnorm(n, 0, 0.7)

make_item <- function(loading, reverse = FALSE) {
  raw <- 3 + loading * latent_sat + rnorm(n, 0, 0.9)
  raw <- round(pmin(5, pmax(1, raw)))
  if (reverse) raw <- 6 - raw   # store as reverse-coded raw responses
  raw
}

csq <- tibble(
  participant_id = participants$participant_id,
  csq_1 = make_item(0.9),
  csq_2 = make_item(0.8),
  csq_3 = make_item(0.8, reverse = TRUE),   # reverse-coded
  csq_4 = make_item(0.7),
  csq_5 = make_item(0.9),
  csq_6 = make_item(0.6),
  csq_7 = make_item(0.7, reverse = TRUE),   # reverse-coded
  csq_8 = make_item(0.8)
)

# Inject ~3% missing responses across the item matrix (realistic questionnaire data)
item_cols <- setdiff(names(csq), "participant_id")
csq <- csq %>%
  mutate(across(all_of(item_cols), function(x) {
    x[runif(length(x)) < 0.03] <- NA_integer_
    x
  }))

# ---- Write out ---------------------------------------------------------------
dir.create("data", showWarnings = FALSE)
write_csv(participants, "data/participants.csv")
write_csv(csq,          "data/csq_items.csv")

message("Wrote data/participants.csv (", nrow(participants), " rows) and ",
        "data/csq_items.csv (", nrow(csq), " rows).")
message("Reverse-coded items: csq_3, csq_7.")
