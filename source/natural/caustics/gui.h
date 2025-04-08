#pragma once
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <stdexcept>

class Gui
{
public:
	Gui() {};
	~Gui() {};
	// Not used as an instance
	void static init(GLFWwindow& window);
	void static newFrame();
	void static render();
	void static destroy();
};