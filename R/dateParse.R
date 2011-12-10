dateParse <- function(x, format=NULL, stop.on.error=TRUE, quick.try=TRUE,
                      dross.remove=FALSE, na.strings=c("NA", ""),
                      ymd8=FALSE) {
    if (missing(x) || length(x)==0)
        return(emptyDate())

    # Always return a Date object
    if (inherits(x, "Date"))
        return(x)
    if (inherits(x, "POSIXt")) {
        # To get as.Date() to behave sensibly, need to explicitly
        # supply tz to as.Date().  Otherwise we get the behavior
        # where as.Date(as.POSIXct('2011-12-10 19:55:26 EST', tz='EST'))
        # returns '2011-12-11' (the next day)
        tz <- attr(x, "tzone")
        if (is.null(tz))
            tz <- Sys.timezone()
        return(as.Date(x, tz=tz))
    }
    if (is.numeric(x) && ymd8) {
        # assume that the date is a whole number, maybe stored in a float
        if (!is.wholenumber(x)){
            if (stop.on.error) {
                i <- which(!is.na(x) & floor(x)!=x)
                stop("can only have whole numbers for numeric x: ",
                     paste(x[i[seq(len=min(3, length(i)))]], collapse=", "),
                     if (length(i) > 3) " ...")
            }
            else return(NULL)
        }

        ## If we want 'zone' to make a difference, we
        ## have to use 'as.POSIXlt' instead of 'as.Date'.
        d <- as.Date(strptime(x, "%Y%m%d"))

        # were there any elements of x that became NA because of parse?
        if (any(is.na(d) & !is.na(x))){
            if (stop.on.error) {
                i <- which(is.na(d) & !is.na(x))
                stop("could not parse some dates, e.g.: ",
                     paste(x[i[seq(len=min(3, length(i)))]], collapse=", "),
                     if (length(i) > 3) " ...")
            }
            else return(NULL)
        }
        return(d)
    }
    if (is.factor(x)) {
        levs <- dateParse(levels(x), format=format,
                          stop.on.error=stop.on.error, quick.try=quick.try,
                          dross.remove=dross.remove, na.strings=na.strings,
                          ymd8=ymd8)
        d <- levs[as.integer(x)]
        return(d)
    }
    if (quick.try && length(x)>20) {
        # quickly test just the first few elements of x so that we
        # can stop or return NULL quickly if we can't convert
        m <- match.call(expand=F)
        m$x <- x[1:min(5, length(x))]
        m$quick.try <- F
        quick.result <- eval(m, sys.parent())
        # if quick.result is NULL, then stop.on.error must be false
        if (is.null(quick.result)) return(NULL)
    }
    if (!is.character(x))
        x <- as.character(x)
    if (length(na.strings)==0) {
        x.not.na.idx <- seq_along(x)
        have.nas <- FALSE
    } else if (length(na.strings)==1) {
        x.not.na.idx <- !is.na(x) & (x!=na.strings)
        have.nas <- any(!x.not.na.idx)
    } else {
        x.not.na.idx <- !is.na(x) & !is.element(x, na.strings)
        have.nas <- any(!x.not.na.idx)
    }
    x.not.na <- x[x.not.na.idx]

    # try the quick thing again if there were NA's; this uses the "m"
    # object constructed earlier
    if (have.nas && quick.try && length(x)>20 && any(is.na(m$x))) {
        m$x <- x.not.na[1:min(5, length(x.not.na))]
        quick.result <- eval(m, sys.parent())
        if (is.null(quick.result))
            return(NULL)
    }

    if (is.null(format)) {
        w <- regexpr("[^0-9]", x.not.na)
        delimiter <- setdiff(unique(substring(x.not.na, w, w)), "")
        if (length(delimiter)!=1)
            delimiter <- ""
    } else {
        w <- regexpr("[^%a-zA-Z]", format)
        delimiter <- setdiff(unique(substring(format, w, w)), "")
        if (length(delimiter)!=1)
            delimiter <- ""
    }

    if (delimiter==".") delimiter <- "\\."

    date.ymd8.expr <- "[0-9]{8}"
    date.Ymd.expr <- paste("[0-9]{4}", "[01]?[0-9]", "[0-3]?[0-9]",
                           sep=delimiter)
    date.mdY.expr <- paste("[01]?[0-9]", "[0-3]?[0-9]", "[0-9]{4}",
                           sep=delimiter)
    if (!dross.remove) {
        date.ymd8.expr <- paste("^", date.ymd8.expr, "$", sep="")
        date.Ymd.expr <- paste("^", date.Ymd.expr, "$", sep="")
        date.mdY.expr <- paste("^", date.mdY.expr, "$", sep="")
    }

    if (delimiter!="" && all((m1<-regexpr(date.Ymd.expr, x.not.na))>0)) {
        if (dross.remove)
            x[x.not.na.idx] <- substring(x.not.na, m1,
                                         m1-1+attr(m1, "match.length"))
        format <- paste("%Y", "%m", "%d", sep=delimiter)
    } else if (delimiter!="" &&
               all((m2<-regexpr(date.mdY.expr, x.not.na))>0)) {
        if (dross.remove)
            x[x.not.na.idx] <- substring(x.not.na, m2,
                                         m2-1+attr(m2, "match.length"))
        format <- paste("%m", "%d", "%Y", sep=delimiter)
    } else if (ymd8 && all((m3<-regexpr(date.ymd8.expr, x.not.na))>0)) {
        delimiter = ""
        format <- '%Y%m%d'
        if (dross.remove)
            x[x.not.na.idx] <- substring(x.not.na, m3,
                                         m3-1+attr(m3, "match.length"))
    } else if (length(x.not.na)>0) {
        # the error message may not show the dates
        # that caused the problems, but
        # it requires quite complex to do better...
        if (stop.on.error) {
            if (any(m1))
                i <- c(which(m1>0)[1], which(m1<0)[1])
            else if (any(m2))
                i <- c(which(m2>0)[1], which(m2<0)[1])
            else if (any(m3))
                i <- c(which(m3>0)[1], which(m3<0)[1])
            else
                i <- seq(along=x.not.na)
            i <- i[!is.na(i)]
            stop("cannot find consistent format for dates: ",
                     paste(x.not.na[i[seq(len=min(3, length(i)))]], collapse=", "),
                     if (length(i) > 3) " ...")
        } else
            return(NULL)
    } else {
        # format doesn't matter because everything is NA
        format <- '%Y/%m/%d'
    }

    d <- as.Date(x, format=format)

    if (any(is.na(d[x.not.na.idx]))) {
        if (stop.on.error) {
            i <- seq(along=x)[x.not.na.idx][is.na(d[x.not.na.idx])]
            stop("as.Date returned NA for some strings: ",
                     paste(x[i[seq(len=min(3, length(i)))]], collapse=", "),
                     if (length(i) > 3) " ...")
        } else
            return(NULL)
    }

    d
}
