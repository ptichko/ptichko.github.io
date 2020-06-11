---
layout: post
title:  "R Function To Calculate Summary Statistics By Factor Levels"
---

# R Function To Calculate Summary Statistics For Each Combination of Factor Levels

Recently, I created a function called group_by_summary_stats() that quickly calculates basic summary stats  (e.g., N, mean, median, SD, SE, and range) for a single dependent variable for each combination of factor levels. 

**Note:** The function uses several functions from the dplyr library, specifically the group_by() and summarise() functions, so you'll need to ensure you've installed dplyr. You'll also need to have the stringr and tibble libraries installed.

You can download the R function here <a href="/r/group_by_summary_stats.R" target="_blank"><i class="fa fa-file-text fa-md"></i></a> and load it into your R session using the source() function:

```
source("group_by_summary_stats.R")
```

As an example, let's use the function to calculate some summary statistics on the CO2 dataset included with R. Imagine we ran an experiment with two factors, called Type and Plant, and one dependent variable, called uptake (i.e., the amount of C02 uptake). I want to quickly summarize the uptake of CO2 consumed for each combination of Plant and Type.
First, let's instantiate the CO2 dataset in R:
```
data("CO2")  
df <- CO2  
head(df)
```

We can easily summarize the uptake of CO2 for each combination of the Plant and Type factors by using group_by_summary_stats(). To do so, call group_by_summary_stats(), first passing through the data frame (df), then the name of the dependent variable (uptake), and finally the names of any factors (Type, Plant).
**Note:** Because of the way dplyr works, you must pass through the names of your variables **without** quotation marks:

```
group_by_summary_stats(df, uptake, Type, Plant)
```

The output of group_by_summary_stats() is a table that summarizes the uptake of CO2 consumed for each combination of the levels within the Type and Plant factors:

```
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
