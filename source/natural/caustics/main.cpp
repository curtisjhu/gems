#include <imgui.h>

#include "shader.h"
#include "window.h"
#include "gui.h"

#define GL_SILENCE_DEPRECATION
#define GLEW_STATIC
#include <GL/glew.h>
#include <GLFW/glfw3.h>

class Settings
{
public:
    Settings(){};
    float intensity;
};

int main(void)
{

	Window window("Water caustics", 640, 480);
    window.init();
    window.buffer();
    Gui::init(window.window);

    Shader myShader("shaders/vert.glsl", "shaders/frag.glsl");
    
	Settings settings;
	settings.intensity = 0.5f;

    while (window.stillOpen())
    {

        Gui::newFrame();
        ImGui::SetWindowPos(ImVec2({ 0, 0 }));
        ImGui::Begin("Params");
        ImGui::DragFloat("Intensity", &settings.intensity);
        ImGui::End();

        // Uniforms
        myShader.setFloat("u_time", static_cast<float>(glfwGetTime()));
        myShader.setVec2("u_resolution",
            static_cast<float>(window.width),
            static_cast<float>(window.height));
        myShader.use();

        Gui::render();
        window.render();
    }

	Gui::destroy();
    window.destroy();

    return 0;
}