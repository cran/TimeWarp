# dateDow format as character with day-of-week appended
dateDow <- function(date)
    UseMethod('dateDow')

dateDow.default <- function(date)
    paste(as.character(date), weekdays(date, abbreviate=TRUE))

dateDow.character <- function(date)
    paste(date, weekdays(dateParse(date, dross.remove=TRUE), abbreviate=TRUE))

dateDow.factor <- function(date) {
    lev <- levels(date)
    new.lev <- paste(date, weekdays(dateParse(lev, dross.remove=TRUE), abbreviate=TRUE))
    if (!any(duplicated(new.lev)) && length(new.lev)==length(lev) && !any(is.na(new.lev) & !is.na(lev))) {
        levels(date) <- as.character(new.lev)
    } else {
        # Have duplicates new.lev; must recode factor to a smaller set of levels.
        new.lev2 <- unique(new.lev)
        new.lev2 <- sort(new.lev2[!is.na(new.lev2)])
        recode <- match(new.lev, new.lev2)
        date <- structure(recode[as.integer(date)], levels=new.lev2, class='factor')
    }
    date
}

