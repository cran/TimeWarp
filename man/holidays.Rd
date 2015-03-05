\name{holidays}
\alias{holidays}
\alias{addToHolidays}
\alias{registerHolidays}
\alias{unregisterHolidays}
\alias{allHolidays}
\alias{isHoliday}
\title{TimeWarp Holiday Database}
\description{
	Functions for querying and manipulating the TimeWarp holiday database
}
\usage{
holidays(years, type, silent = FALSE)
addToHolidays(type,dates)
registerHolidays(type,dates)
unregisterHolidays(type,dates)
allHolidays()
isHoliday(dates, type)
}

\arguments{
	\item{years}{ numeric vector of years for which to return holiday dates. }
	\item{type}{ character string, name of the holiday. }
	\item{dates}{
			a \code{\link{Date}} vector, or a character vector that can be converted to \code{\link{Date}} by \code{\link{dateParse}}.
		      }
	\item{silent}{do not display warnings.}
}
\details{
  The TimeWarp holidays database is implemented as an internal named, or \code{type}'d, list of \code{\link{data.frame}}'s.

	To create a new \code{type} of holiday, use \code{registerHolidays}. \code{unregisterHolidays} will delete the holiday named by \code{type}, and \code{addToHolidays} will add new days to an existing \code{type} of holiday.

	\code{allHolidays} returns a character vector of all the known holiday \code{type}s.
}
\value{
	\code{holidays} returns a \code{\link{Date}} vector of holidays that fall within the \code{years} argument for the given holiday \code{type}.

	\code{addToHolidays} and \code{registerHolidays} invisibly return a copy of the \code{\link{data.frame}} for the given \code{type}.

	\code{unregisterHolidays} invisibly returns \code{\link{NULL}}.

	\code{allHolidays} returns a character vector of all holiday
	\code{type}'s known to the database.

	\code{isHoliday} returns a logical vector with TRUE of all
	holidays in input.
}
\examples{
# Create a holiday type of New Year days for the 20th century.
registerHolidays('NEWYEAR', as.Date(ISOdate(1900:2000,1,1)))

# Return all New Year days for the 1990's
holidays(1990:2000,'NEWYEAR')

# View counts of registered holidays by year
sapply(as.character(1998:2012), function(y)
       sapply(allHolidays(), function(h) length(holidays(y, h, silent=TRUE))))

}
\keyword{utilities}
