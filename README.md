
![Logo](https://github.com/l-andrad/noar/blob/main/assets/images/ic_launcher.png)
# Noar

O aplicativo Noar foi desenvolvido em parceria com a Rede Catarina e a faculdade UniSenai.

A aplicação visa identificar traços abusivos dentro de um relacionamento e trazer informações sobre os cuidados e quais contatos o usuário pode recorrer. Essa detecção é feita através de questionários, onde é feito uma análise a partir das respostas para verificar se a pessoa está sofrendo abuso dentro de um relacionamento, ou se ela está sendo uma pessoa abusiva.
## 🚀 Sobre a equipe
A equipe desenvolvedora é composta por 3 pessoas:

[Lucas Bittencourt Andrade](https://www.linkedin.com/in/lucasb-andrade/) | Desenvolvedor

[Gabriel Gonçalves](https://www.linkedin.com/in/gabriel-goncalves-1611b4174/) | Desenvolvedor

[Joana Yuriko Franz](https://www.linkedin.com/in/joanafranz/) | Prototipagem de tela

O início do projeto foi em agosto/2023 com o aprendizado das tecnologias, se encerrando em dezembro/2023 com a entrega da primeira versão.

Este projeto foi usado como TCC para o Tecnólogo em Análise e Desenvolvimento de Sistemas de Gabriel e Lucas que se formaram no ano de 2023.


## Stack utilizada

**Front-end:** Flutter

**Back-end:** Dart, Firebase


## Documentação

[Dart](https://dart.dev/language)

[Flutter](https://docs.flutter.dev/get-started/install)

[Firebase](https://firebase.google.com/docs)

[FlutterFire](https://firebase.flutter.dev/docs/overview/)
## Ferramentas necessárias

Editor de código - VSCode, XCode, Android Studio, IntelliJ

Extensões e SDK's - Dart e Flutter

Simuladores para ambos os sistemas

#### Para MacOS

Instalar o CocoaPods
## Rodando localmente

Após ter todas as ferramentas necessárias instaladas, siga os passos de instalação:

Clone o projeto

```bash
  git clone https://github.com/l-andrad/noar.git
```

Entre no diretório do projeto

```bash
  cd noar
```

Instale as dependências

```bash
  flutter pub get
```

Após instalar todas as dependências, configure o FluterFire CLI e depois rode o seguinte comando:

```bash
  flutterfire configure
```

Selecione o banco de dados criado no firebase, desmarque as opções web, macos, windows e linux e deixe apenas ios e android.

Rode o projeto

```bash
  flutter run
```

### Ambiente Mac

Para desenvolvimento em MacOS é necessário executar alguns passos:

Entre no diretório ios

```bash
  cd ios
```

Atualize e instale as dependências do CocoaPods

```bash
  pod update
```

Após esses comandos, rode uma build do projeto via Xcode.

Feito isso inicie o simulador de acordo com seu sistema, e rode o projeto no VScode usando este comando:

```bash
  flutter run
```




## Configurações Firebase

Para este projeto utilizamos dois serviços do Firebase:

- Authentication;
- Firestore Database;

Para configurar esses dois serviços você pode seguir as documentações conforme a plataforma.

### Authentication

Nos métodos de autenticação utilizamos apenas o Email/Senha.

### Firestore Database

Após configurar o Firestore com o projeto é necessário criar 3 documentos/coleções para armazenar alguns dados:

- agressor > perguntas > todas as perguntas

Nesta coleção é armazenada as perguntas do formulário para detectar se você é uma pessoa abusiva (segundo botão da tela de formulários). Todas as perguntas precisam estar com o número na chave e o valor conter a pergunta em si, pois a aplicação vai puxar na ordem sempre.

- dadosPessoais

Esta coleção tem o dever de armazenar todos os dados de cadastro dos usuários.

- vitima > perguntas > todas as perguntas

Esta última coleção tem a finalidade de armazenar todas as perguntas do formulário de vítima, onde é detectado se você está num relacionamento abusivo. A organização das perguntas segue a mesma lógica da coleção de "agressor".

#### Abaixo segue exemplo de banco de dados

![database](https://github.com/l-andrad/noar/blob/main/assets/images/modelo-database.png)
## Screenshots

Na pasta [assets/screenshots](https://github.com/l-andrad/noar/tree/main/assets/screenshots) você pode encontrar imagens de algumas telas do aplicativo deste projeto.