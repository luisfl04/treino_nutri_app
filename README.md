# App para gerenciamento de treinos e alimentação 
## TreinoNutri+

# 1 Escopo

O **Treino+Nutri** é um aplicativo mobile desenvolvido para auxiliar usuários no gerenciamento integrado de treinos físicos e alimentação, promovendo uma rotina mais saudável e organizada.
A aplicação permitirá que o usuário cadastre, edite e acompanhe seus treinos e refeições diárias, além de registrar seu progresso físico ao longo do tempo. Também será possível definir metas pessoais, como emagrecimento ou ganho de massa muscular, e visualizar indicadores relevantes em um painel resumido (dashboard).

# 2 Analise de requisitos 

## 2.1 Requisitos Funcionais

- **RF01** – Cadastro de usuário  
- **RF02** – Login de usuário  
- **RF03** – Logout  
- **RF04** – CRUD de treinos (criar, listar, atualizar e excluir)  
- **RF05** – CRUD de alimentação (registro de refeições)  
- **RF06** – Registro de progresso (peso, medidas corporais, etc.)  
- **RF07** – Definição de metas (emagrecimento, ganho de massa, etc.)  
- **RF08** – Histórico de treinos realizados  
- **RF09** – Histórico de alimentação    
- **RF10** – Upload de imagens (refeições ou progresso físico)  
- **RF11** – Dashboard com resumo (calorias, treinos e evolução)  

## 2.2 Requisitos Não Funcionais

- **RNF01** – Interface simples, intuitiva e de fácil uso  
- **RNF02** – Aplicação leve e otimizada  
- **RNF03** – Responsividade para diferentes tamanhos de smartphones  

# 3 Tecnologias Utilizadas

- Flutter  
- Pacotes do externos Pub.dev(Sqflite, path e etc...)

# 4 Arquitetura do Sistema
A arquitetura escolhida foi MVC (Model-View-Controller) pelo fato de ela ser perfeita para aplicações que precisam ser desenvolvidades em curto periodo de tempo. Onde ela ficou dividida como:

  - Pages A camada de visualização das interfaces de usuario
    
  - Controllers Responsáveis por controlar o fluxo da aplicação, recebendo as ações do usuário, processando as regras de negócio e realizando      a comunicação entre as Pages e os Models.
    
  - Models (Responsáveis por representar e estruturar os dados da aplicação, contendo os atributos e regras relacionadas às entidades do           sistema.
    
  - Repositories Camada responsável pelo acesso e manipulação dos dados, realizando operações como cadastro, consulta, atualização e remoção       no banco de dados.
    
  - DataBase Responsável pelo armazenamento persistente das informações da aplicação, garantindo organização, integridade e recuperação dos        dado.
    
  - Widgets Componentes reutilizáveis da interface gráfica utilizados para construir telas de forma modular, organizada e padronizada.

# 5 Design de Interface (UI/UX)

O design da aplicação foi pensado para atender os padrões atuais de design e experiencia de usuario, trazendo uma interface intuitiva e de facil uso para o usuario final, a usabilidade e experiencia do usuario foram foi uma das preucpações constante no desenvolvimento sempre buscando a facilidade de uso de cada tela.
A ferramenta utilizada para a prototipação das telas foi o figma e os ajustes finais foram feitos no propio ambiente de desenvolvimento (Visual Studio Code), utilizando o recurso do hotreload e hotrestart para ter um feedback instantâneo dos resultados.

 ## Link para o figma
 
https://www.figma.com/proto/4o9kSenBvSDExOQGwopYwJ/Projeto-Prog.Mobile-TreinoNutri-?page-id=0%3A1&node-id=3-60&t=GTcD0eMI5wy6WwPf-0&scaling=scale-down&content-scaling=fixed
