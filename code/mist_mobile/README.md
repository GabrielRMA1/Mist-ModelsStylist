# Mist Mobile

Aplicativo Flutter do projeto Mist - Models Stylist.

Este projeto contem os fluxos do cliente e do prestador/estilista em uma unica aplicacao. A navegacao e direcionada conforme o perfil autenticado (`CLIENTE` ou `ESTILISTA`), reutilizando tema, componentes, modelos e servicos HTTP.

## Estrutura principal

- `lib/screens/client`: telas do cliente.
- `lib/screens/stylist`: telas do estilista/prestador.
- `lib/screens/shared`: telas compartilhadas.
- `lib/services`: integracao com a API e persistencia de sessao.
- `lib/models`: modelos usados pela interface.
- `lib/widgets`: componentes visuais reutilizaveis.
- `lib/theme`: tema visual da aplicacao.

## Execucao

Instale as dependencias:

```bash
flutter pub get
```

Execute:

```bash
flutter run
```

Por padrao, a API e acessada em `http://10.0.2.2:3333`, configurado em `lib/services/api_client.dart`. Esse endereco e indicado para emulador Android. Em dispositivo fisico, use o IP da maquina onde o backend esta rodando.
