# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_buildpath_length_warning(37)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/system
    REF boost-${VERSION}
    SHA512 d4a23d538acd1b3d4da91e0fcf3f13cca1d7095038f9cc7c3b38e21dd78b7212e386e6e94a325becc6f1a5bc1675c59d206e640f97cf6aaae9ce2c98c36c17fe
    HEAD_REF master
    PATCHES
        compat.diff
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
