//
//  GetFavorites.swift
//  camada: domain — não conhece framework
//

struct GetFavorites {
    let repository: FavoritesRepository

    func callAsFunction() async throws -> [Movie] {
        try await repository.getAll()
    }
}
