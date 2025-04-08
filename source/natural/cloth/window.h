#pragma once
#include <GL/glew.h>
#include <GLFW/glfw3.h>


class Window
{
public:
	Window() :
		title("Template"),
		width(640), height(480),
		VAO(0), VBO(0)
		{};

	Window(const char* title,
		int width,
		int height) :
			title(title),
			width(width), height(height),
			VAO((unsigned int) 0), VBO((unsigned int) 0) {};

	GLFWwindow* window;
    float vertices[30] = {
        // Screen space is x,y \in [-1, 1]
        // positions (tri)   // colors (red, green, blue)
        -1.0f, -1.0f,  1.0f, 0.0f, 0.0f,  // bottom left
         1.0f,  1.0f,  0.0f, 1.0f, 0.0f,  // bottom right
        -1.0f,  1.0f,  0.0f, 0.0f, 1.0f,   // top 
         1.0f,  1.0f, 0.0f, 0.0f, 1.0f,  // top right 
        -1.0f, -1.0f, 0.0f, 1.0f, 0.0f,   // top 
         1.0f, -1.0f, 1.0f, 0.0f, 0.0f,  // bottom
    };
	unsigned int VAO, VBO;
	int width;
	int height;
	const char* title;

	void init();
	void buffer();
	bool stillOpen();
	void render();
	void destroy();
};
