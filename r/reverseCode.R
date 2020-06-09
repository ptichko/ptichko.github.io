#' Reverse codes a Likert scale
#'
#' @param x is a scalar from or a vector of Likert scores to reverse code
#' @param min is the minimum value of the Likert scale
#' @param max is the maxium value of the Likert scale
#'
#' @return
#' @export
#'
#' @examples
#' reverseCode(2, min = 1, max = 5) # reverse code "2" to a "4" on a Likert scale of 1-5
#' reverseCode(2:7, min = 2, max = 7) # reverse code a vector of scores on a Likert scale of 2-7
#' reverseCode(1, min = 0, max = 1) # reverse code binary response
#'
reverseCode <- function(x, min = 1, max = 5){

  # Written by Parker Tichko, May 2020
  # Email: my first name DOT my last name @ gmail.com

  if(min(x, na.rm = TRUE) < min | max(x, na.rm = TRUE) > max){
    warning("Warning: input is outside the range of the scale.")
  }

  sort(min:max, decreasing = TRUE)[x+(1-min)]

}
