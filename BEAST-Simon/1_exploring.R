library(ggplot2)
#' Taking a nexus file from _APE_'s read.nexus.data
#' function, calculates how many states of the given
#' value are present for each Taxon.
#'
#' Returns a data frame.
#'
#' @param nexus a nexus.data object from read.nexus.data.
#' @return A dataframe of \code{Taxon}, \code{State}, and \code{Count}.
#' @examples
#' nex <- read.nexus.data('filename.nex')
#' statecounts(nex)
statecounts <- function(nexus) {
    # homework problem - figure out a more elegant way to do this.
    out <- data.frame(Taxon=c(), State=c(), Count=c())
    for (taxon in names(nexus)) {
        f = as.data.frame(table(nexus[[taxon]]))
        out <- rbind(out,
            data.frame(Taxon=taxon, State=f$Var1, Count=f$Freq)
        )
    }
    out
}
plot_statecounts <- function(nex) {
    sc <- statecounts(nex)
    p <- ggplot(sc, aes(x=Taxon, y=Count, fill=State))
    p <- p + geom_bar(stat="identity")
    p <- p + coord_flip() + theme_bw()
    p
}


cognatesizes <- function(nex) {
    df <- as.data.frame(nex)

    count <- function(arow) {
        length(arow[arow == '1'])
    }
    out <- data.frame(
        Site=row.names(df), Size=apply(df, 1, count)
    )
    out
}
plot_cognatesizes <- function(nex){
    sizes <- cognatesizes(nex)
    p <- qplot(Size, data=sizes, geom="histogram", main="Cognate Set Sizes") + theme_bw()
    p
}
