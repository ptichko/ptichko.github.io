---
layout: post
title:  "Pipeline To Calculate D-Prime in R"
---

# Pipeline To Calculate D-Prime in R

One efficient way to calculate d-prime in R is to use the [dprime() function](https://www.rdocumentation.org/packages/psycho/versions/0.6.1/topics/dprime) from the psycho library. Prior to using the dprime() function, however, the user must calculate the total numbers of hits, misses, false alarms, and correct rejections for each participant in their experiment. This can be quite cumbersome. For a recent project, I automated this process by writing two R functions that label whether a trial in a experiment is a hit, miss, false alarm, or correct rejection, and tally up the total number of hits, misses, false alarms, and correction rejections by particpant. (Originally, I had intended to write my own custom R functions to directly calculate d-prime using tidyverse functions, but with feedback from Karim Rivera, who found an error with my original approach, I decided to modify my functions to just compute d-prime labels and subscores and leave the direct calculation of d-prime statistics to the psycho library, which is much more flexible method than what I had written.)
Once the total number of hits, misses, false alarms, and correct rejections are calculated for each participant, the dprime() function from the psycho library can be used to calculate several d-prime statistics related to sensitivity and bias.

You can download the R functions here <a href="/r/dprime_lab.R" target="_blank"><i class="fa fa-file-text fa-md"></i></a> and here <a href="/r/dprime_cat.R" target="_blank"><i class="fa fa-file-text fa-md"></i></a>, then load them into your R session using the source() function:

**Note:** The dprime_cat() function requires the dplyr and tibble libraries.
```
source("dprime_lab.R") # label individual trials (i.e., rows in a data frame) as a hit, miss, false alarm, or correct rejection
source("dprime_cat.R") # total number of hits, misses, false alarms, and correct rejections for each participant
```

As an example, let's create a data frame reflecting a hypothetical cognitive task. Imagine we ran an experiment where participants were presented with two images, called "stim1" and "stim2," and they had to determine if the two images were the same or different after a delay period (i.e., a delayed match-to-sample task). The dependent variable, stored in the column "correct," is whether the particpants correctly determined whether the two images were the same or different for a given trial: 0 means an incorrect response, while 1 denotes a correct response.

```
# Create a data frame
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

# View first rows of data frame 
head(df)
    participant  stim1  stim2 correct
1 Participant 1  Apple  Apple       1
2 Participant 1 Orange Orange       1
3 Participant 1 Orange  Apple       0
4 Participant 1  Apple Orange       0
5 Participant 1  Apple  Apple       1
6 Participant 1 Orange Orange       0
```

First, we can use dprime_lab() to label each trial as a hit, miss, false alarm, or correct rejection. The function returns a data frame with new columns that summarizes whether a particular trial was a hit, miss, false alarm, or correct rejection.  
Start by calling dprime_lab() and passing through the name of the column with the first image, "stim1", the name of the column with the second image, "stim2", then the name of the column with the dependent variable, "correct", and finally the name of the data frame.

```
# Calculate correct rejections, hits, misses, and false alarms
df.dprime <- dprime_lab("stim1", "stim2", "correct", data = df)

# View first rows of data frame, now with d-prime labels
head(df.dprime)
    participant  stim1  stim2 correct CorrectRej Miss FalseAlarm Hit
1 Participant 1  Apple  Apple       1          1   NA         NA  NA
2 Participant 1 Orange Orange       1          1   NA         NA  NA
3 Participant 1 Orange  Apple       0         NA    1         NA  NA
4 Participant 1  Apple Orange       0         NA    1         NA  NA
5 Participant 1  Apple  Apple       1          1   NA         NA  NA
6 Participant 1 Orange Orange       0         NA   NA          1  NA
```

Next, run dprime_cat() to calculate the total number of hits, misses, false alarms, and correct rejections for each participant. Call dprime_cat(), pass through the dataframe with d-prime labels, and then pass through "participant" column (without quotes).
**Note:** Because this function uses dplyr, you must pass through the names of your variables **without** quotation marks:

The output is a tibble that summarizes the the number of correct rejections, hits, misses, and false alarms for each participant:
```
# Calculate total number of hits, misses, false alarms, and correct rejections for each participant
df.cat <- dprime_cat(df.dprime, participant)

head(df.cat)
# A tibble: 4 x 8
  participant    Hits Misses FalseAlarms CorrectRejs TotalTarg TotalDis NumRes
  <chr>         <dbl>  <dbl>       <dbl>       <dbl>     <dbl>    <dbl>  <dbl>
1 Participant 1     7      5           7           5        12       12     24
2 Participant 2     0      0          12          12         0       24     24
3 Participant 3     7      5           7           5        12       12     24
4 Participant 4     0      0          12          12         0       24     24
```

Finally, you can pass individual columns from the tibble outputted by the dprime_cat() function to the dprime() function from the psycho library to compute d-prime statistics:

```
# Finally, use psycho::d-prime to calculate d-prime stats
dprime.stats<-psycho::dprime(df.cat$Hits,df.cat$FalseAlarms, df.cat$Misses, df.cat$CorrectRejs)

# Add d-prime values into df
df.cat$dprime <- dprime.stats$dprime


head(df.cat) # note, in this example all d-prime values are 0
# A tibble: 4 x 9
  participant    Hits Misses FalseAlarms CorrectRejs TotalTarg TotalDis NumRes dprime
  <chr>         <dbl>  <dbl>       <dbl>       <dbl>     <dbl>    <dbl>  <dbl>  <dbl>
1 Participant 1     7      5           7           5        12       12     24      0
2 Participant 2     0      0          12          12         0       24     24      0
3 Participant 3     7      5           7           5        12       12     24      0
4 Participant 4     0      0          12          12         0       24     24      0

```

