\name{dateFormat}
\alias{dateFormat}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Converts a Date object to character data }
\description{
  Converts a Date object to character data
}
\usage{
dateFormat(date, format = NULL, optimize.dups=TRUE)
}
\arguments{
  \item{date}{ A vector of dates.  Can be character data or some date
    object -- anything that can be handled by \code{dateParse()} }
  \item{format}{ A specification of the format.  The default will print
    as "YYYY-MM-DD" under both Windows and Linux. }
  \item{optimize.dups}{
    If \code{TRUE}, internally optimize by not performing
    the same computation multiple times for duplicates.  This does
    not change the return value.
  }
}
\details{
Unfortunately, 'format.POSIXct' does not have the same behavior on
Linux and Windows. Here are a few for the difference found in 2008:
\enumerate{
\item{Windows version does not recognize "\%y" format.}
\item{Windows version does not recognize width arguments like
   "\%02d".}
\item{Windows and Linux does not agree on the meaning of "\%Y".
   Under Windows it means "\%04Y"; under Linux it prints with
   minimal width.}
 }

 This function tries to provide identical behavior under Linux and
 Windows and Mac.
This function formats any kind of data objects to character
strings with the default format "\%04Y-\%02m-\%02d" under
both Linux and Windows.  It does this by choosing a system-specific
default format and then calling \code{format()}.

Additional format specifications are also provided:
\itemize{
  \item{'\%Q' for quarter, as 'Q1', etc (the value returned by \code{quarters()}}
  \item{'\%C' for century, always 2 digits (e.g., '20' for 2013)}
  }
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

