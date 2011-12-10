years <- function(x) as.POSIXlt(x)$year + 1900

emptyDate <- function() as.Date(NA)[0]

is.wholenumber <- function(x) any(floor(x) == x)

