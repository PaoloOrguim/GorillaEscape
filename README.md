# GorillaEscape

# Relatório

## 1. Contribuições de Cada Membro

   **Érico Breyer**  
   - Modelos de Iluminação
   - Toggle Lanterna
   - Portas: Modelagem, Transformação Hierárquica e Mecânica de movimento ao abrir e fechar.
   - Câmera Livre
   - Movimentação do Jogador
   - F11 ativa Full Screen (Função feita pelo GPT, Integração e key binding feita pelo membro)
   - Correr no shift
   - Gorila: Toda mecânica de movimentação, velocidade gradual.

   - **Paolo Orguim**  
   - Modelagem de todos objetos com excessão das portas.
   - Spotlight da Lanterna
   - Escolha de texturas
   - Confecção dos prédios no Blender
   - Colisões: Prédios, portas, cercas, bananas e gorila.
   - Fog (Neblina a distância)
   - SkyBox
   - Bananas: Mecânica de Coleta
   - Folhas: Curvas de Bezier
   - Até 09/05/2025: preencher formulário com integrantes e descrição do projeto.  
   - Incluir em `hash-entrega.txt` o hash do commit final e a URL do repositório.
   - Efeitos sonoros: Passos, Gorila, Banana e Portas.

2. **Código Próprio (< 15 %)**  
   - Máximo de 15 % de código de terceiros (identificar cada trecho com `// FONTE: …`).  
   - Uso de código extra será considerado plágio e receberá nota zero.

3. **Interação & Performance**  
   - Entrada em tempo real (mouse + teclado).  
   - FPS estável, sem travamentos que prejudiquem a jogabilidade.

4. **Lógica Não‑Trivial**  
   - Deve existir objetivo ou gameplay (jogo ou aplicação interativa) — não basta “carregar e rotacionar modelo”.

5. **Matrizes “Na Mão”**  
   - Implementar Model, View e Projection manualmente.  
   - **Não** usar `gluLookAt`, `glm::lookAt`, `glm::perspective` etc.

6. **Transformações pelo Usuário**  
   - O usuário deve poder controlar transformações em **objetos** (não apenas câmera).

7. **Múltiplas Câmeras**  
   - Implementar pelo menos duas câmeras distintas (ex.: look‑at e livre).

8. **Instâncias de Objetos**  
   - Desenhar um mesmo modelo com duas ou mais instâncias (diferentes Model matrices).

9. **Colisões**  
   - Ministrar pelo menos três testes de interseção diferentes (ex.: ponto‑esfera, cubo‑plano, cubo‑cubo).  
   - Código de colisões em arquivo separado: `collisions.cpp`.

10. **Iluminação**  
    - Implementar modelos difuso (Lambert) e especular (Blinn‑Phong).  
    - Incluir um objeto com **Gouraud** (vertex‑lighting) e outro com **Phong** (pixel‑lighting).

11. **Mapeamento de Texturas**  
    - **Todos** os objetos usam texturas (mínimo 3 imagens diferentes).  
    - UVs corretamente mapeadas (sem esticamentos visíveis).

12. **Curva de Bézier Cúbica**  
    - Pelo menos um objeto move-se seguindo uma curva de Bézier cúbica.

13. **Animação Baseada em Tempo**  
    - Movimentações (objetos e câmera) dependem de Δt, garantindo velocidade estável independente do FPS.

14. **Entrega Completa**  
    - ZIP contendo:  
      - código-fonte completo (com `collisions.cpp`),  
      - `hash-entrega.txt`,  
      - binário + dependências,  
      - `README.md` com instruções de compilação/uso,  
      - ≥ 2 capturas de tela,  
      - link ou MP4 do vídeo de apresentação (3–5 min).

---

## 2. Itens Opcionais (Bônus)

- Rasterização de curvas/pads de Bézier  
- Efeitos sonoros (ex.: miniaudio)  
- Sistema de partículas  
- Sombras (shadow‑mapping, soft shadows)  
- Billboards / Sprites  
- Interface Gráfica (ImGui)  
- Rasterização de texto avançada (FreeType‑GL)  
- Picking (seleção por mouse)  
- Mapeamento avançado (normal/bump/displacement/environment)  
- Ciclo dia/noite com skybox animado  
- Qualquer outra funcionalidade de CG interativa  
