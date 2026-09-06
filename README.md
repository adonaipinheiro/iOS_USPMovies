# USPMovies — iOS 🎬

![Platform](https://img.shields.io/badge/platform-iOS-000000)
![Swift](https://img.shields.io/badge/Swift-5-fa7343)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Liquid_Glass-1e90ff)
![Deployment](https://img.shields.io/badge/iOS-26.5+-000000)
![Xcode](https://img.shields.io/badge/Xcode-26+-1575f9)
![Architecture](https://img.shields.io/badge/arquitetura-Clean_+_MVVM_(6_camadas)-8a2be2)

Catálogo de filmes consumindo a API do **TMDB**, em Swift/SwiftUI. É a stack iOS
do app de referência do curso **Arquitetura Mobile I‑II** (MBA em Engenharia de
Software — USP/Esalq). O mesmo escopo funcional e a **mesma arquitetura** são
implementados em paralelo em três stacks — muda só o "sotaque" da linguagem.

> Projeto didático. O foco é a organização em camadas — não uma publicação real
> na loja.

## Projetos irmãos

| Stack | Repositório | Status |
|---|---|---|
| React Native | [`adonaipinheiro/RN_USPMovies`](https://github.com/adonaipinheiro/RN_USPMovies) | testes 100% · CI/CD (Android) |
| Android nativo | [`adonaipinheiro/Android_USPMovies`](https://github.com/adonaipinheiro/Android_USPMovies) | versão inicial funcional |
| **iOS nativo** | `adonaipinheiro/iOS_USPMovies` | versão inicial funcional |

## Funcionalidades

| # | Feature | Detalhe |
|---|---|---|
| F1 | Lista de populares | paginação |
| F2 | Busca | com debounce |
| F3 | Detalhe do filme | — |
| F4 | Favoritar / desfavoritar | persistido em SwiftData, funciona offline |
| F5 | Tela de favoritos | lê o snapshot local |
| F6 | Cache offline dos populares | dentro do repositório |

Toda tela de dados trata os estados **loading / data / empty / error**
(`ContentUnavailableView`).

## Configurar a API key da TMDB

1. Crie uma conta em https://developer.themoviedb.org e gere um **API Read Access
   Token** (token v4, não a `api_key` v3).
2. Copie o arquivo de exemplo:
   ```bash
   cp iOS_USPMovies/Infra/Config/Secrets.example.plist iOS_USPMovies/Infra/Config/Secrets.plist
   ```
3. Preencha `TMDB_ACCESS_TOKEN` em `Secrets.plist`. O arquivo está no `.gitignore`.

Sem esse passo, o app dá `fatalError` na inicialização explicando o que falta —
proposital, para não esquecer a chave.

## Rodar

Abra `iOS_USPMovies.xcodeproj` no **Xcode 26+** e rode no simulador (**iOS 26.5+**).
O projeto usa *file-system-synchronized groups* — arquivos novos na pasta são
pegos automaticamente, sem editar o `.pbxproj`.

## Arquitetura — 6 camadas

Regra de dependência: tudo aponta para o **Domain**. `DI` é o único ponto que
tem permissão de conhecer todas as outras camadas ao mesmo tempo — é ele quem
"liga os fios" na inicialização do app.

```
Presentation ──► Domain ◄── Repository ──► Data ──► Infra
                               ▲
                               │
                              DI  (conhece Domain + Repository + Data + Infra)
```

| Camada | Papel | Conteúdo |
|---|---|---|
| `Domain/` | regras e contratos, Swift puro (sem `SwiftUI` / `SwiftData`) | entidade `Movie`; protocolos `MoviesRepository` / `FavoritesRepository`; casos de uso `GetPopularMovies`, `SearchMovies`, `GetMovieDetails`, `ToggleFavorite`, `GetFavorites`, `ObserveIsFavorite` |
| `Data/` | fontes de dados: formato bruto + tradução para o domínio; já "conhece" `Movie`, mas não decide política de negócio | DTOs da TMDB (`Data/Remote/DTO`), mapeamento DTO↔entidade (`Data/Mapper`), modelos SwiftData (`Data/Local`: `FavoriteMovieRecord`, `CachedPopularMovieRecord`) |
| `Repository/` | implementa os protocolos do `Domain`, orquestrando as fontes de `Data` por cima do `Infra` | `MoviesRepositoryImpl` (fallback online→cache, F6), `FavoritesRepositoryImpl` (favoritos observáveis, F4/F5) |
| `Infra/` | encanamento técnico 100% genérico, não sabe o que é um "filme" | `APIClient` (HTTP genérico), `AppConfig` (leitura de configuração) |
| `DI/` | composição do grafo de dependências; único lugar que conhece Domain + Repository + Data + Infra ao mesmo tempo | `AppContainer` |
| `Presentation/` | Views SwiftUI "burras" + ViewModels `@Observable` + navegação | `PopularView`, `SearchView`, `DetailView`, `FavoritesView`; navegação desacoplada via `TabCoordinator`/`Route` (`Presentation/Navigation/`) |

> Antes desta refatoração o projeto usava 4 camadas (`Domain`, `Repositories`,
> `Infra`, `Presentation`, com `Navigation/` na raiz). `Repositories/` foi
> dividida em `Data/` (fontes de dados e mapeamento) e `Repository/`
> (orquestração/política), e `Navigation/` passou para dentro de
> `Presentation/Navigation/`, já que navegação é responsabilidade de
> apresentação.

## UI

SwiftUI moderno com **Liquid Glass (iOS 26)**: `.glassEffect()`,
`.buttonStyle(.glass)` / `.glassProminent`, `Tab(role: .search)` (aba de busca que
faz *morph* num campo flutuante), `ContentUnavailableView`, `Observation`
(`@Observable`), `SwiftData`, `async/await`.

## Próximos passos

- Adicionar um target de testes (XCTest) para os casos de uso com repositórios
  mockados — exige criar um novo `PBXNativeTarget` no projeto. A stack RN já tem
  cobertura 100%, serve de referência.
- `COMPARACAO.md` na raiz do curso, comparando as 3 stacks lado a lado.
