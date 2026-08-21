//
//  AppContainer.swift
//  camada: DI — o único lugar autorizado a conhecer domain, repositories e
//  infra ao mesmo tempo. É aqui que a arquitetura é "montada".
//

import Foundation
import SwiftData

@MainActor
final class AppContainer {
    let getPopularMovies: GetPopularMovies
    let searchMovies: SearchMovies
    let getMovieDetails: GetMovieDetails
    let toggleFavorite: ToggleFavorite
    let getFavorites: GetFavorites
    let observeIsFavorite: ObserveIsFavorite

    private let modelContainer: ModelContainer
    private let moviesRepository: MoviesRepository
    private let favoritesRepository: FavoritesRepository

    init() {
        let schema = Schema([FavoriteMovieRecord.self, CachedPopularMovieRecord.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        modelContainer = try! ModelContainer(for: schema, configurations: [configuration])
        let modelContext = ModelContext(modelContainer)

        let apiClient = APIClient(
            baseURL: URL(string: "https://api.themoviedb.org/3")!,
            accessToken: AppConfig.tmdbAccessToken
        )

        moviesRepository = MoviesRepositoryImpl(apiClient: apiClient, modelContext: modelContext)
        favoritesRepository = FavoritesRepositoryImpl(modelContext: modelContext)

        getPopularMovies = GetPopularMovies(repository: moviesRepository)
        searchMovies = SearchMovies(repository: moviesRepository)
        getMovieDetails = GetMovieDetails(repository: moviesRepository)
        toggleFavorite = ToggleFavorite(repository: favoritesRepository)
        getFavorites = GetFavorites(repository: favoritesRepository)
        observeIsFavorite = ObserveIsFavorite(repository: favoritesRepository)
    }
}
