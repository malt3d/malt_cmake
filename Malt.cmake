cmake_minimum_required(VERSION 3.2)

if (MSVC OR MINGW OR WIN32)
    set(MALT_LIB_TYPE "STATIC")
else()
    set(MALT_LIB_TYPE "SHARED")
endif()

function(malt_def_module module_name)
    if (MSVC OR MINGW OR WIN32)
        target_compile_definitions(${module_name} PUBLIC MALT_STATIC_LIBS=1)
    endif()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/module.json ${CMAKE_BINARY_DIR}/module.json COPYONLY)

    get_target_property(SOURCE_FILES ${module_name} SOURCES)

    foreach(name ${SOURCE_FILES})
        message(STATUS ${name})
    endforeach()
endfunction()

function(malt_def_game target)
    if (MSVC OR MINGW OR WIN32)
        target_compile_definitions(${target} PUBLIC MALT_STATIC_LIBS=1)
    endif()
endfunction()

function(malt_components target)
endfunction()

function(malt_init)
endfunction()

function(malt_dependency to module_name)
    find_package(${module_name} REQUIRED)
    target_link_libraries(${to} PUBLIC ${module_name})
endfunction()

function(malt_install _target HEADER_PATH)
    set(INCLUDE_DEST "include")
    set(LIB_DEST "lib/${_target}")

    set(SHARE_DEST "share/${_target}")

    target_include_directories(${_target} PUBLIC
            $<BUILD_INTERFACE:${HEADER_PATH}/../>
            $<INSTALL_INTERFACE:${INCLUDE_DEST}>)

    install(TARGETS ${_target} DESTINATION "${LIB_DEST}")
    install(FILES ${_target}-config.cmake DESTINATION ${LIB_DEST})
    install(DIRECTORY ${HEADER_PATH} DESTINATION "${INCLUDE_DEST}")

    install(TARGETS ${_target} EXPORT ${_target} DESTINATION "${LIB_DEST}")
    install(EXPORT ${_target} DESTINATION "${LIB_DEST}")

    if (${ARGC} GREATER 2)
        message(STATUS "Have a share dir, install it")
        set(SHARE_PATH ${ARGV2})
        install(DIRECTORY ${SHARE_PATH} DESTINATION "${SHARE_DEST}")
    endif()
endfunction()
