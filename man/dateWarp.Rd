\name{dateWarp}
\alias{dateWarp}
\alias{dateWarpAppend}
\title{Date vector shifting and alignment}
\description{
  Perform multiple shifts and alignments on \code{\link{Date}} vectors.
  \code{dateWarp()} is a generic, with
  methods for \code{character}, \code{factor}, \code{Date}, \code{POSIXct}, and \code{POSIXlt}.
}
\usage{
dateWarp(date, spec, holidays = NULL, by = NULL, direction = 1,
         duplicates.keep = TRUE, optimize.dups=TRUE)
dateWarpAppend(date, ..., where = c("sorted", "start", "end"), empty.ok = FALSE,
               duplicates.ok = FALSE)
}

\arguments{
        \item{date}{
          a \code{\link{Date}} vector, or a character vector that can be
          converted to \code{\link{Date}} by \code{\link{dateParse}}.
        }
        \item{spec}{
          a specification of shifts and alignment tranformations. See \sQuote{Details}.
        }
        \item{holidays}{
          a character string naming the holiday series (see \code{\link{holidays}}).
        }
        \item{by}{
          how to warp. Can be one of \code{"days"}, \code{"bizdays"},
          \code{"weeks"}, \code{"months"}, or \code{"years"}.
          \code{"bizdays"} can contain a holiday specification like:
          \code{"bizdays@NYSEC"}
        }
        \item{direction}{
          which direction to warp. a numeric value of 1 for the future,
          and -1 for the past (be careful about using variables for this
          value, for if it's value is negative and you place a minus
          sign in front of the variable, you'll go back to the future).
        }
        \item{duplicates.keep}{
          logical indicating whether or not to keep duplicate dates.
        }
        \item{\dots}{
          arguments to pass to \code{dateWarp}.
        }
        \item{where}{
          character string. can be \code{"sorted"} to sort the result instead of append, \code{"start"} to prepend, or \code{"end"} to append.
        }
        \item{empty.ok}{
          is it okay for the \code{dates} argument to be empty?
        }
        \item{duplicates.ok}{
          logical indicating whether or not to keep duplicate dates.
        }
	\item{optimize.dups}{
		If \code{TRUE}, internally optimize by not performing
	the same computation multiple times for duplicates.  This does
	not change the return value.
	}
}
\details{
  \code{spec} specify tranformations in several ways:
  \itemize{
    \item integer vector by which to shift the current Date object. The
    units of the shift are specified by the \code{by} argument.
    If the shift contains more than one element, this will
    transform a single Date object into a multiple-element Date
    object. It is an error to apply a multiple-element shift to
    a multiple element Date object.
    \item character data of the form "+3 bizdays@NYSEC", "+3 bizdays",
    or "+3". 'by' and 'holidays' specifications are extracted from
    the string as appropriate, and override any previously specified
    or given in arguments.
    \item a named list of elements. The elements can be lists or
    vectors. The names on the elements specify instructions:
    \describe{
      \item{unique}{the actual value of the list element is ignored.
        The action is to remove duplicates from the results, i.e., make
        the dates unique.}
      \item{latest}{the value of the list element is a \code{Date} or a character that can
        be converted to a \code{Date} with
        \code{\link{dateParse}}. The dates will be clipped to be no
        later than the specified \code{Date}.}
      \item{earliest}{the value of the list element is a \code{Date} or a character that can
        be converted to a \code{Date} with
        \code{\link{dateParse}}. The dates will be clipped to be no earlier
        than the specified \code{Date}.}
      \item{shift}{the \code{spec} list element is a list that will be used as arguments to a call
        of \code{\link{dateShift}}. If any are not specified in the list,
        the values of the \code{by}, \code{holidays}, and \code{direction} arguments given to
        \code{dateWarp()} are passed to \code{dateShift}.}
      \item{align}{the \code{spec} list element is a list that will be used as arguments to a call
        of \code{\link{dateAlign}}. If any are not specified in the list,
        the values of the \code{by}, \code{holidays}, and \code{direction} arguments given to
        \code{dateWarp()} are passed to \code{dateShift}.}
    }
    If not all arguments are not provided, the {dateWarp}
    arguments will be used instead.
  }
}
\value{
  A date vector that is a transformed version of the input
  dates. Multiple shift or alignment transformations can be specified. If
  more that one is given, each vill be applied in turn to the result of
  the previous one.
  The class of the returned value is the same as the class of \code{date}
  for \code{character}, \code{Date}, \code{POSIXct}, and
  \code{POSIXlt}.  For \code{date} of other classes, the class of the
  returned value is \code{Date}, but this may change in the future.
}
\author{Lars Hansen, Tony Plate}
\seealso{
  \code{\link{dateAlign}},
  \code{\link{dateShift}},
  \code{\link{dateMatch}},
  \code{\link{dateParse}},
  and \code{\link{dateSeq}}

  The \code{Holidays} package contains holidays data, which is
  registered with the \code{TimeWarp} package when the \code{Holidays}
  package is loaded.
}
\examples{
library(Holidays)
dates <- dateSeq("2001/12/20", by = 'bizdays', len = 9, holidays = "NYSEC")
dateWarp(dates, -1:1, by = "bizdays", holidays = "NYSEC", duplicates.keep = FALSE)
dateWarp(dates, "+1 bizdays@NYSEC")
dateWarp(dates, list(0:6), by = "bizdays@NYSEC")
dateWarp(dates, list(-1:1, unique = TRUE), by = "bizdays")
dateWarp(dates, list(latest = "2001/12/25"))
x <- dateSeq("2001/01/01", len = 4, by = "weeks")
dateWarp(dates, list(align = list(to = x, how = "after")))
dateWarp(dates, list(shift = list(by = "bizdays", k.by = 2, direction = 1, holidays = "NYSEC"),
                     shift = 2),
         by = "days", direction = -1,
holidays = "NONE")
dateWarp(dates, hol = "NYSEC",
         list(shift = list(k.by = 1, by = "months"),
         shift=list(k.by = -1, by = "bizdays")))
dateWarp(dates, list(align = list(by = "bizdays"),
                     shift = list(by = "months", k.by = 2), holidays = "JPNEX"))

# Options expirations dates in 2008
(d1 <- dateSeq('2008-01-01', len=12, by='months'))
(d2 <- dateAlign(d1, by='months', dir=-1))
(d3 <- dateAlign(d2, by='weeks', week.align=5))
(d4 <- dateWarp(d3, 14, by='days'))
(d5 <- dateAlign(d4, by='bizdays@NYSEC', dir=-1))
# Version that uses a list 'spec' to dateWarp
dateWarp(d1, list(align=list(by='months', dir=-1),
                  align=list(by='weeks', week.align=5),
                  shift=list(by='days', 14),
                  align=list(by='bizdays@NYSEC', dir=-1)))
# In 2008 the March options expiration is a Thursday because Friday was a holiday
dateDow(d5)
}

\keyword{utilities}
