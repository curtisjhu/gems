#pragma once
#include <GL/glew.h>
#include <GLFW/glfw3.h>


class Window
{
public:
	Window(GLFWwindow* win) : window(win) {
		unsigned int VAO = 0, VBO = 0;
		unsigned int width = 640;
		unsigned int height = 480;
		const char* title = "Template";
	};
	Window(GLFWwindow* win,
		const char* title,
		unsigned int width,
		unsigned int height) :
	window(win), title(title), width(width), height(height) {
		unsigned int VAO = 0, VBO = 0;
	};

	~Window() {};

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
	unsigned int width;
	unsigned int height;
	const char* title;

	void init();
	void buffer();
	bool stillOpen();
	void render();
	void destroy();
};
