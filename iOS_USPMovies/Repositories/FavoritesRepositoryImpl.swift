//
//  FavoritesRepositoryImpl.swift
//  camada: repositories — implementa o protocolo do domínio usando o Infra.
//

import Foundation
import SwiftData

@Observable
final class FavoritesRepositoryImpl: FavoritesRepository {
    private let modelContext: ModelContext
    private(set) var favoriteIds: Set<Int> = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        refreshIds()
    }

    func getAll() async throws -> [Movie] {
        let descriptor = FetchDescriptor<FavoriteMovieRecord>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )
        let records = try modelContext.fetch(descriptor)
        return records.map { $0.toDomain() }
    }

    func toggle(_ movie: Movie) async throws {
        if let record = try findRecord(id: movie.id) {
            modelContext.delete(record)
        } else {
            modelContext.insert(FavoriteMovieRecord(movie: movie))
        }
        try modelContext.save()
        refreshIds()
    }

    func isFavorite(id: Int) -> Bool {
        favoriteIds.contains(id)
    }

    private func findRecord(id: Int) throws -> FavoriteMovieRecord? {
        var descriptor = FetchDescriptor<FavoriteMovieRecord>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func refreshIds() {
        let records = (try? modelContext.fetch(FetchDescriptor<FavoriteMovieRecord>())) ?? []
        favoriteIds = Set(records.map(\.id))
    }
}
