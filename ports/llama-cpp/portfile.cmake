vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ankurvdev/llama.cpp
    REF cea2200fce2445d6b04d20682d6a43b585151cd3
    SHA512 f6e2d664020005daf27f24142b4d16dbf372101904574a85f298287fc7fea392b078ebef17d67723333cd2e8e962b86e96398f5ae002e1f17a3aae4d3fbac31c
    HEAD_REF master
    PATCHES
        cmake-config.diff
        pkgconfig.diff
        unvendor.diff
)
file(REMOVE_RECURSE "${SOURCE_PATH}/ggml/include" "${SOURCE_PATH}/ggml/src")
file(REMOVE_RECURSE
    "${SOURCE_PATH}/vendor/cpp-httplib"
    "${SOURCE_PATH}/vendor/miniaudio"
    "${SOURCE_PATH}/vendor/nlohmann"
    "${SOURCE_PATH}/vendor/stb")

vcpkg_check_features(OUT_FEATURE_OPTIONS options
    FEATURES
        download    LLAMA_CURL
        server      LLAMA_BUILD_SERVER
        tools       LLAMA_BUILD_TOOLS
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
        -DGGML_CCACHE=OFF
        -DLLAMA_ALL_WARNINGS=OFF
        -DLLAMA_BUILD_TESTS=OFF
        -DLLAMA_BUILD_EXAMPLES=OFF
        -DLLAMA_USE_SYSTEM_GGML=ON
        -DVCPKG_LOCK_FIND_PACKAGE_Git=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/llama")
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/gguf-py/gguf" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}/gguf-py")

if("tools" IN_LIST FEATURES)
    set(tool_names
        llama-batched-bench
        llama-bench
        llama-completion
        llama-cvector-generator
        llama-export-lora
        llama-fit-params
        llama-gguf-split
        llama-imatrix
        llama-mtmd-cli
        llama-perplexity
        llama-quantize
        llama-results
        llama-template-analysis
        llama-tokenize
        llama-tts
    )
    # https://github.com/ggml-org/llama.cpp/blob/master/tools/parser/CMakeLists.txt#L1
    if(NOT VCPKG_TARGET_IS_WINDOWS OR VCPKG_LIBRARY_LINKAGE STREQUAL "static")
        list(APPEND tool_names llama-debug-template-parser)
    endif()
    if("server" IN_LIST FEATURES)
        list(APPEND tool_names llama-cli llama-server)
    endif()
    vcpkg_copy_tools(
        TOOL_NAMES ${tool_names}
        AUTO_CLEAN
    )
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_clean_executables_in_bin(FILE_NAMES none)

set(gguf-py-license "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/gguf-py LICENSE")
file(COPY_FILE "${SOURCE_PATH}/gguf-py/LICENSE" "${gguf-py-license}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE" "${gguf-py-license}")
