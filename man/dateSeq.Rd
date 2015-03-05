\name{dateSeq}
\alias{dateSeq}
\title{Create a sequence of Dates}
\description{
Generate a sequence of dates. Based on \code{\link{seq.Date}}, but adds support for business day and holiday sequencing.
  \code{dateSeq()} is a generic, with
  methods for \code{character}, \code{Date}, \code{POSIXct}, and \code{POSIXlt}.
}
\usage{
dateSeq(from = NULL, to = NULL, year = NULL,
        by = "days", k.by = 1, length.out = NULL,
        holidays = NULL, align.by = TRUE, extend = FALSE,
        range = NULL, week.align = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
        \item{from}{
                starting value of the sequence, a \code{\link{Date}} object, or number or character string recognized by \code{\link{dateParse}}.
        }
        \item{to}{
                ending value of the sequence, a \code{\link{Date}} object, or number or character string recognized by \code{\link{dateParse}}.
        }
        \item{year}{
                an alternative to supplying \code{from} and \code{to}, create a sequence of dates from the given year.
        }
        \item{by}{
                spacing between successive values in the sequence. Can be one of \code{"days"}, \code{"bizdays"}, \code{"weeks"}, \code{"months"}, or \code{"years"}.

                An alternative way to specify \code{by} is with a character string that encodes the \code{k.by}, \code{by}, and the named \code{holidays}, e.g "+1 bizdays@NYSEC" says to create a sequence whose elements are 1 business day apart and exclude NYSEC holidays.
        }
        \item{k.by}{
                non-zero integer giving the width of the interval between consecutive values in the sequence in terms of the units given in by.
        }
        \item{length.out}{
                the length of the sequence, before additions and exceptions are included.
        }
        \item{holidays}{
                character string describing the holidays to exclude from the sequence when \code{by="bizdays"} (see \code{\link{holidays}}).
        }
        \item{align.by}{
                if TRUE, adjust the sequence so that each element is on a whole number of the \code{by * k.by} units.
        }
        \item{extend}{
                if TRUE and align.by is also TRUE, instead of making the entire sequence lie between from and to,
          make it extend just past from and to to the next aligned values.
        }
        \item{range}{
    a two-element character or \code{Date} vector: an alternate way to specify \code{from} and \code{to}.
        }
        \item{week.align}{
         if \code{by} is \code{"weeks"}, specify the weekday to align to, given as number, 0 to 6 with 0 being Sunday.
        }
}
\value{
        A vector of dates.
  The class of the returned value is the same as the class of \code{from}
  for \code{character}, \code{Date}, \code{POSIXct}, and
  \code{POSIXlt}.  For \code{from} of other classes, the class of the
  returned value is \code{Date}, but this may change in the future.
}
\examples{
dateSeq("2008-12-20", "2009-1-10")
dateSeq("2008-12-20", "2009-1-10", by = "days", k.by = 2)
library(Holidays)
dateSeq("2008-12-20", "2009-1-10", by = "bizdays", holidays = "NYSEC")
dateSeq(from = "1960-01-01", to = "1960-01-20", by = "weeks", week.align
= 0, extend = TRUE)
dateSeq(from = "2000/01/14", length.out = 5, by = "bizdays", holidays = 'NYSEC')
}
\keyword{utilities}
