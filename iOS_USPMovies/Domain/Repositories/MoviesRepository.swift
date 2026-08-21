//
//  MoviesRepository.swift
//  camada: domain — não conhece framework, rede nem banco.
//

protocol MoviesRepository {
    func getPopular(page: Int) async throws -> [Movie]
    func search(query: String, page: Int) async throws -> [Movie]
    func getDetails(id: Int) async throws -> Movie
}
