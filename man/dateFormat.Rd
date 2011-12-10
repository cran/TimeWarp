\name{dateFormat}
\alias{dateFormat}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Converts a Date object to character data }
\description{
  Converts a Date object to character data
}
\usage{
dateFormat(date, format = NULL)
}
\arguments{
  \item{date}{ A vector of dates.  Can be character data or some date
    object -- anything that can be handled by \code{dateParse()} }
  \item{format}{ A specification of the format.  The default will print
    as "YYYY-MM-DD" under both Windows and Linux. }
}
\details{
Unfortunately, 'format.POSIXct' is not compatible between
Linux and Windows R. Here are a few for the difference found in 2008:
\enumerate{
\item{Windows version does not recognize "\%y" format.}
\item{Windows version does not recognize width arguments like
   "\%02d".}
\item{Windows and Linux does not agree on the meaning of "\%Y".
   Under Windows it means "\%04Y"; under Linux it prints with
   minimal width.}
 }

This function formats any kind of data objects to character
strings with the default format "\%04Y-\%02m-\%02d" under
both Linux and Windows.  It does this by choosing a system-specific
default format and then calling \code{format()}.
}
\value{
The formatted dates as a vector of character data.
}
\author{ Tony Plate }
\examples{
dateFormat(as.Date('2001-02-13'), '\%Y.\%02m.\%02d')
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{utilities}

