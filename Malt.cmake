cmake_minimum_required(VERSION 3.5)

function(malt_def_module module_name)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/module.json ${CMAKE_BINARY_DIR}/module.json COPYONLY)
endfunction()

function(malt_init)
    add_custom_target(
        init_build
        COMMAND python3 ${CMAKE_CURRENT_SOURCE_DIR}/../malt_tool/build_init.py
    )
    add_dependencies(malt_game init_build)
endfunction()

function(malt_add_module to module_name)
    find_package(${module_name} REQUIRED)
    target_link_libraries(${to} PUBLIC ${module_name})
endfunction()

function(malt_install _target HEADER_PATH)
    set(INCLUDE_DEST "include")
    set(LIB_DEST "lib/${_target}")

    target_include_directories(${_target} PUBLIC
            $<BUILD_INTERFACE:${HEADER_PATH}/../>
            $<INSTALL_INTERFACE:${INCLUDE_DEST}>)

    install(TARGETS ${_target} DESTINATION "${LIB_DEST}")
    install(FILES ${_target}-config.cmake DESTINATION ${LIB_DEST})
    install(DIRECTORY ${HEADER_PATH} DESTINATION "${INCLUDE_DEST}")

    install(TARGETS ${_target} EXPORT ${_target} DESTINATION "${LIB_DEST}")
    install(EXPORT ${_target} DESTINATION "${LIB_DEST}")
endfunction()