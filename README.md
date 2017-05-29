
[![Build Status](https://travis-ci.org/thekvs/zstdr.svg?branch=master)](https://travis-ci.org/thekvs/zstdr)

About
-----

This package provides simple R bindings to the [Zstandard compression library](http://facebook.github.io/zstd/).

Benchmarks
----------

See [benchmarks](Benchmarks.md) for comparison with other compression algorithms.

Installation
------------

For the moment you can only install from GitHub:

``` r
devtools::install_github("thekvs/zstdr")
```

Usage
-----

``` r
library(zstdr)

data_file <- file.path(R.home(), "COPYING")
data <- readBin(data_file, raw(), file.info(data_file)$size)
compressed <- zstdCompress(data)
stopifnot(identical(data, zstdDecompress(compressed)))
```

Links
-----

-   [zstandard official site](http://facebook.github.io/zstd/)
-   [zstandard C API documentation](http://facebook.github.io/zstd/zstd_manual.html)
