#include <imgui.h>
#include <imgui_impl_glfw.h>
#include <imgui_impl_opengl3.h>

#define GL_SILENCE_DEPRECATION
#define GLEW_STATIC
#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include "shader.h"


void ScreenShot() {
}


int main(void)
{
    GLFWwindow* window;

    if (!glfwInit())
        return -1;

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    window = glfwCreateWindow(640, 480, "Jimbo", NULL, NULL);

    if (!window)
    {
        glfwTerminate();
        return -1;
    }

    glfwMakeContextCurrent(window);

    // GLEW INIT
    glewExperimental = GL_TRUE;
    GLenum err = glewInit();
    if (err != GLEW_OK) {
        printf("Error: %s\n", glewGetErrorString(err));
        return -1;
    }
    if (!GLEW_VERSION_2_1) {
        printf("Error: OpenGL 2.1 not supported\n");
        return -1;
    }

    // Shader
    Shader myShader("shaders/vert.glsl", "shaders/frag.glsl");
    float vertices[] = {
        // Screen space is x,y \in [-1, 1]
        // positions (tri)   // colors (red, green, blue)
        -1.0f, -1.0f,  1.0f, 0.0f, 0.0f,  // bottom left
         1.0f,  1.0f,  0.0f, 1.0f, 0.0f,  // bottom right
        -1.0f,  1.0f,  0.0f, 0.0f, 1.0f,   // top 
         1.0f,  1.0f, 0.0f, 0.0f, 1.0f,  // top right 
        -1.0f, -1.0f, 0.0f, 1.0f, 0.0f,   // top 
         1.0f, -1.0f, 1.0f, 0.0f, 0.0f,  // bottom
    };

    // Vertex Buffer Object, Vertex Array Object
    unsigned int VBO, VAO; 
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    glBindVertexArray(VAO);

    // buffer rotates with VAO
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    // position attribute
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    // color attribute
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(2 * sizeof(float)));
    glEnableVertexAttribArray(1);

    // Initialize ImGUI
    /* Check OpenGL version */
    const GLubyte* renderer = glGetString(GL_RENDERER); // get renderer string
    const GLubyte* version = glGetString(GL_VERSION); // version as a string
    std::cout << "Renderer: " << renderer << std::endl;
    std::cout << "OpenGL version supported: " << version << std::endl;

	IMGUI_CHECKVERSION();
	ImGui::CreateContext();
	ImGuiIO& io = ImGui::GetIO(); (void)io;
	ImGui::StyleColorsDark();
	ImGui_ImplGlfw_InitForOpenGL(window, true);
	ImGui_ImplOpenGL3_Init("#version 410");

    while (!glfwWindowShouldClose(window))
    {

        glfwPollEvents();

        // Tell OpenGL a new frame is about to begin
		ImGui_ImplOpenGL3_NewFrame();
		ImGui_ImplGlfw_NewFrame();
		ImGui::NewFrame();

        // ImGUI window creation
        ImGui::Begin("Settings");
        ImGui::End();
        ImGui::CloseCurrentPopup();
        

        // Uniforms
        myShader.setFloat("u_time", static_cast<float>(glfwGetTime()));
        int w, h;
        glfwGetWindowSize(window, &w, &h);
        float w_f = static_cast<float>(w);
        float h_f = static_cast<float>(h);
        // apple retina displays
        #ifdef __APPLE__
            w_f *= 2.0;
            h_f *= 2.0;
        #endif
        glVertex2f(w_f, h_f);
        myShader.setVec2("u_resolution", w_f, h_f);
        myShader.use();



        ImVec2 deltaMouse = ImGui::GetMouseDragDelta();
        ImGui::ResetMouseDragDelta();

        // Render
        ImGui::Render();
        int display_w, display_h;
        glfwGetFramebufferSize(window, &display_w, &display_h);
        glViewport(0, 0, display_w, display_h);
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);

        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 6);

		ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());


        glfwMakeContextCurrent(window);
        glfwSwapBuffers(window);

    }

    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);

    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();

    glfwDestroyWindow(window);
    glfwTerminate();
    return 0;
}