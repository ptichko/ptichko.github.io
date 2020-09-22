---
layout: post
title:  "R Functions To Calculate D-Prime"
---

# R Functions To Calculate D-Prime

For a recent project, I needed to calculate d-prime statistics in R. But also as an exercise to write functions using base R and the tidyverse. 

**Note:** The dprime_post() function requires the dplyr and tibble libraries.

You can download the R functions here <a href="/r/dprime_pre.R" target="_blank"><i class="fa fa-file-text fa-md"></i></a> and here <a href="/r/dprime_post.R" target="_blank"><i class="fa fa-file-text fa-md"></i></a>, then load them into your R session using the source() function:

```
source("dprime_pre.R") # d-prime pre-processing
source("dprime_post.R") # d-prime post-processing
```

As an example, let's create a dataframe reflecting a hypothetical cognitive task. Imagine we ran an experiment where participants were presented with two images, called "stim1" and "stim1," and they had to determine if the two images were the same or different after a delay period (i.e., a delayed match-to-sample task). The dependent variable, stored in the column "correct," is whether the particpants correctly determined whether the two images were the same or different for a given trial: 0 means an incorret response, while 1 means a correct response.

```
# Create a mock dataframe
df<- data.frame(participant = c(rep("Participant 1",24), rep("Participant 2",24,), rep("Participant 3",24), rep("Participant 4",24)),
           stim1 = rep(c(rep(c("Apple", "Orange", "Orange", "Apple"), 6),
                     rep(c("Orange", "Apple", "Apple", "Orange"), 6)),2),
           stim2 = rep(c(rep(c("Apple", "Orange", "Apple", "Orange"), 6),
                     rep(c("Orange", "Apple", "Apple", "Orange"), 6)),2),
           correct = c(rep(c(1,1,0,0),1), rep(c(1,0,1,0),1),
                       rep(c(0,0,1,1),2), rep(c(0,1,0,1),2),
                       rep(c(0,1,0,1),2), rep(c(0,0,1,1),2),
                       rep(c(1,0,1,0),1), c(rep(c(1,1,0,0),1))))
					   
					   
# Reorder by participant
df <- df[order(df[,"participant"]),] 
 
head(df)
```

First, we can use dprime_pre() to calculate d-prime sub-categories for each trial. The function returns a datafarme with new columns that summarizes whether a particular trial was a correct rejection, hit, miss, or false alarm.  
To do so, call dprime_pre(), first passing through the name of the column with the first image, "stim1", the name of the column with the second image, "stim2", then the name of the column with the dependent variable, "correct", and finally the name of the dataframe.

```
# Calculate correct rejections, hits, misses, and false alarms
df.dprime <- dprime_pre("stim1", "stim2", "correct", data = df)

# View first rows of dataframe, now with d-prime statistics
head(df.dprime)
    participant  stim1  stim2 correct dprime.CorrectRej dprime.Miss dprime.FalseAlarm dprime.Hit
1 Participant 1  Apple  Apple       1                 1          NA                NA         NA
2 Participant 1 Orange Orange       1                 1          NA                NA         NA
3 Participant 1 Orange  Apple       0                NA           1                NA         NA
4 Participant 1  Apple Orange       0                NA           1                NA         NA
5 Participant 1  Apple  Apple       1                 1          NA                NA         NA
6 Participant 1 Orange Orange       0                NA          NA                 1         NA

```

Next, we can use the sub-categories computed by dprime_pre() to calculate our d-prime scores for each participant. Call dprime_post() pass through the dataframe with d-prime subcategories, and then "participant" column (without quotes).
**Note:** Because of the way dplyr works, you must pass through the names of your variables **without** quotation marks:

The output is a tibble that summarizes the d-prime score and the rates of correct rejections, hits, misses, and false alarms for each participant. Note how dprime_post() also correctly handles a d-prime score of 0 by adding a small non-zero number to the HitRate and MissRate, if these are equal to 0.
```
# Calculate d-prime scores for each participant.
dprime_post(df.dprime, participant)

> dprime_post(df.dprime, participant)
# A tibble: 4 x 11
  participant    Hits Misses FalseAlarms CorrectRejs Total HitRate MissRate FalseAlarmRate CorrectRejRate Dprime
  <fct>         <dbl>  <dbl>       <dbl>       <dbl> <dbl>   <dbl>    <dbl>          <dbl>          <dbl>  <dbl>
1 Participant 1     7      5           7           5    24 0.292    0.208            0.292          0.208  0.264
2 Participant 2     0      0          12          12    24 0.00001  0.00001          0.5            0.5    0    
3 Participant 3     7      5           7           5    24 0.292    0.208            0.292          0.208  0.264
4 Participant 4     0      0          12          12    24 0.00001  0.00001          0.5            0.5    0    
```
