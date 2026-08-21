//
//  SearchViewModel.swift
//  camada: presentation
//

import Foundation

@Observable
@MainActor
final class SearchViewModel {
    var query: String = ""
    private(set) var state: UiState<[Movie]> = .empty

    private var searchTask: Task<Void, Never>?

    private let searchMovies: SearchMovies
    private let toggleFavoriteUseCase: ToggleFavorite
    private let observeIsFavoriteUseCase: ObserveIsFavorite

    init(
        searchMovies: SearchMovies,
        toggleFavorite: ToggleFavorite,
        observeIsFavorite: ObserveIsFavorite
    ) {
        self.searchMovies = searchMovies
        self.toggleFavoriteUseCase = toggleFavorite
        self.observeIsFavoriteUseCase = observeIsFavorite
    }

    func onQueryChange(_ newValue: String) {
        searchTask?.cancel()

        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state = .empty
            return
        }

        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            await performSearch(trimmed)
        }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        observeIsFavoriteUseCase(id: movie.id)
    }

    func toggleFavorite(_ movie: Movie) async {
        try? await toggleFavoriteUseCase(movie)
    }

    private func performSearch(_ query: String) async {
        state = .loading
        do {
            let movies = try await searchMovies(query: query, page: 1)
            guard !Task.isCancelled else { return }
            state = movies.isEmpty ? .empty : .data(movies)
        } catch {
            guard !Task.isCancelled else { return }
            state = .error(error.localizedDescription)
        }
    }
}
