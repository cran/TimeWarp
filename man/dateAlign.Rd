\name{dateAlign}
\alias{dateAlign}
\title{Date alignment}
\description{
  Align a date vector the a day, bizday, month, week or year boundary.
  \code{dateAlign()} is a generic, with
  methods for \code{character}, \code{Date}, \code{POSIXct}, and \code{POSIXlt}.
}
\usage{
dateAlign(x, by = "days", k.by = 1, direction = 1, week.align = NULL, holidays = NULL, silent = FALSE)
}
\arguments{
  \item{x}{
    \code{\link{Date}} vector, or a character vector that can be
    converted to \code{\link{Date}} by \code{\link{dateParse}}.
  }
  \item{by}{
    character string with the time unit of the time period.
    Can be one of \code{"days"}, \code{"bizdays"},\code{"weeks"},
    \code{"months"}, or \code{"years"}.
  }
  \item{k.by}{
    positive integer giving the number of the \code{by} units to align
    to. Ignored for \code{"bizdays"} and \code{"weeks"}.
}
  \item{direction}{
    integer with either -1 or 1, to align to the previous or next time
    that is an integer number of the \code{k.by} * \code{by} units.
  }
  \item{week.align}{
    if not NULL, and \code{by} is \code{"weeks"}, an integer, 0 to 6
    with 0 being Sunday, to specify a weekday to align to.
  }
  \item{holidays}{
    character string naming the holiday series (see
    \code{\link{holidays}}).
  }
  \item{silent}{
    logical indicating whether or not to suppress warnings about arguments.
  }
}
\value{
  Date vector whose elements are moved up or down (according to
  \code{direction}) so that they lie on integer multiples of
  \code{k.by} * \code{by} units of time starting from the beginning of
  the next bigger time unit (e.g. if
  \code{by = "days"}, then align to multiples of \code{k.by} days
  added to the first of the month. Note that for \code{"weeks"},
  and \code{"bizdays"}, \code{k.by} is assumed to be 1 and ignored;
  \code{"weeks"} without \code{week.align} is equivalent
  to "days". Also note that \code{k.by} should be a divisor of the
  number of \code{by} units in the next larger time unit,
  or NA values will result.
  The class of the returned value is the same as the class of \code{x}
  for \code{character}, \code{Date}, \code{POSIXct}, and
  \code{POSIXlt}.  For \code{x} of other classes, the class of the
  returned value is \code{Date}, but this may change in the future.
}
\author{Lars Hansen, Tony Plate}
\note{
  Alignment of dates can be thought of as a partition on date sequences
  where an input date is aligned to the first date in a partition, if it is not
  already aligned. The direction of alignment determines which partition to use for
  the alignment. If the direction is -1 then alignment happens in the partition which
  the date falls in. If +1 then alignment happens in the partition just after the
  partition in which the dates falls.
}

\seealso{
  \code{\link{dateShift}},
  \code{\link{dateWarp}},
  \code{\link{dateMatch}},
  \code{\link{dateParse}},
  \code{\link{dateSeq}}
}
\examples{
dateAlign("2007/12/06", by = "days", k.by = 4, direction = -1)
date <- as.Date("2009/1/1") + -5:5
dateAlign(date, by = "days", silent = FALSE)
dateAlign(date, by = "days", k.by = 3, direction = -1)
dateAlign(date, by = "bizdays", k.by = 1, direction = 1)
library(Holidays)
dateAlign(date, by = "bizdays", k.by = 1, direction = 1, holidays =
"NYSEC")
dateAlign(date, by = "months", k.by = 2, direction = -1)
dateAlign(date, by = "years", k.by = 3, direction = -1)
}
\keyword{utilities}
