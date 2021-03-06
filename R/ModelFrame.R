#' ModelFrame Class
#' 
#' Class for storing a data frame, formula, and optionally weights for fitting
#' MLModels.
#' 
#' @name ModelFrame
#' @rdname ModelFrame-methods
#' 
#' @param x model \code{\link{formula}} or \code{\link[recipes]{recipe}}.
#' 
#' @seealso \code{\link{formula}}, \code{\link[recipes]{recipe}},
#' \code{\link{na.fail}}, \code{\link{na.omit}}, \code{\link{na.pass}}
#' 
#' @examples
#' mf <- ModelFrame(ncases / (ncases + ncontrols) ~ agegp + tobgp + alcgp,
#'                  data = esoph, weights = ncases + ncontrols)
#' gbmfit <- fit(mf, model = GBMModel)
#' varimp(gbmfit)
#' 
ModelFrame <- function(x, ...) {
  UseMethod("ModelFrame")
}


#' @rdname ModelFrame-methods
#'
#' @param data data frame or an object that can be converted to one.
#' @param weights vector of case weights.
#' @param na.action action to take if cases contain missing values.  The default
#' is first any \code{na.action} attribute of \code{data}, second a
#' \code{na.action} setting of \code{\link{options}}, and third
#' \code{\link{na.fail}} if unset.
#' @param ... arguments passed to other methods.
#' 
ModelFrame.formula <- function(x, data, weights = NULL, na.action = NULL, ...) {
  data <- as.data.frame(data)
  
  modelterms <- terms(x, data = data)
  modelframe <- data[, all.vars(modelterms), drop = FALSE]
  
  weights <- eval(substitute(weights), data)
  if (!is.null(weights)) {
    stopifnot(length(weights) == nrow(data))
    modelframe[["(weights)"]] <- weights
  }
  
  if (is.null(na.action)) na.action <- na.action(data)
  if (is.null(na.action)) na.action <- get(getOption("na.action"))
  if (is.null(na.action)) na.action <- na.fail
  modelframe <- na.action(modelframe)
  
  attr(modelframe, "terms") <- modelterms
  class(modelframe) <- c("ModelFrame", "data.frame")
  modelframe
}


#' @rdname ModelFrame-methods
#'
ModelFrame.ModelFrame <- function(x, na.action = NULL, ...) {
  ModelFrame(formula(terms(x)), x, weights = model.weights(x),
             na.action = na.action)
}


#' @rdname ModelFrame-methods
#'
ModelFrame.recipe <- function(x, na.action = NULL, ...) {
  x <- prep(x, retain = TRUE)
  ModelFrame(formula(x), juice(x), na.action = na.action)
}
