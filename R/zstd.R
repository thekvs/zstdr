#' Zstandard comression
#'
#' Zstandard, or zstd as short version, is a fast lossless compression algorithm, targeting real-time compression scenarios
#' at zlib-level and better compression ratios.
#'
#' Compresses data using zstandard algorithm
#'
#' @export
#' @seealso \link{memCompress} \link{zstdDecompress} \link{zstdMaxCLevel}
#' @references \url{http://facebook.github.io/zstd/}
#' @param data input data to be compressed or decomressed
#' @param level compression level to use, value between 1 and returned by \link{zstdMaxCLevel} function, default is 3
#' @return compressed data
#' @examples # Simple example
#' library(zstdr)
#' data_file <- file.path(R.home(), "COPYING")
#' data <- readBin(data_file, raw(), file.info(data_file)$size)
#' compressed <- zstdCompress(data)
#' stopifnot(identical(data, zstdDecompress(compressed)))
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

#' Zstandard comression
#'
#' Zstandard, or zstd as short version, is a fast lossless compression algorithm, targeting real-time compression scenarios
#' at zlib-level and better compression ratios.
#'
#' Decompresses data previously compressed with \link{zstdCompress}
#'
#' @export
#' @seealso \link{memCompress} \link{zstdCompress} \link{zstdMaxCLevel}
#' @param data input data to be decomressed
#' @return decompressed data
#' @examples # Simple example
#' library(zstdr)
#' data_file <- file.path(R.home(), "COPYING")
#' data <- readBin(data_file, raw(), file.info(data_file)$size)
#' compressed <- zstdCompress(data)
#' stopifnot(identical(data, zstdDecompress(compressed)))
zstdDecompress <- function(data) {
    if (!is.raw(data)) {
        stop("input data must be raw")
    }

    return(zstdDecompressImpl(data))
}

#' Returns maximum compression level supported by zstandard
#'
#' @export
#' @seealso \link{memCompress} \link{zstdCompress} \link{zstdDecompress}
#' @return maximum supported compression level
zstdMaxCLevel <- function() {
    return(zstdMaxCLevelImpl())
}
