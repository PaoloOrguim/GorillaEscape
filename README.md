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

   **Paolo Orguim**  
   - Modelagem de todos objetos com excessão das portas.
   - Spotlight da Lanterna
   - Escolha de texturas
   - Confecção dos prédios no Blender
   - Colisões: Prédios, portas, cercas, bananas e gorila.
   - Fog (Neblina a distância)
   - SkyBox
   - Bananas: Mecânica de Coleta
   - Folhas: Curvas de Bezier
   - Efeitos sonoros: Passos, Gorila, Banana e Portas.

## 2. Uso de ferramentas IA 
  As ferramentas ChatGPT e Gemini foram utilizadas pontualmente. Seus principais usos e consequências serão listados abaixo:
   - Guia para confecção de features extras: Por não conhecermos recursos específicos de OpenGL, sempre que estavamos em dúvida se valeria a pena implementar algo extra perguntavamos para a ferramenta o grau de complexidade esperado e por onde começar a procurar na documentação. Isso acelerou o processo e permitiu o corte de features que pareciam simples mas não eram (Movimentação mais inteligente do Gorila, por exemplo).
   - Depuração: Tentamos utilizar a ferramenta para depuração tanto dos arquivos C quanto os shaders. A ferramenta não lidou muito bem e a maior parte da depuração foi feita manualmente. Depuração em C não é um problema para nós, porém depurar os shaders acabou se tornando mais complexo pela falta de conhecimento das técnicas adequadas. Entretanto, em momentos pontuais as ferramentas conseguiram apontar erros bobos que passavam despercebidos.
   - Implementação do fullscreen: O toggle do fullscreen era algo desejado, porém não queriamos dedicar muito tempo para implementá-lo. A função que ativa/desativa o fullscreen foi 100% feita por IA e funcionou perfeitamente. A integração e binding ao F11 foi feita por nós.
   - Divisão de tarefas: Inicialmente, quando o trabalho parecia muito grande e não sabiamos muito bem por onde começar, enviamos o enunciado a ferramenta e pedimos para dividir em sub-tarefas independentes para que conseguíssemos mapear melhor o que cada um faria. A ferramenta foi satisfatória nesse ponto.
   - Geração de script de instalação de dependências com base no makefile.

## 3. Processo de Desenvolvimento
  Como mencionado anteriormente, utilizamos ferramentas de IA inicialmente para detalhar e destrinchar o processo de desenvolvimento. Após isso, dividimos as features por afinidade. Paolo gosta muito da parte de modelagem 3D e ambientação enquanto Érico gosta mais da parte de movimentação e iluminação.  
  Devido as rotinas de cada um, decidimos que cada um implementaria uma serie de features em sequência e depois pararia de mexer para que o outro fizesse sua parte. Esse ciclo foi iterado algumas vezes. Isso foi bom pois evitou problemas de merge (embora as features fossem bastante independentes).  
  Algo que serve como auto critíca é a falta de organização no código. Normalmente o fluxo normal de desenvolvimento seria Idealizar feature -> Prova de Conceito -> (Se funcionar) Integrar no código de forma organizada e Modular.  
  Porém, acabamos empolgando com a adição de features e muitas vezes pulamos a integração organizada e fomos direto para outra feature.  
  Como o desenvolvimento foi feito a 2 e num contexto didático, isso não foi problemático. Porém, em um projeto mais escalável e com mais pessoas com certeza seria um problema.  
  Quanto a aplicação dos conceitos da disciplina, acreditamos que foi bastante satisfatório. A implementação da mecânica das portas foi feita utilizando 100% dos conteúdos aprendidos na disciplina (Transformações Hierárquicas, Transformações no tempo), ficou bastante bacana. As colisões e iluminação, partes complexas para algum leigo na área, também foram implementadas de forma orgânica.  

## 4. Imagens (Diferentes tipos de iluminação)
![gorila](https://github.com/user-attachments/assets/a9aa8518-667e-4da5-8641-f0b9724d408e)
Gorila, o inimigo do jogo. Único objeto com iluminação difusa.

![banana](https://github.com/user-attachments/assets/720574a2-7456-452b-a358-ecd3f60f5f31)
Banana, o objetivo do jogo. Iluminação de Blinn-Phong.

![sombrio](https://github.com/user-attachments/assets/b8dc84a9-7377-4891-bb55-8a1346b48001)
Sem a lanterna ligada, o jogo fica sombrio.

![arvore](https://github.com/user-attachments/assets/420101e4-3b48-4646-b688-cd3327a82967)
Árvore, único objeto com modelo de Gourad. 

## 5. Como Jogar
  Ao iniciar o jogo, o jogador fica em frente a uma placa que ensina os comandos básicos. Eles são:
   - (W,A,S,D) Movimentação
   - (SHIFT) Correr
   - (F) Toggle Lanterna
   - (E) Interagir com objetos (Bananas e Portas)
   - (L) Toggle Câmera Livre
   - (MOUSE) Direção da Câmera
     
![inicio](https://github.com/user-attachments/assets/173e0d3c-1292-4be9-971c-110de0892c43)
Observação: Foto com reflexo pois fois tirada pelo celular. 

## 5. Passos Necessários para Compilação e Execução da Aplicação
  Para compilar e executar a aplicação, basta estar em um ambiente Linux, instalar as dependências e compilar através do make.
  Sinceramente, não nos recordamos de quais bibliotecas instalamos desde o início, então pedimos ao ChatGPT que gerasse um script de instalação com base no makefile. Funcionou para nós, mas caso não funcione é possível ver qual biblioteca faltou pelo log de erro da compilação.
  Passos:
   - Baixar arquivos do github.
   - Ir para raiz do projeto.
   - Executar script de instalação de dependências: sudo ./install_deps.sh    (Caso não funcione, habilite execução com   chmod +x install_deps.sh)
   - Compilar e executar: make run    (Caso erro de compilação, revisar se faltou alguma lib.)
   - Pode aparecer o aviso de que o programar parou de funcionar, basta esperar um pouco.
   - Fim!

