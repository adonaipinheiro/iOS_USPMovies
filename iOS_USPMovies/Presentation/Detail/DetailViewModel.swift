//
//  DetailViewModel.swift
//  camada: presentation
//

import Foundation

@Observable
@MainActor
final class DetailViewModel {
    let movieId: Int
    private(set) var state: UiState<Movie> = .loading

    private let getMovieDetails: GetMovieDetails
    private let toggleFavoriteUseCase: ToggleFavorite
    private let observeIsFavoriteUseCase: ObserveIsFavorite

    init(
        movieId: Int,
        getMovieDetails: GetMovieDetails,
        toggleFavorite: ToggleFavorite,
        observeIsFavorite: ObserveIsFavorite
    ) {
        self.movieId = movieId
        self.getMovieDetails = getMovieDetails
        self.toggleFavoriteUseCase = toggleFavorite
        self.observeIsFavoriteUseCase = observeIsFavorite
    }

    var isFavorite: Bool {
        observeIsFavoriteUseCase(id: movieId)
    }

    func onAppear() async {
        state = .loading
        do {
            let movie = try await getMovieDetails(id: movieId)
            state = .data(movie)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func toggleFavorite() async {
        guard case .data(let movie) = state else { return }
        try? await toggleFavoriteUseCase(movie)
    }
}
