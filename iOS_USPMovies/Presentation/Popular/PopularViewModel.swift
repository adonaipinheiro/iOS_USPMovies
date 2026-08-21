//
//  PopularViewModel.swift
//  camada: presentation — o hook/ViewModel concentra a lógica; a View é burra.
//

import Foundation

@Observable
@MainActor
final class PopularViewModel {
    private(set) var state: UiState<[Movie]> = .loading

    private var movies: [Movie] = []
    private var page = 1
    private var canLoadMore = true
    private var isLoadingPage = false

    private let getPopularMovies: GetPopularMovies
    private let toggleFavoriteUseCase: ToggleFavorite
    private let observeIsFavoriteUseCase: ObserveIsFavorite

    init(
        getPopularMovies: GetPopularMovies,
        toggleFavorite: ToggleFavorite,
        observeIsFavorite: ObserveIsFavorite
    ) {
        self.getPopularMovies = getPopularMovies
        self.toggleFavoriteUseCase = toggleFavorite
        self.observeIsFavoriteUseCase = observeIsFavorite
    }

    func onAppear() async {
        guard movies.isEmpty else { return }
        await loadFirstPage()
    }

    func reload() async {
        page = 1
        canLoadMore = true
        await loadFirstPage()
    }

    func loadNextPageIfNeeded(current movie: Movie) async {
        guard canLoadMore, !isLoadingPage else { return }
        guard movies.suffix(3).contains(where: { $0.id == movie.id }) else { return }
        await loadNextPage()
    }

    func isFavorite(_ movie: Movie) -> Bool {
        observeIsFavoriteUseCase(id: movie.id)
    }

    func toggleFavorite(_ movie: Movie) async {
        try? await toggleFavoriteUseCase(movie)
    }

    private func loadFirstPage() async {
        isLoadingPage = true
        state = .loading
        do {
            let result = try await getPopularMovies(page: 1)
            movies = result
            state = movies.isEmpty ? .empty : .data(movies)
        } catch {
            state = .error(error.localizedDescription)
        }
        isLoadingPage = false
    }

    private func loadNextPage() async {
        isLoadingPage = true
        do {
            let result = try await getPopularMovies(page: page + 1)
            if result.isEmpty {
                canLoadMore = false
            } else {
                page += 1
                movies.append(contentsOf: result)
                state = .data(movies)
            }
        } catch {
            canLoadMore = false
        }
        isLoadingPage = false
    }
}
