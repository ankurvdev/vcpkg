if("udev" IN_LIST FEATURES)
    message("${PORT} currently requires the following tools and libraries from the system package manager:\n    libudev\n\nThese can be installed on Ubuntu systems via apt-get install libudev-dev")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libusb/libusb-cmake
    REF v${VERSION}
    SHA512 3df0ad14677a2d5ca2c3aa85d000d2a071715b5f4d3ce5269ed5a39bfe9368c5aa215a54dee725cb504e2dbd2dd14b68e1be4e00dcc8a93eb51d294ff1814391
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

configure_file("${CURRENT_PORT_DIR}/vcpkg-cmake-wrapper.cmake" "${CURRENT_PACKAGES_DIR}/share/${PORT}/vcpkg-cmake-wrapper.cmake" @ONLY)
file(INSTALL "${SOURCE_PATH}/libusb/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
