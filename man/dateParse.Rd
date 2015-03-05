\name{dateParse}
\alias{dateParse}
\title{Date Construction from Character Vectors}
\description{

Parse dates, automatically selecting one of three formats, returning a
\code{\link{Date}} vector. The possible formats are:
\itemize{
\item{\code{yyyymmdd}}{no delimiters, 4 digits year, 2 digit month,
  2 digit day}
\item{\code{yyyy/[m]m/[d]d}}{with delimiters, 4 digit year, 1 or 2 digit
  month, 1 or 2 digit day}
\item{\code{[m]m/[d]d/yyyy}}{with delimiters, 1 or 2 digit month, 1 or
  2 digit day, 4 digit year}
}
Delimiters are discovered automatically, but '/' and '-' are recommended.

Differs from Splus \code{timeDate} in that it
automatically chooses the format and
in that it stops or returns \code{NULL} if any
elements cannot be parsed. (\code{timeDate} silently
returns \code{NA} for elements that cannot be parsed.)
}
\usage{
dateParse(x, format = NULL, stop.on.error = TRUE, quick.try = TRUE,
dross.remove = FALSE, na.strings = c("NA", ""), ymd8 = TRUE, use.cache = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
        \item{x}{
    A character, factor, timeDate or numeric vector.
        }
        \item{format}{
    Force the use of this date format for parsing \code{x}.
        }
        \item{stop.on.error}{
    Should this function stop with an error when
\code{x} cannot be parse consistently, or should it
return \code{NULL}?
        }
        \item{quick.try}{
    Should this function do a quick try on parsing just few elements of \code{x} (with the goal of failing fast)?
        }
        \item{dross.remove}{
        Should extra characters around the date be allowed and
        automatically removed?  The extracted date is the first
        substring that can be found consistently in all elements of
        \code{x}.
        }
        \item{na.strings}{
    Strings that should be treated as \code{NA} values.
        }
        \item{ymd8}{
          Should an 8-digit format with no separators be tried?  Default is
          \code{TRUE} (there is potential for confusion with numeric
          security identifiers, but this is likely to be a problem,
	  supply ymd8 in the particular case).
        }
        \item{use.cache}{
	  Try matching against cached values instead of using
	  \code{strptime}?
	  When this works, it is 10 to 15 times faster.
        }
}
\details{
        If any elements of \code{x} cannot be interpreted as a
        valid date this function either returns NULL or stops with
        an error (depending on the value supplied for the arugment
        \code{stop.on.error}).  This is different from the
        behavior of \code{timeDate()} and
        \code{timeCalandar} which return \code{NA}
        elements in their results.  This behavior is not appropriate
        for \code{dateParse()} because of its ability to
        guess the format, and its assumption that all elements have
        the same format -- if different elements had different
        formats there would not be a unique way of saying which
        dates were invalid.

        Numeric vectors are interpreted as having the date spelled
        out in digits, e.g., the integer \code{20010228} is
        interpreted as the date \code{"2001/02/28"}.
}
\value{
        A \code{\link{Date}} vector, or NULL.
}
\examples{
dateParse("2001-02-14")
dateParse("2/14/2002")
dateParse(c("1962/06/20", "1962/10/30","NA"))
dateParse(c("19620620", "19621030", "NA"), ymd8 = TRUE)
dateParse(factor(c("2001/01/01", "2001/01/03", "2001/01/01")))
# Possibly unexpected values in conversion from POSIXct to Date
Sys.setenv('TZ'='EST')
x <- as.POSIXct('2011-12-10 16:55:26 EST')+(0:9)*3600
# Date rolls to the next day after 19:00 hours for EST
# (because that it the time the next day is dawning in UTC)
data.frame(x, as.Date(x))
# This is the way to get as.Date() to do the sensible thing
data.frame(x, as.Date(x, tz='EST'))
}
\keyword{utilities}
