//
//  GetPopularMovies.swift
//  camada: domain — não conhece framework
//

struct GetPopularMovies {
    let repository: MoviesRepository

    func callAsFunction(page: Int) async throws -> [Movie] {
        try await repository.getPopular(page: page)
    }
}
