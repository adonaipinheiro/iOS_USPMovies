//
//  MoviesRepositoryImpl.swift
//  camada: repositories — implementa o protocolo do domínio usando o Infra.
//

import Foundation
import SwiftData

final class MoviesRepositoryImpl: MoviesRepository {
    private let apiClient: APIClient
    private let modelContext: ModelContext

    init(apiClient: APIClient, modelContext: ModelContext) {
        self.apiClient = apiClient
        self.modelContext = modelContext
    }

    func getPopular(page: Int) async throws -> [Movie] {
        do {
            let response: MoviesPageDTO = try await apiClient.get(
                "movie/popular",
                query: [URLQueryItem(name: "page", value: String(page))]
            )
            let movies = response.results.map(MovieMapper.toDomain)
            if page == 1 {
                cachePopular(movies)
            }
            return movies
        } catch {
            // F6: sem rede na primeira página, cai para o cache local.
            if page == 1 {
                let cached = cachedPopular()
                if !cached.isEmpty {
                    return cached
                }
            }
            throw error
        }
    }

    func search(query: String, page: Int) async throws -> [Movie] {
        let response: MoviesPageDTO = try await apiClient.get(
            "search/movie",
            query: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page))
            ]
        )
        return response.results.map(MovieMapper.toDomain)
    }

    func getDetails(id: Int) async throws -> Movie {
        let dto: MovieDTO = try await apiClient.get("movie/\(id)")
        return MovieMapper.toDomain(dto)
    }

    private func cachePopular(_ movies: [Movie]) {
        let existing = (try? modelContext.fetch(FetchDescriptor<CachedPopularMovieRecord>())) ?? []
        existing.forEach { modelContext.delete($0) }
        for (index, movie) in movies.enumerated() {
            modelContext.insert(CachedPopularMovieRecord(movie: movie, position: index))
        }
        try? modelContext.save()
    }

    private func cachedPopular() -> [Movie] {
        var descriptor = FetchDescriptor<CachedPopularMovieRecord>(
            sortBy: [SortDescriptor(\.position, order: .forward)]
        )
        descriptor.fetchLimit = 40
        let records = (try? modelContext.fetch(descriptor)) ?? []
        return records.map { $0.toDomain() }
    }
}
