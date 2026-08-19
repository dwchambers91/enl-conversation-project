# ==============================================================================
# practice_analysis.R
#
# Basic analysis of conversational behavior data.
# Data are SYNTHETIC (practice_data.csv) - no real participants, no PHI.
#
# Run this top to bottom, or one line at a time with Ctrl+Enter.
# ==============================================================================


# ---- 1. Load the data --------------------------------------------------------
# Note the FORWARD slashes - R does not accept Windows backslashes in paths.

dat <- read.csv("C:/Users/Doug/enl-conversation-project/data/practice_data.csv")


# ---- 2. Look at it -----------------------------------------------------------

head(dat)   # first 6 rows
str(dat)    # column names + data types (check numbers read in as numbers)
View(dat)   # spreadsheet-style viewer (capital V)


# ---- 3. Descriptive statistics -----------------------------------------------

mean(dat$conv_success)   # average across everyone
min(dat$conv_success)    # lowest score
max(dat$conv_success)    # highest score
sd(dat$conv_success)     # standard deviation (spread)

summary(dat)             # quick summary of every column at once


# ---- 4. Averages by group ----------------------------------------------------
# Read "conv_success ~ group" as "conversation success BY group".

aggregate(conv_success ~ group, data = dat, FUN = mean)
aggregate(au12_smile   ~ group, data = dat, FUN = mean)


# ---- 5. Is the group difference statistically significant? -------------------
# Look for the p-value. p < 0.05 is the conventional cutoff for "significant".

t.test(conv_success ~ group, data = dat)


# ---- 6. Chart, saved to a PNG file -------------------------------------------
# png() opens the file, boxplot() draws into it, dev.off() closes and saves it.

png("C:/Users/Doug/enl-conversation-project/conv_success_plot.png",
    width = 800, height = 600)

boxplot(conv_success ~ group, data = dat,
        main = "Conversation success by group",
        ylab = "Conversation success",
        xlab = "Group",
        col  = c("#D95F0E", "#2C7FB8"))   # autistic = orange, non-autistic = blue

dev.off()   # prints "null device" / TRUE when it saves successfully
