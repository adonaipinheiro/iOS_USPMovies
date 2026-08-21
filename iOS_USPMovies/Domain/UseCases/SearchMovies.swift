//
//  SearchMovies.swift
//  camada: domain — não conhece framework
//

struct SearchMovies {
    let repository: MoviesRepository

    func callAsFunction(query: String, page: Int) async throws -> [Movie] {
        try await repository.search(query: query, page: page)
    }
}
