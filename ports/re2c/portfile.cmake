vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO skvadrik/re2c
    REF ${VERSION}
    SHA512 7528d78e1354c774783e63e05553b7a772f8185b43b988cddf79a527ed63316f18e6f9fb3a63ae4d5c83c9f4de2b672b0e61898d96bdd6f15a1eaa7b4d47c757
    HEAD_REF main)

vcpkg_find_acquire_program(FLEX)
vcpkg_find_acquire_program(BISON)
vcpkg_find_acquire_program(PYTHON3)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

# Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
if(HOST_TRIPLET STREQUAL TARGET_TRIPLET) # Otherwise fails on wasm32-emscripten
    vcpkg_copy_tools(TOOL_NAMES re2c AUTO_CLEAN)
else()
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin")
endif()
