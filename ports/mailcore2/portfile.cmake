include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MailCore/mailcore2
    REF 0.6.3
    SHA512 7cbfc1db37387a685a402f0dfe385f3e8a473660527cd73cd1228d0b9826fb95d3902b41a3a65a8cc47405284e101517109208e6e599c7ec3abfe6a821473c70
    HEAD_REF master
    PATCHES 
      deprecated_attribute.patch
      afterMainOnMainThread.patch
      no_mmap_for_windows.patch
      uchar_typedef.patch
      no_strings_h.patch
      unsafe_fopen.patch
      no_windows_memmem.patch
      tidybuffio.patch
      lpcwstr_uchar_FindFirstFile.patch
      libnames.patch
      tests_unistd.patch
      libnames_dbg.patch
)

# update the projects to the latest build tool
vcpkg_execute_required_process(
    COMMAND "devenv.exe"
            "mailcore2.sln"
            /Upgrade
    WORKING_DIRECTORY ${SOURCE_PATH}/build-windows/mailcore2
    LOGNAME upgrade-${TARGET_TRIPLET}
)

# build the headers directory
vcpkg_execute_required_process(
    COMMAND "build_headers.bat"
    WORKING_DIRECTORY ${SOURCE_PATH}/build-windows
    LOGNAME headers-${TARGET_TRIPLET}
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH build-windows/mailcore2/mailcore2.sln
    LICENSE_SUBPATH license
    USE_VCPKG_INTEGRATION
)

file(COPY ${SOURCE_PATH}/build-windows/include/MailCore DESTINATION ${CURRENT_PACKAGES_DIR}/include)
