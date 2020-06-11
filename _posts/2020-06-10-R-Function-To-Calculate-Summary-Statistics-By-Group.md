---
layout: post
title:  "R Function To Calculate Summary Statistics By Group"
---

# R Function To Calculate Summary Statistics By Grouping Variables

Recently, I created a function called group_by_summary_stats() that quickly calculates basic summary stats  (e.g., N, mean, median, SD, SE, and range) for a single dependent variable for each combination of independent variables in a factorial design. The function uses several functions from the dplyr library, specifically the group_by() and summarise() functions, so you'll need to ensure you've install dplyr.

You can download the R function here <a href="/r/group_by_summary_stats.R" target="_blank"><i class="fa fa-file-text fa-md"></i></a> and load it into your R session using the source() function to begin using it:

```r
source("group_by_summary_stats.R")
```

As an example, let's use run the function to calculate some summary statistics on the CO2 data set included in R. Say we ran an experiment with two factors, called Plant and Type, and one dependent variable, called Amount (i.e., the amount of C02 consumed). 
Wen can easily summarize the amount of CO2 consumed for each combination of the Plant and Type factors by using group_by_summary_stats(). To do so, call group_by_summary_stats(), first passing in the data frame, then the dependent variable, and finally the names of any factors that correspond to experimental groups.

**Note:** Because of the way dplyr works, you must pass through the names of your grouping variables **without** quotation marks:

```r

data("CO2")
df <- CO2
head(df)

group_by_summary_stats(df, uptake, Type, Plant)

```

The output of running group_by_summary_stats() with the above arguments is a nice table that summarizes the Amount of C02 consumed for each combination of the Type and Plant factors: 
```r

# Groups:   Type [2]
   Type        Plant     N  Mean Median    SD    SE Range    
   <fct>       <ord> <int> <dbl>  <dbl> <dbl> <dbl> <chr>    
 1 Quebec      Qn1       7  33.2   35.3  8.21 3.10  16-39.7  
 2 Quebec      Qn2       7  35.2   40.6 11    4.16  13.6-44.3
 3 Quebec      Qn3       7  37.6   42.1 10.4  3.91  16.2-45.5
 4 Quebec      Qc1       7  30.0   32.5  8.33 3.15  14.2-38.7
 5 Quebec      Qc3       7  32.6   38.1 10.3  3.90  15.1-41.4
 6 Quebec      Qc2       7  32.7   37.5 11.3  4.28  9.3-42.4 
 7 Mississippi Mn3       7  24.1   27.8  6.48 2.45  11.3-28.5
 8 Mississippi Mn2       7  27.3   31.1  7.65 2.89  12-32.4  
 9 Mississippi Mn1       7  26.4   30    8.69 3.29  10.6-35.5
10 Mississippi Mc2       7  12.1   12.5  2.19 0.827 7.7-14.4 
11 Mississippi Mc3       7  17.3   17.9  3.05 1.15  10.6-19.9
12 Mississippi Mc1       7  18     18.9  4.12 1.56  10.5-22.2

```
