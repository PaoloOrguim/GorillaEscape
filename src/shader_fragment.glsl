#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;


// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define BANANA 0
#define GORILLA  1
#define PLANE  2
#define BUILDING 3
#define DOME 4
#define LEAF_04 5
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;    //  Building
uniform sampler2D TextureImage1;    // Gorilla
uniform sampler2D TextureImage2;    // Grass
uniform sampler2D TextureImage3;    // Banana
uniform sampler2D TextureImage4;    // Domo
uniform sampler2D TextureImage5;    // Leaf_04 Kd
uniform sampler2D TextureImage6;    // Leaf_04 texture

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.
    vec4 p = position_world;

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);

    // Implementação de fonte de luz do tipo spotlight com abertura de 30º
    vec4 light_position  = camera_position;

    // direção da câmera em world space:
    vec4 forward_cam    = vec4(0.0, 0.0, -1.0, 0.0);
    vec3 camera_forward = normalize( (inverse(view) * forward_cam).xyz );
    // agora a spotlight “olha” junto com a câmera:
    vec4 light_direction = vec4(camera_forward, 0.0);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    //vec4 l = normalize(vec4(1.0,1.0,0.0,0.0));
    vec4 l = normalize(light_position - p);

    // Verifica se o ponto está dentro do cone de luz do spotlight
    // Luz liga de 0 a 8 graus
    float opening_angle = dot(l, -light_direction);
    float innerAngle0 = radians(0.0);   // ângulo interno do cone de luz
    float outerAngle0 = radians(8.0);   // ângulo externo do cone de luz
    float innerCutoff0 = cos(innerAngle0);
    float outerCutoff0 = cos(outerAngle0);
    float spotFactor0 = smoothstep( outerCutoff0, innerCutoff0, opening_angle );   // Fator de suavização do cone de luz




    // Testes novos de lanterna inicio

    // Luz desliga de 8 a 10 graus
    float innerAngle2 = radians(0.0);   // ângulo interno do cone de luz
    float outerAngle2 = radians(10.0);   // ângulo externo do cone de luz
    float innerCutoff2 = cos(innerAngle2);
    float outerCutoff2 = cos(outerAngle2);
    float spotFactor2 = -smoothstep( outerCutoff2, innerCutoff2, opening_angle );   // Fator de suavização do cone de luz

    // Luz liga de 10 a 15 graus
    float innerAngle1 = radians(0.0);   // ângulo interno do cone de luz
    float outerAngle1 = radians(15.0);   // ângulo externo do cone de luz
    float innerCutoff1 = cos(innerAngle1);
    float outerCutoff1 = cos(outerAngle1);
    float spotFactor1 = smoothstep( outerCutoff1, innerCutoff1, opening_angle );   // Fator de suavização do cone de luz

    // Luz desliga de 15 a 22 graus
    float innerAngle4 = radians(0.0);   // ângulo interno do cone de luz
    float outerAngle4 = radians(22.0);   // ângulo externo do cone de luz
    float innerCutoff4 = cos(innerAngle4);
    float outerCutoff4 = cos(outerAngle4);
    float spotFactor4 = -smoothstep( outerCutoff4, innerCutoff4, opening_angle );   // Fator de suavização do cone de luz

    // Luz liga de 22 a 25 graus
    float innerAngle3 = radians(0.0);   // ângulo interno do cone de luz
    float outerAngle3 = radians(25.0);   // ângulo externo do cone de luz
    float innerCutoff3 = cos(innerAngle3);
    float outerCutoff3 = cos(outerAngle3);
    float spotFactor3 = smoothstep( outerCutoff3, innerCutoff3, opening_angle );   // Fator de suavização do cone de luz

    float ringFactor = spotFactor0 + spotFactor1;// + spotFactor2;// + spotFactor3;

    // ringFactor = clamp(ringFactor, 0.0, 1.0);

    // Testes novos de lanterna fim

    vec4 r = -l + 2 * n * dot(n, l);

    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;
    vec3 texColor = vec3(0.0, 0.0, 0.0);

    // Obtemos a refletância difusa a partir da leitura da imagem TextureImage0
    vec3 Kd0 = texture(TextureImage0, vec2(U,V)).rgb;
    vec3 Kd1 = texture(TextureImage1, vec2(U,V)).rgb;

    if ( object_id == BANANA )
    {
        // PREENCHA AQUI as coordenadas de textura da esfera, computadas com
        // projeção esférica EM COORDENADAS DO MODELO. Utilize como referência
        // o slides 134-150 do documento Aula_20_Mapeamento_de_Texturas.pdf.
        // A esfera que define a projeção deve estar centrada na posição
        // "bbox_center" definida abaixo.

        // Você deve utilizar:
        //   função 'length( )' : comprimento Euclidiano de um vetor
        //   função 'atan( , )' : arcotangente. Veja https://en.wikipedia.org/wiki/Atan2.
        //   função 'asin( )'   : seno inverso.
        //   constante M_PI
        //   variável position_model

        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        // Vetor que sai do centro e cruza os pontos do objeto e da esfera de textura
        vec4 normalized_position_model = normalize(position_model - bbox_center);

        // Angulos obtidos a partir das coordenadas px, py e pz
        float theta = atan(normalized_position_model.z, normalized_position_model.x);
        float phi = asin(normalized_position_model.y);

        U = texcoords.x;
        V = texcoords.y;
        Kd0 = texture(TextureImage3, vec2(U,V)).rgb;
        texColor = texture(TextureImage3, vec2(U,V)).rgb;

    }
    else if ( object_id == GORILLA )
    {
        // PREENCHA AQUI as coordenadas de textura do coelho, computadas com
        // projeção planar XY em COORDENADAS DO MODELO. Utilize como referência
        // o slides 99-104 do documento Aula_20_Mapeamento_de_Texturas.pdf,
        // e também use as variáveis min*/max* definidas abaixo para normalizar
        // as coordenadas de textura U e V dentro do intervalo [0,1]. Para
        // tanto, veja por exemplo o mapeamento da variável 'p_v' utilizando
        // 'h' no slides 158-160 do documento Aula_20_Mapeamento_de_Texturas.pdf.
        // Veja também a Questão 4 do Questionário 4 no Moodle.

        // float minx = bbox_min.x;
        // float maxx = bbox_max.x;

        // float miny = bbox_min.y;
        // float maxy = bbox_max.y;

        // float minz = bbox_min.z;
        // float maxz = bbox_max.z;

        // U = (position_model.x - minx) / (maxx - minx);  // Vide questionario 4 - questao 4
        // V = (position_model.y - miny) / (maxy - miny);
        U = texcoords.x; 
        V = texcoords.y;
        Kd0 = texture(TextureImage1, vec2(U,V)).rgb;
        
        texColor = texture(TextureImage1, vec2(U,V)).rgb;
        //U = 0.0;
        //V = 0.0;
    }
    else if ( object_id == BUILDING )
    {
        // Coordenadas de textura do predio
        // Obtidas pelo arquivo .obj
        U = texcoords.x;
        V = texcoords.y;
        Kd0 = texture(TextureImage0, vec2(U,V)).rgb;
        texColor = texture(TextureImage0, vec2(U,V)).rgb;
    }
    else if ( object_id == PLANE )
    {
        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;
        Kd0 = texture(TextureImage2, vec2(U,V)).rgb;
        texColor = texture(TextureImage2, vec2(U,V)).rgb;
    }
    else if ( object_id == DOME )
    {
        // Coordenadas de textura do domo, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;
        Kd0 = texture(TextureImage4, vec2(U,V)).rgb;
        texColor = texture(TextureImage4, vec2(U,V)).rgb;
    }
    else  if ( object_id == LEAF_04 )
    {
        // Coordenadas de textura da folha, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;
        Kd0 = texture(TextureImage5, vec2(U,V)).rgb;
        texColor = texture(TextureImage5, vec2(U,V)).rgb;
    }
    else
    {
        // Caso não seja nenhum dos objetos acima, a cor é preta.
        Kd0 = vec3(0.0, 0.0, 0.0);
        texColor = vec3(0.0, 0.0, 0.0);
    }

    // Espectro da luz ambiente
    vec3 Ia = vec3(0.003,0.003,0.003);
    vec3 ambient_term = texColor * Ia;

    // Equação de Iluminação
    float lambert0 = max(0,dot(n,l));
    float lambert1 = max(0,dot(n,-l));  // Atentar para o termo "-l" que garante a renderização final correta

    //vec3 diffuse  = (Kd0 * lambert0 + Kd1 * lambert1) * spotFactor;
    //vec3 diffuse  = (Kd0 * lambert0) * spotFactor0;

    //testes lanterna nova inicio

    vec3 diffuse  = (Kd0 * lambert0) * spotFactor0
                  + (Kd0 * lambert0) * spotFactor1
                  + (Kd0 * lambert0) * spotFactor2
                  + (Kd0 * lambert0) * spotFactor3
                  + (Kd0 * lambert0) * spotFactor4;

    //testes lanterna nova fim


    color.rgb = diffuse + ambient_term;    
    
    //color.rgb = Kd0 * (lambert0 + 0.01) + Kd1 * (lambert1 + 0.01);

    // NOTE: Se você quiser fazer o rendering de objetos transparentes, é
    // necessário:
    // 1) Habilitar a operação de "blending" de OpenGL logo antes de realizar o
    //    desenho dos objetos transparentes, com os comandos abaixo no código C++:
    //      glEnable(GL_BLEND);
    //      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // 2) Realizar o desenho de todos objetos transparentes *após* ter desenhado
    //    todos os objetos opacos; e
    // 3) Realizar o desenho de objetos transparentes ordenados de acordo com
    //    suas distâncias para a câmera (desenhando primeiro objetos
    //    transparentes que estão mais longe da câmera).
    // Alpha default = 1 = 100% opaco = 0% transparente
    color.a = 1;

    // Cor final com correção gamma, considerando monitor sRGB.
    // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    color.rgb = pow(color.rgb, vec3(1.0,1.0,1.0)/2.2);
} 

