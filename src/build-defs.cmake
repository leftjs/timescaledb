# Hide symbols by default in shared libraries
if(NOT USE_DEFAULT_VISIBILITY)
  set(CMAKE_C_VISIBILITY_PRESET "hidden")
endif()

if (UNIX)
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -L${PG_LIBDIR}")
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -L${PG_LIBDIR}")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${PG_CFLAGS}")
  set(CMAKE_CPP_FLAGS "${CMAKE_CPP_FLAGS} ${PG_CPPFLAGS}")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g")
endif (UNIX)

if (APPLE)
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -multiply_defined suppress")
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -multiply_defined suppress -Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs -bundle_loader ${PG_BINDIR}/postgres")
elseif (WIN32)
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /MANIFEST:NO")
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /MANIFEST:NO")
endif (APPLE)

include_directories(${PROJECT_SOURCE_DIR}/src ${PROJECT_BINARY_DIR}/src ${PG_INCLUDEDIR_SERVER})

# Only Windows and FreeBSD need the base include/ dir instead of include/server/, and including
# both causes problems on Ubuntu where they frequently get out of sync
if (WIN32 OR (CMAKE_SYSTEM_NAME STREQUAL "FreeBSD"))
  include_directories(${PG_INCLUDEDIR})
endif ()

if (WIN32)
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${PG_LIBDIR}/postgres.lib ws2_32.lib Version.lib")
  set(CMAKE_C_FLAGS "-D_CRT_SECURE_NO_WARNINGS")
  include_directories(${PG_INCLUDEDIR_SERVER}/port/win32)

  if (MSVC)
    include_directories(${PG_INCLUDEDIR_SERVER}/port/win32_msvc)
  endif (MSVC)
endif (WIN32)

# Name of library with test-specific code
set(TESTS_LIB_NAME ${PROJECT_NAME}-tests)
