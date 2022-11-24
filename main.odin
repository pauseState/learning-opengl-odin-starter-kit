package main

import "core:fmt"

import "vendor:glfw"
import gl "vendor:OpenGL"

WIDTH  :: 1024
HEIGHT :: 768
TITLE  :: "Learning OpenGL"

GL_MAJOR_VERSION :: 3
GL_MINOR_VERSION :: 3

resize_framebuffer :: proc "c" (window_handle: glfw.WindowHandle, width, height: i32) {
    gl.Viewport(0, 0, width, height)
}

process_input :: proc (window_handle: glfw.WindowHandle) {
    if (glfw.GetKey(window_handle, glfw.KEY_ESCAPE) == glfw.PRESS) do glfw.SetWindowShouldClose(window_handle, true)
}

main :: proc () {
    if !bool(glfw.Init()) {
        fmt.eprintln("GLFW failed to load.")
        return
    }

    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    
    when ODIN_OS == .Darwin {
        glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, 1)
    }

    window_handle := glfw.CreateWindow(WIDTH, HEIGHT, TITLE, nil, nil)

    defer glfw.Terminate()
    defer glfw.DestroyWindow(window_handle)

    if window_handle == nil {
        fmt.eprintln("GLFW failed to load the window.")
        return
    }

    glfw.MakeContextCurrent(window_handle)
    gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

    glfw.SetFramebufferSizeCallback(window_handle, resize_framebuffer)

    gl.Viewport(0, 0, WIDTH, HEIGHT)

    for !glfw.WindowShouldClose(window_handle) {
        glfw.PollEvents()

        process_input(window_handle)

        gl.ClearColor(0.5, 0.0, 1.0, 1.0)
        gl.Clear(gl.COLOR_BUFFER_BIT)

        glfw.SwapBuffers(window_handle)
    }
}
