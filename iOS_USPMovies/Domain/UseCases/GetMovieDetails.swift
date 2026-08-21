//
//  GetMovieDetails.swift
//  camada: domain — não conhece framework
//

struct GetMovieDetails {
    let repository: MoviesRepository

    func callAsFunction(id: Int) async throws -> Movie {
        try await repository.getDetails(id: id)
    }
}
