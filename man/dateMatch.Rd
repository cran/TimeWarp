\name{dateMatch}
\alias{dateMatch}
\title{Match Dates in a Table}
\description{
Return the indices of dates in a table that match, according to rules "before", "after", etc.
\code{dateMatch()} is a generic, with
methods for \code{character}, \code{Date}, \code{POSIXct}, and \code{POSIXlt}.
}
\usage{
dateMatch(x, table, how=c("NA", "before", "after", "nearest", "interp"), error.how=c("NA", "drop", "nearest"), nomatch=NA, offset=NULL, value=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
	\item{x}{
    A \code{"\link{Date}"} vector, or a character vector that can be converted to \code{"\link{Date}"}
	}
	\item{table}{
    A \code{"\link{Date}"} vector, or a character vector that can be converted to \code{"\link{Date}"}.  Must be strictly increasing.
	}
	\item{how}{ A character string.
    Determines how values in \code{x} that do not have exact matches in \code{table} are handled.

		\describe{
			\item{\code{"before"}}{the element in \code{table} that is just before}
			\item{\code{"after"}}{the element in \code{table} that is just after}
			\item{\code{"nearest"}}{the element in \code{table} that is nearest}
			\item{\code{"interp"}}{an interpolated index}
			\item{\code{"NA"}}{return the \code{nomatch} value}
		}
	}
	\item{error.how}{

		A character string.
		Determines how to handle values in \code{x} that do not have exact
		matches in \code{table} and for which the \code{how} rule fails (e.g. when \code{how}
		is one of \code{"before"}, \code{"after"}, or \code{"interp"}).

		\describe{
			\item{\code{"NA"}}{return the "nomatch" value}
			\item{\code{"drop"}}{causes non-matched values to be \code{dropped}}
			\item{\code{"nearest"}}{pick the nearest value in \code{table}.}
		}

	}
	\item{nomatch}{
		The value to return for \code{nomatch} cases. If \code{value=TRUE}, then nomatch must be a \code{Date} value, Otherwise it must be a numeric value. \code{NA} is the default.
	}
	\item{offset}{

		If an integer, this offset is added to the computed indices after
		matching.  (Can be an integer value represented as a float.)  Non-integer
		and non-numeric values cause an error.  It is possible that later on,
		character values may be allowed to specify a computed offset to the
		values in \code{x} (e.g., something like \code{"+1 bizdays@NYSEC"}).
		If the result is outside the range of indices of \code{table}, \code{NA}
		is returned in those positions.

	}
	\item{value}{
		If \code{TRUE}, the matching value in \code{table} is returned instead of the index.
	}
}
\details{
	Uses \code{match} and \code{findInterval} to perform matching.
}
\value{
The indices of the matches for the elements of \code{x} in \code{table},
or the actual matching values from \code{table} if
\code{value==TRUE}.
In the latter case, the class of the returned value is the same as the class of \code{x}
  for \code{character}, \code{Date}, \code{POSIXct}, and
  \code{POSIXlt}.  For \code{x} of other classes, the class of the
  returned value is \code{Date}, but this may change in the future.

	
}
\examples{
d1 <- dateParse(c("2001/01/10", "2001/03/12"))
d2 <- dateSeq(dateParse("2001/01/01"), by = "weeks", len = 20)
dateMatch(d1, dateParse(), how = "nearest", error.how = "drop")
dateMatch(d1, d2, how = "after")
dateMatch(d1, d2, how = "after", offset = -3)
dateMatch(dateParse(c("2001/01/10", "2001/01/17", "2001/03/12")),
dateSeq(dateParse("2001/01/01"), by = "weeks", len = 20), how = "after",
offset = 10, value = TRUE)
}
\keyword{utilities}
