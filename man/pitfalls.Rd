\name{pitfalls}
\alias{pitfalls}
\alias{gotchas}
\docType{package}
\title{Pitfalls in date class conversions}
\description{

  Direct conversion between \code{Date} and \code{POSIXt} classes using the
  \code{as.*} can give probably undesired results unless great care is
  taken with supplying appropriate time zones where needed.

  It is generally easier to convert dates between \code{Date} and
  \code{POSIXt} using character formatted dates as an intermediate
  representation.

  Note that what is described as "not sensible" behavior here is NOT
  INCONSISTENT with the documentation for \code{\link{as.POSIXct}} and
  \code{\link{as.POSIXlt}}.

}
\details{
\preformatted{
> # Behavior depends on the timezone of the system
> Sys.setenv(TZ='EST')
> Sys.timezone()
[1] "EST"
>
> # Get some POSIXct times that span 9 hours over an evening and
> # the following morning.
> x <- as.POSIXct('2011-12-10 16:55:26 EST', tz='EST')+(0:9)*3600
>
> # The first 8 date/times are in the evening of Dec 10, the last 2 in the
> # morning of Dec 11 (in EST).
>
> as.character(x)
 [1] "2011-12-10 16:55:26" "2011-12-10 17:55:26" "2011-12-10 18:55:26"
 [4] "2011-12-10 19:55:26" "2011-12-10 20:55:26" "2011-12-10 21:55:26"
 [7] "2011-12-10 22:55:26" "2011-12-10 23:55:26" "2011-12-11 00:55:26"
 [10] "2011-12-11 01:55:26"
>
> # Not sensible direction conversion POSIXct->Date.
> # Times after 7pm in the POSIXct object turn up as the next day in
> # the Date Object. (They are interpreted as a time-of-day in GMT
> # and 7pm EST is 12 midnight GMT.)
> as.Date(x)
 [1] "2011-12-10" "2011-12-10" "2011-12-10" "2011-12-11" "2011-12-11"
 [6] "2011-12-11" "2011-12-11" "2011-12-11" "2011-12-11" "2011-12-11"
>
> # Another way of looking at the as.Date(POSIXct)
>
> data.frame(as.character(x), as.Date(as.character(x)), as.Date(x), check.names=F)
       as.character(x) as.Date(as.character(x)) as.Date(x)
1  2011-12-10 16:55:26               2011-12-10 2011-12-10
2  2011-12-10 17:55:26               2011-12-10 2011-12-10
3  2011-12-10 18:55:26               2011-12-10 2011-12-10
4  2011-12-10 19:55:26               2011-12-10 2011-12-11
5  2011-12-10 20:55:26               2011-12-10 2011-12-11
6  2011-12-10 21:55:26               2011-12-10 2011-12-11
7  2011-12-10 22:55:26               2011-12-10 2011-12-11
8  2011-12-10 23:55:26               2011-12-10 2011-12-11
9  2011-12-11 00:55:26               2011-12-11 2011-12-11
10 2011-12-11 01:55:26               2011-12-11 2011-12-11
>
> # as.Date(POSIXlt) works differently from as.Date(POSIXct)
>
> data.frame(as.character(x), as.Date(x), as.Date(as.POSIXlt(x)), check.names=F)
       as.character(x) as.Date(x) as.Date(as.POSIXlt(x))
1  2011-12-10 16:55:26 2011-12-10             2011-12-10
2  2011-12-10 17:55:26 2011-12-10             2011-12-10
3  2011-12-10 18:55:26 2011-12-10             2011-12-10
4  2011-12-10 19:55:26 2011-12-11             2011-12-10
5  2011-12-10 20:55:26 2011-12-11             2011-12-10
6  2011-12-10 21:55:26 2011-12-11             2011-12-10
7  2011-12-10 22:55:26 2011-12-11             2011-12-10
8  2011-12-10 23:55:26 2011-12-11             2011-12-10
9  2011-12-11 00:55:26 2011-12-11             2011-12-11
10 2011-12-11 01:55:26 2011-12-11             2011-12-11
>
> # Sensible conversion POSIXct->character->Date.
> as.Date(as.character(x))
 [1] "2011-12-10" "2011-12-10" "2011-12-10" "2011-12-10" "2011-12-10"
 [6] "2011-12-10" "2011-12-10" "2011-12-10" "2011-12-11" "2011-12-11"
>
> # Can do this correctly multiple ways, direct POSIXct->Date works if
> # we supply tz='EST' to as.Date()
> all.equal(as.Date(as.character(x)), as.Date(x, tz='EST'))
[1] TRUE
> all.equal(as.Date(as.character(x)), as.Date(as.character(x), tz='EST'))
[1] TRUE
>
> (x.Date <- as.Date(as.character(x)))
 [1] "2011-12-10" "2011-12-10" "2011-12-10" "2011-12-10" "2011-12-10"
 [6] "2011-12-10" "2011-12-10" "2011-12-10" "2011-12-11" "2011-12-11"
>
> # Sensible conversion Date->character->POSIXct
> as.POSIXct(as.character(x.Date))
 [1] "2011-12-10 EST" "2011-12-10 EST" "2011-12-10 EST" "2011-12-10 EST"
 [5] "2011-12-10 EST" "2011-12-10 EST" "2011-12-10 EST" "2011-12-10 EST"
 [9] "2011-12-11 EST" "2011-12-11 EST"
>
> # Not sensible direct conversion Date->POSIXct.  (Unless we really want
> # the time in our zone corresponding to when it is midnight in GMT.)
> as.POSIXct(x.Date)
 [1] "2011-12-09 19:00:00 EST" "2011-12-09 19:00:00 EST"
 [3] "2011-12-09 19:00:00 EST" "2011-12-09 19:00:00 EST"
 [5] "2011-12-09 19:00:00 EST" "2011-12-09 19:00:00 EST"
 [7] "2011-12-09 19:00:00 EST" "2011-12-09 19:00:00 EST"
 [9] "2011-12-10 19:00:00 EST" "2011-12-10 19:00:00 EST"
>
> # Probably sensible direction conversion Date->POSIXlt -- if this stops
> # being sensible, check code in date*.POSIXlt methods
> as.POSIXlt(x.Date)
 [1] "2011-12-10 UTC" "2011-12-10 UTC" "2011-12-10 UTC" "2011-12-10 UTC"
 [5] "2011-12-10 UTC" "2011-12-10 UTC" "2011-12-10 UTC" "2011-12-10 UTC"
 [9] "2011-12-11 UTC" "2011-12-11 UTC"
>
> # 'tz' argument on as.POSIXlt() is ignored for conversion from Date
> attr(as.POSIXlt(x.Date, tz='UTC'), 'tzone')
[1] "UTC"
> attr(as.POSIXlt(x.Date, tz='GMT'), 'tzone')
[1] "UTC"
> attr(as.POSIXlt(x.Date, tz='EST'), 'tzone')
[1] "UTC"
> all.equal(as.POSIXlt(x.Date), as.POSIXlt(x.Date, tz='UTC'))
[1] TRUE
> all.equal(as.POSIXlt(x.Date), as.POSIXlt(x.Date, tz='GMT'))
[1] TRUE
> all.equal(as.POSIXlt(x.Date), as.POSIXlt(x.Date, tz='EST'))
[1] TRUE
>
}
}
\keyword{utilities}
