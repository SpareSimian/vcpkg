include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dinhviethoa/libetpan
    REF 1.9.3
    SHA512 66e504fbf82445819845a3f1dcb8dc48ad2440993134d43752c754463cee2434a30080718687cd05c579f0da8df6b0f6dfc7572f2882d0dd9dfd327b4ae11fd6
    HEAD_REF master
    PATCHES libnames.patch
)

# update the projects to the latest build tool
vcpkg_execute_required_process(
    COMMAND "devenv.exe"
            "libetpan.sln"
            /Upgrade
    WORKING_DIRECTORY ${SOURCE_PATH}/build-windows
    LOGNAME upgrade-${TARGET_TRIPLET}
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH build-windows/libetpan.sln
    LICENSE_SUBPATH copyright
    USE_VCPKG_INTEGRATION
    SKIP_CLEAN
)

# custom build step puts the headers in build-windows/include/libetpan
get_filename_component(SOURCE_PATH_SUFFIX "${SOURCE_PATH}" NAME)
set(SOURCE_COPY_PATH ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/${SOURCE_PATH_SUFFIX})
file(COPY ${SOURCE_COPY_PATH}/build-windows/include/libetpan DESTINATION ${CURRENT_PACKAGES_DIR}/include)

vcpkg_clean_msbuild()
