---
layout: post
title:  "Exploring Google Scholar Citations With the Scholar Library"
---

# Exploring Google Scholar Data With The Scholar Libary

In this post, I show how the [scholar](https://cran.r-project.org/web/packages/scholar/index.html) library can be used to explore historical citation data archived on Google Scholar in R. Using the scholar library, we import citation-related data, beginning in the year 1982, for two of the most important physicists of the 20th century -- Stephen Hawking and Richard Feynman -- and examine how their total citations evolved over time. For added fun, we fit a non-linear, exponential regression model to model their respective trends of citations over time.

First, we load the scholar library, locate the identification numbers for Hawking and Feynman (the identification numbers for authors on Google Scholar can be located in the URL for the author's Google Scholar page), and use the compare_scholar_careers() function to import citation data for Hawking and Feynman beginning in the year 1982 and up to the most recent year.

```
library(scholar)
library(tidyverse)


#  Richard Feynman's and Stephen Hawking's IDs
ids <- c("B7vSqZsAAAAJ", "qj74uXkAAAAJ")

# Import Google Scholar data
df <- compare_scholar_careers(ids)


head(df)
            id year cites career_year            name
1 B7vSqZsAAAAJ 1982   581           0 Richard Feynman
2 B7vSqZsAAAAJ 1983   605           1 Richard Feynman
3 B7vSqZsAAAAJ 1984   657           2 Richard Feynman
4 B7vSqZsAAAAJ 1985   644           3 Richard Feynman
5 B7vSqZsAAAAJ 1986   726           4 Richard Feynman
6 B7vSqZsAAAAJ 1987   718           5 Richard Feynman




```
Plotting the total number of citations since 1982 (here normalizing the year 1982 as the start of the career), we observe a positive trend in citations that appears to rise in an exponential manner. Moreover, at least from 1982, Hawking appears to eclipse Feynman in terms of absolute number of total citations.

<p align="center">
  <img src="/img/feynmanhawking.png"/>
</p>


## Estimating a Non-Linear Model for Stephen Hawking's and Richard Feinman's Citation History

From plotting the data, the total citations from Hawking and Feinman both appear to follow an exponential trend over the course of their citation history. We can try fitting an exponential regression model for each author and estimate parameters for the models. We use the nls() in R for fitting non-linear models, where we can specify our formula for an expontential model and supply starting parameters for the optimization procedure that are derived from a simple linear regression model. Finally, we plot the prediction of the model against the citation data from Google Scholar.

```
# Fit exponential model to Feynman

df.1 <- df %>%
  filter(name == "Richard Feynman") %>%
  filter(career_year != max(career_year)) # remove latest year


fm_lm <- lm(cites.log ~ career_year, data = df.1) # linear regression to get starting coefficients
st <- list(a = exp(coef(fm_lm)[1]), b = coef(fm_lm)[2]) # intercept and slope coefficients
m <- nls(cites ~ I(a*exp(b*career_year)), data=df.1, start=st, trace=T) # non-linear regression with least squares

dy_est<-predict(m,df.1$career_year) # save model predictions

# Summary
summary(m)

Formula: cites ~ I(a * exp(b * career_year))

Parameters:
   Estimate Std. Error t value Pr(>|t|)    
a 7.194e+02  4.138e+01   17.39   <2e-16 ***
b 5.217e-02  1.876e-03   27.81   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 248.5 on 37 degrees of freedom

Number of iterations to convergence: 5 
Achieved convergence tolerance: 7.981e-06


# coefficients
coef(m)
           a            b 
719.37917740   0.05217138

```
The exponential model was a signiciant fit to the Feynman data, and the estimated parameters for the exponential model were also found to be significant. Visualizing the data against the model prediction, we find that the model (denotd by the pink dashed line) adequately captures the exponential trend.

<p align="center">
  <img src="/img/feynmanmodel.png"/>
</p>


Repeating the same process for the Hawking data, we get:

```
# Fit exponential model to Hawking

df.1 <- df %>%
  filter(name == "Stephen Hawking") %>%
  filter(career_year != max(career_year)) # remove latest year


fm_lm <- lm(cites.log ~ career_year, data = df.1) # linear regression to get starting coefficients
st <- list(a = exp(coef(fm_lm)[1]), b = coef(fm_lm)[2]) # intercept and slope coefficients
m <- nls(cites ~ I(a*exp(b*career_year)), data=df.1, start=st, trace=T) # non-linear regression with least squares

dy_est<-predict(m,df.1$career_year) # save model predictions

# Summary
summary(m)


Formula: cites ~ I(a * exp(b * career_year))

Parameters:
   Estimate Std. Error t value Pr(>|t|)    
a 8.240e+02  2.725e+01   30.24   <2e-16 ***
b 5.379e-02  1.073e-03   50.15   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 167.9 on 37 degrees of freedom

Number of iterations to convergence: 4 
Achieved convergence tolerance: 7.586e-07


# Coefficients
           a            b 
823.96882888   0.05378992 

```
Similar to the Feynman model, the exponential model significantly fit the Hawking data, and the estimated parameters for the exponential model were also significant. Visualizing the data against the model prediction, we find that the Hawking model (denoted by the pink dashed line) also captures the exponential trend.


<p align="center">
  <img src="/img/hawkingmodel.png"/>
</p>
