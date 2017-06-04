# require at least autoconf 2.61
AC_PREREQ(2.61)

# Process this file with autoconf to produce a configure script.
AC_INIT([zstdr], [0.1.0])

# We are using C++
AC_LANG(C++)
AC_REQUIRE_CPP
AC_PROG_CXX

## Set R_HOME, respecting an environment variable if set
: ${R_HOME=$(R RHOME)}
if test -z "${R_HOME}"; then
    AC_MSG_ERROR([Could not determine R_HOME.])
fi

AC_CHECK_PROG(CMAKE_CHECK, cmake, yes)
if test x"$CMAKE_CHECK" != x"yes" ; then
    AC_MSG_ERROR([Could not find cmake.])
fi

## Get R compilers and flags
ZSTDR_CC=$("${R_HOME}/bin/R" CMD config CC)
ZSTDR_CFLAGS=$("${R_HOME}/bin/R" CMD config CFLAGS)
ZSTDR_CPP=$("${R_HOME}/bin/R" CMD config CPP)
ZSTDR_CPPFLAGS=$("${R_HOME}/bin/R" CMD config CPPFLAGS)
ZSTDR_CXX=$("${R_HOME}/bin/R" CMD config CXX)
ZSTDR_CXXFLAGS=$("${R_HOME}/bin/R" CMD config CXXFLAGS)
ZSTDR_CXXCPP=$("${R_HOME}/bin/R" CMD config CXXCPP)

AC_MSG_NOTICE([Starting to build zstd library])

build_dir=`mktemp -d -t zstdr_build_XXXXXX`
zstd_version="1.2.0"

$(cd "src/third_party/zstd-$zstd_version"; \
  	src_dir="$(pwd)"
	cd $build_dir
	cmake "$src_dir/build/cmake/" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$build_dir/install" -DCMAKE_C_FLAGS="${ZSTDR_CFLAGS} -fPIC" -DCMAKE_CXX_FLAGS="${ZSTDR_CXXFLAGS} -fPIC" -DZSTD_BUILD_STATIC=ON; \
	make > /dev/null 2>&1;)

AC_MSG_NOTICE([Finished building zstd library])

ZSTD_LIBS="$build_dir/lib/libzstd.a"
ZSTD_INCL="-I$(pwd)/src/third_party/zstd-$zstd_version/lib"

zstd_cflags="${ZSTD_INCL}"
zstd_libs="${ZSTD_LIBS}"

AC_SUBST([PKG_CFLAGS],["${PKG_CFLAGS} $zstd_cflags"])
AC_SUBST([PKG_CXXFLAGS],["${PKG_CXXFLAGS} -Wall -Wextra $zstd_cflags"])
AC_SUBST([PKG_LIBS],["${PKG_LIBS} $zstd_libs"])
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
