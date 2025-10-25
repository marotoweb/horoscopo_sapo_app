[![GitHub Latest Release][releases_shield]][latest_release]
[![GitHub All Releases][downloads_total_shield]][releases]

[latest_release]: https://github.com/marotoweb/horoscopo_sapo_app/releases/latest

[releases_shield]: https://img.shields.io/github/release/marotoweb/horoscopo_sapo_app.svg?style=popout

[releases]: https://github.com/marotoweb/horoscopo_sapo_app/releases

[downloads_total_shield]: https://img.shields.io/github/downloads/marotoweb/horoscopo_sapo_app/total

# Horóscopo SAPO (V2)

## Sobre o Projeto

Esta é a **Versão 2** da aplicação **Horóscopo SAPO**, uma aplicação móvel desenvolvida em Flutter que permite aos utilizadores consultar as previsões astrológicas diárias, semanais, mensais e anuais para todos os signos do zodíaco, com base nos dados públicos do portal SAPO Signos.

Esta versão foi completamente reescrita para ser uma aplicação moderna, robusta e eficiente, incorporando funcionalidades avançadas como um sistema de cache, tema claro/escuro e uma interface de utilizador refinada.

![Screenshot da Aplicação](https://github.com/marotoweb/horoscopo_sapo_app/blob/526369a443958835b7bf019836ab7d658c4c1d68/assets/screenshots/screenshot1.png )

---

## Funcionalidades Principais

- **Consulta de Previsões:** Acede às previsões de múltiplos astrólogos disponíveis no portal SAPO.
- **Interface por Abas:** Ecrã principal dividido em "Previsores" e "Signos" para uma navegação intuitiva.
- **Personalização:** Seleção de um "Signo Favorito" que fica em destaque e personaliza a experiência.
- **Previsores Recentes:** A secção "Recentes" mostra os últimos dois astrólogos consultados para o signo favorito, permitindo um acesso rápido.
- **Detalhe de Previsões:** Visualização de todas as previsões disponíveis (Diária, Semanal, Mensal, Anual) para um astrólogo num único ecrã.
- **Navegação por Signos:** Ecrã de detalhe de signos com abas para navegar facilmente entre as previsões de cada signo.
- **Partilha de Conteúdo:** Botão de partilha em cada previsão para enviar facilmente o texto para amigos e redes sociais.
- **Tema Claro e Escuro (Dark Mode):** A aplicação adapta-se automaticamente ao tema do sistema operativo, com uma opção no menu para o utilizador forçar o tema claro ou escuro.
- **Sistema de Cache Inteligente:**
  - **Cache de Dados:** As previsões e a lista de astrólogos são guardadas localmente para reduzir o uso de dados e acelerar o carregamento. O cache é invalidado a cada hora.
  - **Cache de Imagens:** As fotos dos astrólogos são guardadas em cache para uma exibição instantânea.
  - **Pull-to-Refresh:** O utilizador pode forçar a atualização dos dados puxando o ecrã para baixo.

---

## Tecnologias e Pacotes Utilizados

- **Framework:** [Flutter](https://flutter.dev/ )
- **Linguagem:** [Dart](https://dart.dev/ )
- **Gestão de Estado:** `StatefulWidget` e `SharedPreferences` para uma gestão de estado simples e persistente.
- **Comunicação com a API (Web Scraping):**
  - `http`: Para fazer os pedidos HTTP ao portal SAPO.
  - `html`: Para fazer o *parsing* do HTML das páginas e extrair os dados.
- **Interface de Utilizador:**
  - `flutter_html`: Para renderizar o conteúdo das previsões que vem em formato HTML.
  - `cached_network_image`: Para gerir o download e o cache das imagens dos astrólogos.
- **Funcionalidades Nativas:**
  - `share_plus`: Para aceder à funcionalidade de partilha nativa do sistema operativo.
  - `url_launcher`: Para abrir URLs externos no browser (ex: links para o GitHub ).
  - `package_info_plus`: Para obter a versão da aplicação dinamicamente.
- **Persistência Local:**
  - `shared_preferences`: Para guardar o signo favorito, o tema escolhido e os dados em cache.
- **Ícones da Aplicação:**
  - `flutter_launcher_icons`: Para gerar os ícones da aplicação, incluindo os ícones adaptativos para Android.

---

## Como Executar o Projeto

### Pré-requisitos

- Ter o [Flutter SDK](https://docs.flutter.dev/get-started/install ) instalado e configurado no seu ambiente.
- Um emulador Android/iOS ou um dispositivo físico.

### Passos

1.  **Clonar o Repositório:**
    ```bash
    git clone https://github.com/marotoweb/horoscopo_sapo_app.git
    cd horoscopo_sapo_app
    ```

2.  **Instalar as Dependências:**
    Execute o seguinte comando para obter todos os pacotes necessários listados no `pubspec.yaml`:
    ```bash
    flutter pub get
    ```

3.  **Gerar os Ícones da Aplicação (Opcional ):**
    Se fez alguma alteração ao ícone em `assets/icon/`, execute o seguinte comando para regenerar os ícones:
    ```bash
    flutter pub run flutter_launcher_icons
    ```

4.  **Executar a Aplicação:**
    Com um dispositivo ou emulador a correr, execute o comando:
    ```bash
    flutter run
    ```

---

## Estrutura do Projeto

A estrutura de pastas principal do projeto segue as convenções da comunidade Flutter:
```
lib/
|-- main.dart           # Ponto de entrada da aplicação, gestor de temas
|-- models/             # Modelos de dados (Astrologo, Previsao, Signo)
|-- screens/            # Ecrãs principais da aplicação
|   |-- home_screen.dart
|   |-- previsor_detalhe_screen.dart
|   |-- signo_detalhe_screen.dart
|   |-- sobre_screen.dart
|   |-- tabs/
|       |-- previsores_tab_screen.dart
|       |-- signos_tab_screen.dart
|-- services/           # Lógica de negócio e comunicação com a API
|   |-- sapo_api_service.dart
|-- widgets/            # Widgets reutilizáveis
|   |-- previsao_card.dart
|   |-- signo_previsoes_pagina.dart
pubspec.yaml            # Definição do projeto e dependências
```

---


## Licença

Este projeto está licenciado sob a **Licença MIT**. Consulte o ficheiro `LICENSE` para mais detalhes.

Em resumo, a licença permite que qualquer pessoa utilize, modifique e distribua o código para qualquer finalidade, comercial ou não, desde que o aviso de copyright original e o texto da licença sejam incluídos.

---

## Autor

- **Rob Cc. (marotoweb)** - [GitHub](https://github.com/marotoweb )

*Este README foi atualizado para refletir o estado final da V2 do projeto.*

