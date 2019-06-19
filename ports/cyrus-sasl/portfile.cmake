include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cyrusimap/cyrus-sasl
    REF cyrus-sasl-2.1.27
    SHA512 2138d4b122da5a326ad94c6c9f6cb0e959f87c2ed991f926afd22a5d4b390ef0380aece689ff48ceb4c0f0ae305a7472fd5b8fe905f800d04a4f0d4e16248644
    HEAD_REF master
    PATCHES AdditionalDirectories.patch lmdb-debug.patch
)

# copy the six headers to our install directory
file(COPY ${SOURCE_PATH}/include/hmac-md5.h DESTINATION ${CURRENT_PACKAGES_DIR}/include/sasl)
file(COPY ${SOURCE_PATH}/include/md5.h DESTINATION ${CURRENT_PACKAGES_DIR}/include/sasl)
file(COPY ${SOURCE_PATH}/include/sasl.h DESTINATION ${CURRENT_PACKAGES_DIR}/include/sasl)
file(COPY ${SOURCE_PATH}/include/saslplug.h DESTINATION ${CURRENT_PACKAGES_DIR}/include/sasl)
file(COPY ${SOURCE_PATH}/include/saslutil.h DESTINATION ${CURRENT_PACKAGES_DIR}/include/sasl)
file(COPY ${SOURCE_PATH}/include/prop.h DESTINATION ${CURRENT_PACKAGES_DIR}/include/sasl)

# update ALL the projects to the latest build tool
vcpkg_execute_required_process(
    COMMAND "devenv.exe"
            "cyrus-sasl-all-in-one.sln"
            /Upgrade
    WORKING_DIRECTORY ${SOURCE_PATH}/win32
    LOGNAME upgrade-${TARGET_TRIPLET}
)

# cyrus-sasl-all-in-one would also build plugin_gssapiv2 but that
# requires a krb library so we build all the other projects
# individually. We also don't want the install project as we do that
# directly with cmake/vcpkg operations.

# this builds common, sasldb, and plugin_sasldb
vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/plugin_sasldb.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
    SKIP_CLEAN
)

# this builds common and all the other plugins except gssapiv2
vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/sasl2.vcxproj
    INCLUDES_SUBPATH include
    LICENSE_SUBPATH COPYING
    REMOVE_ROOT_INCLUDES
    USE_VCPKG_INTEGRATION
)

# move plugins to correct package directory (based on Linux packages)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/sasl2)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/plugin_sasldb.dll ${CURRENT_PACKAGES_DIR}/tools/sasl2/plugin_sasldb.dll)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/plugin_sasldb.pdb ${CURRENT_PACKAGES_DIR}/tools/sasl2/plugin_sasldb.pdb)
# remove unwanted internal libraries from package
file(REMOVE
   ${CURRENT_PACKAGES_DIR}/lib/libcommon.lib
   ${CURRENT_PACKAGES_DIR}/lib/sasldb.lib
   ${CURRENT_PACKAGES_DIR}/lib/plugin_anonymous.lib
   ${CURRENT_PACKAGES_DIR}/lib/plugin_digestmd5.lib
   ${CURRENT_PACKAGES_DIR}/lib/plugin_ntlm.lib
   ${CURRENT_PACKAGES_DIR}/lib/plugin_plain.lib
   ${CURRENT_PACKAGES_DIR}/lib/plugin_sasldb.lib
   ${CURRENT_PACKAGES_DIR}/lib/plugin_scram.lib)

# now the same for debug build
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/tools/sasl2)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/bin/plugin_sasldb.dll ${CURRENT_PACKAGES_DIR}/debug/tools/sasl2/plugin_sasldb.dll)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/bin/plugin_sasldb.pdb ${CURRENT_PACKAGES_DIR}/debug/tools/sasl2/plugin_sasldb.pdb)
# remove unwanted internal libraries from package
file(REMOVE
   ${CURRENT_PACKAGES_DIR}/debug/lib/libcommond.lib
   ${CURRENT_PACKAGES_DIR}/debug/lib/sasldb.lib
   ${CURRENT_PACKAGES_DIR}/debug/lib/plugin_anonymous.lib
   ${CURRENT_PACKAGES_DIR}/debug/lib/plugin_digestmd5.lib
   ${CURRENT_PACKAGES_DIR}/debug/lib/plugin_ntlm.lib
   ${CURRENT_PACKAGES_DIR}/debug/lib/plugin_plain.lib
   ${CURRENT_PACKAGES_DIR}/debug/lib/plugin_sasldb.lib
   ${CURRENT_PACKAGES_DIR}/debug/lib/plugin_scram.lib)
