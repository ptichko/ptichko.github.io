---
layout: post
title:  "Modeling Google Scholar Citations Mined With the Scholar Library"
---

# Mining Google Scholar Data With The Scholar Libary

In this post, I show how the [scholar](https://cran.r-project.org/web/packages/scholar/index.html) library can be used to explore historical citation data archived on Google Scholar in R. Using the scholar library, we import citation-related data, beginning for the year 1982, for two of the most important physists of the 20th century -- Stephen Hawking and Richard Feynman -- and examine how their total citations evolved over time. For added fun, we fit a non-linear, exponential regression model to model their respective trends of citations over time.

First, we load the scholar library, locate the identifcation numbers for Hawking and Feynman (the identification numbers for authors on Google Scholar can be located in the URL for the author's Google Scholar page) and use the compare_scholar_careers() function to import citation data for Hawking and Feynman beginning in the year 1982.

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


# Estimating a Non-Linear Model for Stephen Hawking's and Richard Feinman's Citation History

From plotting the data, the total citations from Hawking and Feinman both appear to follow an expoential trend over their citation history. We can try fitting an exponential regression model and assess model fit. We use the nls() in R for fitting non-linear models, we specify our formula for an expontential model and supply starting parameters for the optimization procedure that are derived from a simple linear regression model.

```

# Fit expontential model to Feynman

df.1 <- df %>%
  filter(name == "Richard Feynman") %>%
  filter(career_year != max(career_year)) 

plot(df.1$career_year, df.1$cites)


fm_lm <- lm(cites.log ~ career_year, data = df.1) # linear regression to get starting coefficients
st <- list(a = exp(coef(fm_lm)[1]), b = coef(fm_lm)[2]) # intercept and slop coefficients
m <- nls(cites ~ I(a*exp(b*career_year)), data=df.1, start=st, trace=T) # non-linear regression with least squares

dy_est<-predict(m,df.1$career_year)
plot(df.1$career_year,df.1$cites)
lines(df.1$career_year,dy_est)
summary(m)



```


<p align="center">
  <img src="/img/feynmanmodel.png"/>
</p>


```
# Fit expontential model to Hawking

df.1 <- df %>%
  filter(name == "Stephen Hawking") %>%
  filter(career_year != max(career_year)) 

plot(df.1$career_year, df.1$cites)


fm_lm <- lm(cites.log ~ career_year, data = df.1) # linear regression to get starting coefficients
st <- list(a = exp(coef(fm_lm)[1]), b = coef(fm_lm)[2]) # intercept and slop coefficients
m <- nls(cites ~ I(a*exp(b*career_year)), data=df.1, start=st, trace=T) # non-linear regression with least squares

dy_est<-predict(m,df.1$career_year)
plot(df.1$career_year,df.1$cites)
lines(df.1$career_year,dy_est)
summary(m)

```
<p align="center">
  <img src="/img/hawkingmodel.png"/>
</p>
