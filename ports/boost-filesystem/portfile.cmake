# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/filesystem
    REF boost-${VERSION}
    SHA512 cb036ab7a381ffd72c0a415d00b256c82445f4f777ce5b7b1490f9dcea53e28af8ccea67807a12195f44bfee6aa29e1bd7178cef2199f2cfd017c066c005d29c
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
