vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ankurvdev/stencil
    REF "80691737f07f12a79856d503b06b1ce5ef311d73"
    SHA512 edd75891f10b983fc672978eaf48e6bd9a13fb21b6f9a4cbb6372f4b910c98727dc072333112388da2d38a1dc83ce36764bfa89b63f030ddbeda56ce3639ffb2
    HEAD_REF main)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBUILD_TESTING=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

# Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
if(HOST_TRIPLET STREQUAL TARGET_TRIPLET) # Otherwise fails on wasm32-emscripten
    vcpkg_copy_tools(TOOL_NAMES stencil AUTO_CLEAN)
else()
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin")
endif()

file(READ "${CURRENT_PACKAGES_DIR}/share/stencil/stencilConfig.cmake" config_contents)
file(WRITE "${CURRENT_PACKAGES_DIR}/share/stencil/stencilConfig.cmake" "find_program(
    stencil_EXECUTABLE stencil
    PATHS
        \"\${CMAKE_CURRENT_LIST_DIR}/../../../${HOST_TRIPLET}/tools/${PORT}\"
    NO_DEFAULT_PATH
    REQUIRED)
${config_contents}"
)
