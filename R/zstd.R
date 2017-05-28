#' Compresses character or binary vector
#'
#' @export
#' @param data input data to be compressed
#' @param level compression level to use, default is 3
#' @return compressed data
zstdCompress <- function(data, level=3) {
    stopifnot(is.numeric(level))

    if (is.character(data)) {
        return(zstdCompressImpl(charToRaw(data), as.integer(level)))
    } else if (is.raw(data)) {
        return(zstdCompressImpl(data, as.integer(level)))
    } else {
        stop("data must be of raw or character type")
    }
}

#' Decopresses binary data
#'
#' @export
#' @param data compressed data to be decompressed
#' @return decompressed data
zstdDecompress <- function(data) {
    if (!is.raw(data)) {
        stop("input data must be raw")
    }

    return(zstdDecompressImpl(data))
}

#' Returns maximum compression level supported by zstandard
#
#' @return maximum supported compression level
zstdMaxCLevel <- function() {
    return(zstdMaxCLevelImpl())
}
