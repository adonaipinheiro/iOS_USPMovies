# USPMovies — iOS (Swift/SwiftUI)

Catálogo de filmes (TMDB) construído como material didático do curso **Arquitetura Mobile I-II** (MBA USP Esalq). Mesma arquitetura das versões Android (Kotlin) e React Native — muda só o "sotaque" da linguagem.

## Configurar a API key da TMDB

1. Crie uma conta gratuita em https://developer.themoviedb.org e gere um **API Read Access Token** (token v4, não a `api_key` v3).
2. Copie o arquivo de exemplo:
   ```bash
   cp iOS_USPMovies/Infra/Config/Secrets.example.plist iOS_USPMovies/Infra/Config/Secrets.plist
   ```
3. Abra `Secrets.plist` e preencha `TMDB_ACCESS_TOKEN` com o seu token.
4. `Secrets.plist` já está no `.gitignore` — nunca será commitado.

## Rodar

Abra `iOS_USPMovies.xcodeproj` no Xcode 26+ e rode no simulador (iOS 26+). Sem o passo acima, o app dá `fatalError` na inicialização explicando o que falta — é proposital, para não esquecer a chave.

## Arquitetura — 4 camadas

Regra de dependência: tudo aponta para o **Domain**.

```
Presentation → Domain ← Repositories → Infra
```

- **Domain** (`Domain/`): entidade `Movie`, casos de uso (`GetPopularMovies`, `SearchMovies`, `GetMovieDetails`, `ToggleFavorite`, `GetFavorites`, `ObserveIsFavorite`) e os protocolos `MoviesRepository`/`FavoritesRepository`. Swift puro — não importa `SwiftUI` nem `SwiftData`.
- **Repositories** (`Repositories/`): implementa os protocolos do domínio. Conhece o vocabulário do domínio (fala de `Movie`) e usa o `Infra` por baixo — DTOs da TMDB, mapeamento DTO↔entidade, modelos SwiftData (`FavoriteMovieRecord`, `CachedPopularMovieRecord`) e a lógica de cache/favoritos.
- **Infra** (`Infra/`): puramente técnico, não sabe o que é um "filme" — cliente HTTP genérico (`APIClient`) e leitura de configuração (`AppConfig`).
- **Presentation** (`Presentation/`): Views SwiftUI burras (`PopularView`, `SearchView`, `DetailView`, `FavoritesView`) + ViewModels `@Observable` que concentram a lógica de tela. Navegação desacoplada via `TabCoordinator` (`Navigation/`).
- **DI** (`DI/AppContainer.swift`): único lugar que conhece todas as camadas ao mesmo tempo — monta o grafo de dependências na inicialização do app.

## UI

SwiftUI moderno (iOS 26 / Liquid Glass): `.glassEffect()`, `.buttonStyle(.glass)`, `Tab(role: .search)`, `ContentUnavailableView`, `Observation` (`@Observable`), `async/await`, `SwiftData`.

## Funcionalidades

F1 populares (paginado) · F2 busca com debounce · F3 detalhe · F4 favoritar (offline) · F5 tela de favoritos · F6 cache offline de populares.

## Próximos passos

- Testes unitários dos casos de uso com repositórios mockados (XCTest) — ainda não há um target de testes configurado no projeto.
- `COMPARACAO.md` na raiz do curso, depois que as 3 stacks tiverem uma versão inicial.
