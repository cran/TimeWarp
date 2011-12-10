##
## Unfortunately, 'format.POSIXct' is not compatible between
## Linux and Windows R. Here are a few for the difference I have found:
## 1) Windows version does not recognize "%y" format.
## 2) Windows version does not recognize width arguments like
##    "%02d".
## 3) Windows and Linux does not agree on the meaning of "%Y".
##    Under Windows it means "%04Y"; under Linux it prints with
##    minimal width.
##
## This function formats any kind of data objects to character
## strings with the default format "%02m-%02d-%04Y" under
## both Linux and Windows.
##

dateFormat.env <- new.env()
dateFormat.env$initialized <- FALSE

dateFormat.config <- function() {
    # figure out the capabilities of the date formatting on this system
    if (strftime(as.POSIXct('0045-01-02'), '%Y-%m-%d') == '0045-01-02')
        dateFormat.env$default.format <- '%Y-%m-%d'
    else if (strftime(as.POSIXct('0045-01-02'), '%04Y-%m-%d') == '0045-01-02')
        dateFormat.env$default.format <- '%04Y-%m-%d'
    else if (strftime(as.POSIXct('0045-01-02'), '%04Y-%02m-%02d') == '0045-01-02')
        dateFormat.env$default.format <- '%04Y-%02m-%02d'
    else if (strftime(as.POSIXct('0045-01-02'), '%Y-%02m-%02d') == '0045-01-02')
        dateFormat.env$default.format <- '%Y-%02m-%02d'
    else
        dateFormat.env$default.format <- '%Y-%m-%d'

    if (strftime(as.POSIXct('0045-01-02'), '%04Y')=='0045')
        dateFormat.env$f04Y.ok <- TRUE
    else
        dateFormat.env$f04Y.ok <- FALSE

    if (strftime(as.POSIXct('1991-01-02'), '%02m-%02d')=='01-02')
        dateFormat.env$f02md.ok <- TRUE
    else
        dateFormat.env$f02md.ok <- FALSE
}

dateFormat <- function(date, format = NULL)
{
    if (!dateFormat.env$initialized)
        dateFormat.config()
    if (is.null(format))
        format <- dateFormat.env$default.format
    if (!dateFormat.env$f04Y.ok && regexpr('%04Y', format, fixed=TRUE)>0)
        format <- gsub('%04Y', '%Y', format, fixed=TRUE)
    if (!dateFormat.env$f02md.ok && regexpr('%02', format, fixed=TRUE)>0)
        format <- gsub('%02', '%', format, fixed=TRUE)

    if (is.character(date))
        date <- dateParse(date)

    if (inherits(date, "dates"))
        format(as.POSIXct(date), format)
    else if (inherits(date, "Date") || is(date, "POSIXt"))
        format(date, format)
    else
        stop("unknown date format: '", class(date), "'")
}
