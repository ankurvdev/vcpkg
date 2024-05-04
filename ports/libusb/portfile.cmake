if(VCPKG_TARGET_IS_LINUX)
    message("${PORT} currently requires the following tools and libraries from the system package manager:\n    autoreconf\n    libudev\n\nThese can be installed on Ubuntu systems via apt-get install autoreconf libudev-dev")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libusb/libusb-cmake
    REF v${VERSION}
    SHA512 da457934a9dc2592eefad0b6c0bc3fdb69724bfe4260676605eb14868dc4a2eaece13ae0b8b8000f2ed7c4d840d8a03488a7f8564b484993d8d2ec62f55f5f02
    HEAD_REF master
)
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_TESTING=OFF
)
vcpkg_install_cmake()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_fixup_pkgconfig()

configure_file("${CURRENT_PORT_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" @ONLY)
configure_file("${CURRENT_PORT_DIR}/vcpkg-cmake-wrapper.cmake" "${CURRENT_PACKAGES_DIR}/share/${PORT}/vcpkg-cmake-wrapper.cmake" @ONLY)
file(INSTALL "${SOURCE_PATH}/libusb/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
