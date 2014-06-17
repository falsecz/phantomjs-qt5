set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_VERSION_MINOR 1)
set(PROJECT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR})

set(DATA_DIR ${CMAKE_INSTALL_PREFIX}/share/${PROJECT_NAME}-${PROJECT_VERSION})

set(WTF_USE_ICU_UNICODE 1)

add_definitions(-DDATA_DIR="${DATA_DIR}")

add_definitions(-DWEBCORE_NAVIGATOR_VENDOR="Research In Motion, Ltd.")
add_definitions(-DBUILDING_BLACKBERRY__)
add_definitions(-DBUILD_WEBKIT)

# Workaround for now so that SK_DEBUG isn't defined in SkPreConfig.h
add_definitions(-DSK_RELEASE)

# TODO: Make this build-time configurable
set(WTF_USE_OPENTYPE_SANITIZER 1)
add_definitions(-DWTF_USE_OPENTYPE_SANITIZER=1)
add_definitions(-DWTF_USE_EXPORT_MACROS=1)

if (ENABLE_GLES2)
    set(WTF_USE_ACCELERATED_COMPOSITING 1)
    add_definitions(-DWTF_USE_ACCELERATED_COMPOSITING=1)
    add_definitions(-DBLACKBERRY_PLATFORM_GRAPHICS_EGL=1)
    add_definitions(-DBLACKBERRY_PLATFORM_GRAPHICS_GLES2=1)
    add_definitions(-DBLACKBERRY_PLATFORM_GRAPHICS_DRAWING_SURFACE=1)
    add_definitions(-DWTF_USE_ARENA_ALLOC_ALIGNMENT_INTEGER=1)
endif ()

if (ADDITIONAL_SYSTEM_INCLUDE_PATH)
    set(CMAKE_INCLUDE_SYSTEM_FLAG_C "-Wp,-isystem")
    set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-Wp,-isystem")
    foreach (directory ${ADDITIONAL_SYSTEM_INCLUDE_PATH})
        include_directories(SYSTEM ${directory})
    endforeach ()
    if (ENABLE_WEBGL)
        include_directories(SYSTEM ${THIRDPARTY_DIR}/ANGLE/include) #As system so as to be lower-priority than actual system headers
    endif ()
endif ()

if (PUBLIC_BUILD)
    message("*** PUBLIC BUILD ***")
else (PUBLIC_BUILD)
    message("*** DRT is ENABLED ***")
endif ()

add_definitions(-D__QNXNTO__)
add_definitions(-D_FILE_OFFSET_BITS=64)
add_definitions(-D_LARGEFILE64_SOURCE)

# Find a library only in the staging directory (which is the CMAKE_INSTALL_PATH)
# TODO: CMAKE_INSTALL_PATH may not be staging directory.
macro(FIND_STAGING_LIBRARY _var _libname)
    find_library(${_var} ${_libname}
        PATHS "${CMAKE_LIBRARY_PATH}"
        ENV "QNX_TARGET"
        PATH_SUFFIXES "${CMAKE_SYSTEM_PROCESSOR}/usr/lib" "${CMAKE_SYSTEM_PROCESSOR}/lib"
        NO_DEFAULT_PATH)
endmacro()

macro(FIND_STAGING_STATIC_LIBRARY _var _libname)
  set(${_var} "-Bstatic -l${_libname} -Bdynamic" CACHE STRING ${_libname})
endmacro()

FIND_STAGING_LIBRARY(JPEG_LIBRARY jpeg)
FIND_STAGING_LIBRARY(PNG_LIBRARY png)
FIND_STAGING_LIBRARY(XML2_LIBRARY xml2)
FIND_STAGING_LIBRARY(XSLT_LIBRARY xslt)
FIND_STAGING_LIBRARY(SQLITE3_LIBRARY sqlite3)
FIND_STAGING_LIBRARY(M_LIBRARY m)
FIND_STAGING_LIBRARY(FREETYPE_LIBRARY freetype)
FIND_STAGING_LIBRARY(ICUData_LIBRARY icudata)
FIND_STAGING_LIBRARY(ICUI18N_LIBRARY icui18n)
FIND_STAGING_LIBRARY(ICUUC_LIBRARY icuuc)
FIND_STAGING_LIBRARY(INTL_LIBRARY intl)
FIND_STAGING_LIBRARY(Z_LIBRARY z)
FIND_STAGING_LIBRARY(CURL_LIBRARY curl)
FIND_STAGING_LIBRARY(WebKitPlatform_LIBRARY webkitplatform)
FIND_STAGING_LIBRARY(EGL_LIBRARY EGL)
FIND_STAGING_LIBRARY(GLESv2_LIBRARY GLESv2)
FIND_STAGING_LIBRARY(HARFBUZZ_LIBRARY harfbuzz)
FIND_STAGING_LIBRARY(FONTCONFIG_LIBRARY fontconfig)
FIND_STAGING_LIBRARY(PROFILING_LIBRARY profilingS)
FIND_STAGING_LIBRARY(LIB_INPUT_UTILITIES input_utilities)
FIND_STAGING_LIBRARY(OTS_LIBRARY ots)
FIND_STAGING_LIBRARY(LEVELDB_LIBRARY leveldb)
FIND_STAGING_LIBRARY(ITYPE_LIBRARY iType)
FIND_STAGING_LIBRARY(WTLE_LIBRARY WTLE)

# Use jpeg-turbo for device build
if (TARGETING_PLAYBOOK)
    FIND_STAGING_STATIC_LIBRARY(JPEG_LIBRARY jpeg-webkit)
else ()
    FIND_STAGING_LIBRARY(JPEG_LIBRARY jpeg)
endif ()

# Add "-fPIC" to CMAKE_SHARED_LIBRARY_C_FLAGS and CMAKE_SHARED_LIBRARY_CXX_FLAGS
# This is because "-fPIC" is not included in the default defines under Modules/Platform/QNX.cmake
set(CMAKE_SHARED_LIBRARY_C_FLAGS "-fPIC ${CMAKE_SHARED_LIBRARY_C_FLAGS}")
set(CMAKE_SHARED_LIBRARY_CXX_FLAGS "-fPIC ${CMAKE_SHARED_LIBRARY_CXX_FLAGS}")

# Show unresolved symbols when doing the final shared object link
if (PROFILING)
    set(BLACKBERRY_LINK_FLAGS "-Wl,-z,defs -Wl,-z,relro -Wl,-E -Wl,--no-keep-memory")
else (PROFILING)
    set(BLACKBERRY_LINK_FLAGS "-Wl,-z,defs -Wl,-z,relro -Wl,--no-keep-memory")
endif ()

# Set custom CFLAGS for our port
if (CMAKE_COMPILER_IS_GNUCC)
    set(CMAKE_CXX_FLAGS "-fno-exceptions -fstack-protector -fno-rtti -Wformat -Wformat-security -Werror=format-security ${CMAKE_CXX_FLAGS}")
    set(CMAKE_C_FLAGS "-fstack-protector -Wformat -Wformat-security -Werror=format-security ${CMAKE_C_FLAGS}")
    set(JSC_LINK_FLAGS "-Wl,-z,defs -Wl,-z,relro -N1024K")
endif ()

if (PROFILING)
    set(CMAKE_CXX_FLAGS "-finstrument-functions -g ${CMAKE_CXX_FLAGS}")
    set(CMAKE_C_FLAGS "-finstrument-functions -g ${CMAKE_C_FLAGS}")
endif ()

# FIXME: Make this more elegant
if (TARGETING_PLAYBOOK)
    set(CMAKE_CXX_FLAGS "-mfpu=neon ${CMAKE_CXX_FLAGS}")
    set(CMAKE_C_FLAGS "-mfpu=neon ${CMAKE_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "-mthumb -mthumb-interwork ${CMAKE_CXX_FLAGS}")
    set(CMAKE_C_FLAGS "-mthumb -mthumb-interwork ${CMAKE_C_FLAGS}")
    # check for BB_RELEASE_FLAGS or BB_DEBUG_FLAGS to set CMAKE_C_FLAGS{DEBUG|RELEASE} CMAKE_CXX_FLAGS{DEBUG|RELEASE}
    if (DEFINED ENV{BB_RELEASE_FLAGS})
        set(CMAKE_CXX_FLAGS_RELEASE  "$ENV{BB_RELEASE_FLAGS} -DNDEBUG")
        set(CMAKE_C_FLAGS_RELEASE  "$ENV{BB_RELEASE_FLAGS} -DNDEBUG")
        message("== ENV override RELEASE ${CMAKE_CXX_FLAGS_RELEASE}")
    endif ()
    if (DEFINED ENV{BB_DEBUG_FLAGS})
        set(CMAKE_CXX_FLAGS_DEBUG "$ENV{BB_DEBUG_FLAGS}")
        set(CMAKE_C_FLAGS_DEBUG "$ENV{BB_DEBUG_FLAGS}")
        message("== ENV override DEBUG ${CMAKE_CXX_FLAGS_DEBUG}")
    endif ()
endif ()

include_directories(${CMAKE_INCLUDE_PATH})

set(WTF_OUTPUT_NAME wtf)
set(JavaScriptCore_OUTPUT_NAME javascriptcore)
set(WebCore_OUTPUT_NAME webcore)
set(WebKit_OUTPUT_NAME webkit)
set(WebKit_DRT_OUTPUT_NAME webkit_DRT)

WEBKIT_OPTION_BEGIN()

WEBKIT_OPTION_DEFINE(ENABLE_EVENT_MODE_METATAGS "Enable meta-tag touch and mouse events" ON)
WEBKIT_OPTION_DEFINE(ENABLE_VIEWPORT_REFLOW "Enable viewport reflow" ON)

WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_BATTERY_STATUS ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_BLOB ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_CONTEXT_MENUS OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_CSS_IMAGE_RESOLUTION ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_CUSTOM_SCHEME_HANDLER ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_DEVICE_ORIENTATION ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_DRAG_SUPPORT OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_DOWNLOAD_ATTRIBUTE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_FAST_MOBILE_SCROLLING ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_FILE_SYSTEM ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_FILTERS ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_FULLSCREEN_API ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_GEOLOCATION ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_HIDDEN_PAGE_DOM_TIMER_THROTTLING ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_IMAGE_DECODER_DOWN_SAMPLING ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_INDEXED_DATABASE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_INPUT_TYPE_COLOR ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_LEGACY_NOTIFICATIONS ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_LEGACY_VIEWPORT_ADAPTION ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_LLINT ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MATHML OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MEDIA_CAPTURE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MEDIA_STREAM ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MICRODATA ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_NAVIGATOR_CONTENT_UTILS ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_NETWORK_INFO ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_NOTIFICATIONS ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_ORIENTATION_EVENTS ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_PAGE_VISIBILITY_API ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_REPAINT_THROTTLING ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_REQUEST_ANIMATION_FRAME ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_SHARED_WORKERS ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_SMOOTH_SCROLLING ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_STYLE_SCOPED ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_TEXT_AUTOSIZING ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_TOUCH_EVENTS ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_TOUCH_SLIDER ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_VIBRATION ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_VIDEO ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_VIDEO_TRACK OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEB_TIMING ON)

if (ENABLE_GLES2)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_3D_RENDERING ON)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_ACCELERATED_2D_CANVAS ON)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_CSS_FILTERS ON)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_CSS_SHADERS ON)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBGL ON)
else ()
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_3D_RENDERING OFF)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_ACCELERATED_2D_CANVAS OFF)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_CSS_FILTERS OFF)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_CSS_SHADERS OFF)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBGL OFF)
endif ()

if (CMAKE_SYSTEM_PROCESSOR MATCHES x86)
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_JIT OFF)
else ()
    WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_JIT ON)
endif ()

WEBKIT_OPTION_END()

add_definitions(-DENABLE_BLACKBERRY_CREDENTIAL_PERSIST=1)

# Some of our files, such as platform/graphics/chromium/ComplexTextControllerLinux.cpp, require a
# newer ICU version than the version associated with the headers in {WebCore, JavaScriptCore}/icu.
# Because of <https://bugs.webkit.org/show_bug.cgi?id=70913> we can't directly reference these newer
# ICU headers within the QNX system header directory. As a workaround, we copy these newer ICU headers
# from the QNX system header directory to a third-party directory under the CMake binary tree.
#
# FIXME: Make this mechanism more general purpose. Maybe accept a list or directories/files to copy
# instead of individual variables. Generalizing this solution may allow us to fix <https://bugs.webkit.org/show_bug.cgi?id=70913>.
set(BLACKBERRY_THIRD_PARTY_DIR "${CMAKE_BINARY_DIR}/ThirdPartyBlackBerry")
file(COPY ${THIRD_PARTY_ICU_DIR} DESTINATION "${BLACKBERRY_THIRD_PARTY_DIR}/icu")
file(COPY ${THIRD_PARTY_UNICODE_FILE} DESTINATION ${BLACKBERRY_THIRD_PARTY_DIR})

set(ICU_INCLUDE_DIRS "${BLACKBERRY_THIRD_PARTY_DIR}/icu")
