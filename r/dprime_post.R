
#' Calculate D-Prime from D-Prime Summary Statistics
#'
#' Note: Must run dprime_pre.r first.
#' Calculates dprime from summary stats: hits, misses, false alarms, and correct rejections.
#' These columns must already be in the data frame that is passed in as an argument.
#'
#'
#' @param df is the data farm with columns corresonding to d-prime summary statistics
#' @param ... names of cols corresponding to IVs to group by (supports n > 1 cols). IVs must be factors.
#'
#' @return
#' @export
#'
#' @examples
#'
#' # make data frame
#' df<- data.frame(participant = c(rep("Participant 1",24), rep("Participant 2",24,),
#' rep("Participant 3",24), rep("Participant 4",24)),
#'                stim1 = rep(c(rep(c("Apple", "Orange", "Orange", "Apple"), 6),
#'                              rep(c("Orange", "Apple", "Apple", "Orange"), 6)),2),
#'                stim2 = rep(c(rep(c("Apple", "Orange", "Apple", "Orange"), 6),
#'                              rep(c("Orange", "Apple", "Apple", "Orange"), 6)),2),
#'                correct = c(rep(c(1,1,0,0),1), rep(c(1,0,1,0),1),
#'                            rep(c(0,0,1,1),2), rep(c(0,1,0,1),2),
#'                            rep(c(0,1,0,1),2), rep(c(0,0,1,1),2),
#'                            rep(c(1,0,1,0),1), c(rep(c(1,1,0,0),1))))
#'
#'
#' # reorder by participant
#' df <- df[order(df[,"participant"]),]
#'
#' # calculate dprime summary stats
#' df.dprime <- dprime_pre("stim1", "stim2", "correct", data = df)
#'
#' # calculate dprime
#' dprime_post(df.dprime, participant)
dprime_post <- function(df, ...){
  
  # Parker Tichko, 2020
  
  require(dplyr)
  require(tibble)

  # drops NAs
  na.rm = TRUE

  # quote input args to use with dplyr functions
  group_vars <- dplyr::quos(...)

  # convert to tibble, if not already tibble
  if(tibble::is_tibble(df) == FALSE){
    df <- tibble::as_tibble(df)}

  # group by df variables
  df <- dplyr::group_by(df,!!! group_vars)

  dplyr::summarise(df,
                   Hits = sum(dprime.Hit, na.rm = na.rm),
                   Misses = sum(dprime.Miss, na.rm = na.rm),
                   FalseAlarms = sum(dprime.FalseAlarm, na.rm = na.rm),
                   CorrectRejs = sum(dprime.CorrectRej, na.rm = na.rm),
                   Total = Hits + Misses + FalseAlarms + CorrectRejs,
                   HitRate = if(Hits/Total == 1 | Hits/Total ==  0){Hits/Total + 0.00001} else{Hits/Total}, # qunorm(1) & qnorm(0) are Inf. Increase HitRate and Missrate by 0.00001.
                   MissRate = if(Misses/Total == 1 |Misses/Total == 0){Misses/Total + 0.00001} else{Misses/Total}, # qunorm(1) & qnorm(0) are Inf. Increase HitRate and Missrate by 0.00001.
                   FalseAlarmRate = FalseAlarms/Total,
                   CorrectRejRate = CorrectRejs/Total,
                   Dprime = qnorm(HitRate) - qnorm(MissRate))

}
