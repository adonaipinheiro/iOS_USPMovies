//
//  FavoritesViewModel.swift
//  camada: presentation
//

import Foundation

@Observable
@MainActor
final class FavoritesViewModel {
    private(set) var state: UiState<[Movie]> = .loading

    private let getFavorites: GetFavorites
    private let toggleFavoriteUseCase: ToggleFavorite
    private let observeIsFavoriteUseCase: ObserveIsFavorite

    init(
        getFavorites: GetFavorites,
        toggleFavorite: ToggleFavorite,
        observeIsFavorite: ObserveIsFavorite
    ) {
        self.getFavorites = getFavorites
        self.toggleFavoriteUseCase = toggleFavorite
        self.observeIsFavoriteUseCase = observeIsFavorite
    }

    func onAppear() async {
        await reload()
    }

    func reload() async {
        state = .loading
        do {
            let movies = try await getFavorites()
            state = movies.isEmpty ? .empty : .data(movies)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        observeIsFavoriteUseCase(id: movie.id)
    }

    func toggleFavorite(_ movie: Movie) async {
        try? await toggleFavoriteUseCase(movie)
        await reload()
    }
}
