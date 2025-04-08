#pragma once
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <imgui.h>
#include <imgui_impl_glfw.h>
#include <imgui_impl_opengl3.h>

class Gui
{
public:
	// Not used as an instance
	static void init(GLFWwindow *window);
	static void newFrame();
	static void render();
	static void destroy();
};