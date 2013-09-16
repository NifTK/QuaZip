project (QuaZip)
cmake_minimum_required(VERSION 2.6)

set(qt_min_version "4.5.0")
find_package(Qt4 REQUIRED)
set(QT_USE_QTGUI false)
include(${QT_USE_FILE})

# Use system zlib on unix and build zlib on Windows
if(UNIX)
	find_package(ZLIB REQUIRED)
else(UNIX)
  include(ExternalProject)
  include(CMakeExternals/zlib.cmake)

  ExternalProject_Get_Property(zlib binary_dir)

  set(ZLIB_DIR ${binary_dir})
  set(ZLIB_INCLUDE_DIRS "${ZLIB_DIR}")
  set(ZLIB_LIBRARY_DIR "${ZLIB_DIR}")
  set(ZLIB_LIBRARIES )
endif(UNIX)

# All build libraries are moved to this directory
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})

set(LIB_SUFFIX "" CACHE STRING "Define suffix of directory name (32/64)")
set(LIB_DESTINATION "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}" CACHE STRING "Library directory name" FORCE)

add_subdirectory(quazip)

configure_file(QuaZipConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/QuaZipConfig.cmake)

install(FILES FindQuaZip.cmake DESTINATION share)
