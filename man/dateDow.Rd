\name{dateDow}
\alias{dateDow}
\title{
Formats a date/time as character and appends the day of week
}
\description{
Formats a date/time as character and appends the day of week in the
current locale.  Is a generic with currently on a default method.
}
\usage{
dateDow(date)
}
\arguments{
  \item{date}{
    A vector that can be interpreted as a date.
}
}
\details{
  For character values of \code{date}, parses the date using
  \code{dateParse(date, dross.remove=TRUE)} and converts to day of week
  using \code{weekdays()}.  For \code{date} of other classes, calls
  \code{weekdays(date)} directly.  Weekdays uses the locale \code{LC_TIME} to
  determine the language used.
}
\value{
  A character vector.
}
\author{
  Tony Plate \email{tplate@acm.org}
}
\note{
To get the weekday expressed in English, do
\code{Sys.setlocale("LC_TIME", "C")}.  (This should affect all
language-dependent time formatting.)
}
\seealso{
  \code{\link{weekdays}}
}
\examples{
dateDow(Sys.time())
dateDow(Sys.Date())
dateDow('2011-01-01')
}
\keyword{ misc }
