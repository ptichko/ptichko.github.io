---
layout: post
title:  "R Function to Reverse Code a Likert Scale"
---

# An R Function to Reverse Code a Likert Scale

A recent research project required that I reverse code several items on a questionnaire before scoring the questionnaire. Reverse coding is neccessary when certain items on a questionnare are negatively worded, such that a low value really corresponds to a high value. Ideally, before conducting any sort of analysis, we should ensure that the direction of low and high values across all questionnaire items is uniform.

You can download the R function here <a href="/r/reverseCode.R" target="_blank"><i class="fa fa-file-text fa-md"></i></a> and load it into your R session using the source() function. See below for an example:

```r
source("reverseCode.R")
```

This R function allows a user to reverse code a scalar or vector of scores using a user-specified, Likert-scale range. By default, the function uses a 1-to-5 Likert scale. (However, this can be changed. See examples below.) First, let's use the function to reverse code a response of "2" on 1-to-5 Likert Scale (i.e., reverse code "2" to a "4") using the function's default settings:


```r
reverseCode(2) # reverse code "2" to a "4" on a Likert scale of 1-5
```

Now, let's reverse code a vector of scores, containing scores sequentially increasing from 2 to 7, on a Likert scale of 1-to-7. We can use the "min" and "max" arguments to define the range of our Likert scale. Here, we'll set the min = 1 and the max = 7 to reflect a Likert scale from 1 to 7. We'll pass through 2:7, reflecting a vector of scores ranging from 2 to 7:


```r
reverseCode(2:7, min = 1, max = 7) # reverse code a vector of scores on a Likert scale of 1-7
```

We can also use the function to reverse code binary reponses. For instance, let's assume we have a binary response of 0 and 1. Let's reverse code a score of "1" to a "0" by setting the "min" and "max" arguments to 0 and 1, respectively: 

```r
reverseCode(1, min = 0, max = 1) # reverse code binary response
```


