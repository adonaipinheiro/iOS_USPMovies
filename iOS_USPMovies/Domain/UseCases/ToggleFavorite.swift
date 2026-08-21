//
//  ToggleFavorite.swift
//  camada: domain — não conhece framework
//

struct ToggleFavorite {
    let repository: FavoritesRepository

    func callAsFunction(_ movie: Movie) async throws {
        try await repository.toggle(movie)
    }
}
