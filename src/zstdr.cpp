// [[Rcpp::plugins(cpp11)]]

#include <memory>
#include <array>

#include <Rcpp.h>
#include <zstd.h>

// [[Rcpp::export]]
SEXP zstdCompressImpl(Rcpp::RObject data, int level) {
    if (level < 1) {
        Rcpp::warning("compression level can't be less than 1, assuming it is 1");
        level = 1;
    } else if (level > ZSTD_maxCLevel()) {
        std::array<char, 128> msg;
        snprintf(msg.data(), msg.size() - 1, "compression level (=%i) is to high, assuming maximum allowed %i", level, ZSTD_maxCLevel());
        Rcpp::warning(msg.data());
        level = ZSTD_maxCLevel();
    }

    auto input = Rcpp::as<Rcpp::RawVector>(data);
    auto sz = ZSTD_compressBound(input.size());
    auto packed = Rcpp::RawVector::create();

    std::unique_ptr<uint8_t[]> temp(new uint8_t[sz]());

    auto rc = ZSTD_compress(&temp[0], sz, input.begin(), input.size(), level);
    if (!ZSTD_isError(rc)) {
        packed.assign(&temp[0], &temp[rc]);
    } else {
        Rcpp::stop(ZSTD_getErrorName(rc));
    }

    return Rcpp::wrap(packed);
}

// [[Rcpp::export]]
SEXP zstdDecompressImpl(Rcpp::RObject data) {
    auto result = Rcpp::RawVector::create();
    auto input = Rcpp::as<Rcpp::RawVector>(data);
    auto sz = ZSTD_getDecompressedSize(input.begin(), input.size());

    if (sz > 0) {
        std::unique_ptr<uint8_t[]> temp(new uint8_t[sz]());
        auto rc = ZSTD_decompress(&temp[0], sz, input.begin(), input.size());
        if (ZSTD_isError(rc)) {
            Rcpp::stop(ZSTD_getErrorName(rc));
        }
        result.assign(&temp[0], &temp[rc]);
    } else {
        Rcpp::stop("Couldn't get size of an object. Data corrupted?");
    }

    return Rcpp::wrap(result);
}

// [[Rcpp::export]]
SEXP zstdMaxCLevelImpl() {
    return Rcpp::wrap(ZSTD_maxCLevel());
}
