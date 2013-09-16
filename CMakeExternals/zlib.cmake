#
# zlib
#
# Builds static zlib library on Windows.
#

# Sanity checks
if(DEFINED zlib_DIR AND NOT EXISTS ${zlib_DIR})
  message(FATAL_ERROR "zlib_DIR variable is defined but corresponds to non-existing directory")
endif()

set(zlib_enabling_variable zlib_LIBRARIES)

set(proj zlib)
set(proj_DEPENDENCIES)

set(${zlib_enabling_variable}_LIBRARY_DIRS zlib_LIBRARY_DIRS)
set(${zlib_enabling_variable}_INCLUDE_DIRS zlib_INCLUDE_DIRS)
set(${zlib_enabling_variable}_FIND_PACKAGE_CMD zlib)

if(NOT DEFINED zlib_DIR)

  set(revision_tag "66a753054b356da85e1838a081aa94287226823e")
  if(${proj}_REVISION_TAG)
    set(revision_tag ${${proj}_REVISION_TAG})
  endif()

  set(location_args )
  if(${proj}_URL)
    set(location_args URL ${${proj}_URL})
  elseif(${proj}_GIT_REPOSITORY)
    set(location_args GIT_REPOSITORY ${${proj}_GIT_REPOSITORY}
                      GIT_TAG ${revision_tag})
  else()
    set(location_args GIT_REPOSITORY "http://github.com/commontk/zlib.git"
                      GIT_TAG ${revision_tag})
    #set(location_args URL ....tar.gz)
  endif()

  set(ep_project_include_arg)
  #if(CTEST_USE_LAUNCHERS)
  #  set(ep_project_include_arg
  #    "-DCMAKE_PROJECT_zlib_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
  #endif()

  ExternalProject_Add(${proj}
    SOURCE_DIR ${proj}-src
    BINARY_DIR ${proj}-build
    PREFIX ${proj}-cmake
    ${location_args}
    UPDATE_COMMAND ""
    INSTALL_COMMAND ""
    CMAKE_GENERATOR ${gen}
    CMAKE_CACHE_ARGS
      ${ep_common_cache_args}
      ${ep_project_include_arg}
      ## CXX should not be needed, but it a cmake default test
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DBUILD_SHARED_LIBS:BOOL=OFF
     ${EXTERNAL_PROJECT_OPTIONAL_ARGS}
   DEPENDS
      ${proj_DEPENDENCIES}
    )
  set(zlib_DIR ${proj}-build)
  set(QuaZip_ZLIB_ROOT ${zlib_DIR})
  set(QuaZip_ZLIB_INCLUDE_DIR ${zlib_DIR})
  set(QuaZip_ZLIB_LIBRARY_DIR ${zlib_DIR})

  if(WIN32)
    set(QuaZip_ZLIB_LIBRARY ${QuaZip_ZLIB_LIBRARY_DIR}/zlib.lib )
  else()
    set(QuaZip_ZLIB_LIBRARY     ${QuaZip_ZLIB_LIBRARY_DIR}/libzlib.a )
  endif()

  # Since the link directories associated with zlib is used, it makes sense to
  # update CTK_EXTERNAL_LIBRARY_DIRS with its associated library output directory
#  list(APPEND QuaZip_EXTERNAL_LIBRARY_DIRS ${zlib_DIR})

#else()
#  ctkMacroEmptyExternalproject(${proj} "${proj_DEPENDENCIES}")
endif()

#list(APPEND CTK_SUPERBUILD_EP_VARS zlib_DIR:PATH)
