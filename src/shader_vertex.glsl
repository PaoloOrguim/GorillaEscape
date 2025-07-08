#version 330 core

// Atributos de vértice recebidos como entrada ("in") pelo Vertex Shader.
// Veja a função BuildTrianglesAndAddToVirtualScene() em "main.cpp".
layout (location = 0) in vec4 model_coefficients;
layout (location = 1) in vec4 normal_coefficients;
layout (location = 2) in vec2 texture_coefficients;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform sampler2D TextureImage12;    // Grass

// Atributos de vértice que serão gerados como saída ("out") pelo Vertex Shader.
// ** Estes serão interpolados pelo rasterizador! ** gerando, assim, valores
// para cada fragmento, os quais serão recebidos como entrada pelo Fragment
// Shader. Veja o arquivo "shader_fragment.glsl".
out vec4 position_world;
out vec4 position_model;
out vec4 normal;
out vec2 texcoords;
out vec3 gouraudColor;

// BEGIN MODIFICATION: New output for skybox texture coordinates
out vec3 texCoordsSkybox;
// END MODIFICATION: New output for skybox texture coordinates

void main()
{
    // A variável gl_Position define a posição final de cada vértice
    // OBRIGATORIAMENTE em "normalized device coordinates" (NDC), onde cada
    // coeficiente estará entre -1 e 1 após divisão por w.
    // Veja {+NDC2+}.
    //
    // O código em "main.cpp" define os vértices dos modelos em coordenadas
    // locais de cada modelo (array model_coefficients). Abaixo, utilizamos
    // operações de modelagem, definição da câmera, e projeção, para computar
    // as coordenadas finais em NDC (variável gl_Position). Após a execução
    // deste Vertex Shader, a placa de vídeo (GPU) fará a divisão por W. Veja
    // slides 41-67 e 69-86 do documento Aula_09_Projecoes.pdf.

    gl_Position = projection * view * model * model_coefficients;

    // Como as variáveis acima  (tipo vec4) são vetores com 4 coeficientes,
    // também é possível acessar e modificar cada coeficiente de maneira
    // independente. Esses são indexados pelos nomes x, y, z, e w (nessa
    // ordem, isto é, 'x' é o primeiro coeficiente, 'y' é o segundo, ...):
    //
    //     gl_Position.x = model_coefficients.x;
    //     gl_Position.y = model_coefficients.y;
    //     gl_Position.z = model_coefficients.z;
    //     gl_Position.w = model_coefficients.w;
    //

    // Agora definimos outros atributos dos vértices que serão interpolados pelo
    // rasterizador para gerar atributos únicos para cada fragmento gerado.

    // Posição do vértice atual no sistema de coordenadas global (World).
    position_world = model * model_coefficients;

    // Posição do vértice atual no sistema de coordenadas local do modelo.
    position_model = model_coefficients;

    // Normal do vértice atual no sistema de coordenadas global (World).
    // Veja slides 123-151 do documento Aula_07_Transformacoes_Geometricas_3D.pdf.
    normal = inverse(transpose(model)) * normal_coefficients;
    normal.w = 0.0;

    // Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
    texcoords = texture_coefficients;

    // <eslgastal> When using the `texture(...)` function in GLSL with
    // a `samplerCube` texture, the function reads from the cube map
    // texture by interpreting the lookup coordinate as a 3D direction
    // vector, not as a direct 2D UV coordinate for a single face.
    //
    // This direction vector should point from the center of the
    // "environment cube" (that surrounds the scene), towards the
    // desired point on the cube.
    //
    // Since in file:main.cpp we centered the cube on the camera, we
    // can compute the direction vector for each cube vertex by
    // subtracting the vertex location from the camera position.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;
    texCoordsSkybox = (position_world - camera_position).xyz;


    vec3 n = normalize(normal.xyz);
    vec3 p = position_world.xyz;
    vec3 camPos = (inverse(view) * vec4(0,0,0,1)).xyz;

    // luz pontual branca na câmera (exemplo simples)
    vec3 l = normalize(camPos - p);
    vec3 v = normalize(camPos - p);
    vec3 r = reflect(-l, n);

    vec3 Ia = vec3(0.1);          // ambiente
    vec3 Id = vec3(1.0);          // difusa
    vec3 Is = vec3(1.0);          // especular
    float shininess = 32.0;
    float U = 0.0;
    float V = 0.0;
    U = texcoords.x;
    V = texcoords.y;

    vec3 Kd = texture(TextureImage12, vec2(U,V)).rgb;
    vec3 Ks = vec3(0.0);
    vec3 Ka = texture(TextureImage12, vec2(U,V)).rgb;          

    float lambert = max(dot(n,l),0.0);
    float spec    = pow(max(dot(r,v),0.0), shininess);

    gouraudColor = Ka*Ia + Kd*Id*lambert + Ks*Is*spec;
}

