test_that("compression/decompression works", {
    data_file <- file.path(getwd(), "data.txt")
    data <- readBin(data_file, raw(), file.info(data_file)$size)[1:1024]

    # test default compression level, which is 3
    compressed <- zstdCompress(data)
    expect_that(identical(data, zstdDecompress(compressed)), is_true())

    for (level in 1:zstdMaxCLevel()) {
        compressed <- zstdCompress(data, level)
        expect_that(identical(data, zstdDecompress(compressed)), is_true())
    }
})
