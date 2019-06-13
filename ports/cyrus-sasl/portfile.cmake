include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cyrusimap/cyrus-sasl
    REF cyrus-sasl-2.1.27
    SHA512 2138d4b122da5a326ad94c6c9f6cb0e959f87c2ed991f926afd22a5d4b390ef0380aece689ff48ceb4c0f0ae305a7472fd5b8fe905f800d04a4f0d4e16248644
    HEAD_REF master
    PATCHES AdditionalDirectories.patch
)


file(TO_NATIVE_PATH ${CURRENT_PACKAGES_DIR} CURRENT_PACKAGES_DIR_NATIVE)

# update ALL the projects to the latest build tool
vcpkg_execute_required_process(
    COMMAND "devenv.exe"
            "cyrus-sasl-all-in-one.sln"
            /Upgrade
    WORKING_DIRECTORY ${SOURCE_PATH}/win32
    LOGNAME upgrade-${TARGET_TRIPLET}
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/sasl2.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/common.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/sasldb.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/plugin_digestmd5.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/plugin_scram.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/plugin_anonymous.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/plugin_plain.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/plugin_ntlm.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/plugin_sasldb.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

# no gssapi package in vcpkg
if(0)
vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/plugin_gssapiv2.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)
endif()

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/install.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
    OPTIONS "/p:InstallRoot=${CURRENT_PACKAGES_DIR_NATIVE}"
)

if(0)
#set(CYRUS_SOLUTION "cyrus-sasl-core.sln")
#set(CYRUS_SOLUTION "cyrus-sasl-all-in-one.sln")
if(VCPKG_TARGET_ARCHITECTURE STREQUAL x86)
    # Projects use x86 instead of Win32
    vcpkg_install_msbuild(
        PLATFORM x86
        SOURCE_PATH ${SOURCE_PATH}
        PROJECT_SUBPATH win32/${CYRUS_SOLUTION}
        INCLUDES_SUBPATH include
        LICENSE_SUBPATH COPYING
        REMOVE_ROOT_INCLUDES
        USE_VCPKG_INTEGRATION
        OPTIONS "/p:InstallRoot=${CURRENT_PACKAGES_DIR_NATIVE}"
    )
else()
    vcpkg_install_msbuild(
        SOURCE_PATH ${SOURCE_PATH}
        PROJECT_SUBPATH win32/${CYRUS_SOLUTION}
        INCLUDES_SUBPATH include
        LICENSE_SUBPATH COPYING
        REMOVE_ROOT_INCLUDES
        USE_VCPKG_INTEGRATION
        OPTIONS "/p:InstallRoot=${CURRENT_PACKAGES_DIR_NATIVE}"
    )
endif()
endif()

# core only solution doesn't build plugins
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/plugins)
