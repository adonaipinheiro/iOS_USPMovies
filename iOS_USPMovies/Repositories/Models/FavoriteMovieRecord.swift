//
//  FavoriteMovieRecord.swift
//  camada: repositories — esquema de persistência (SwiftData) para F4/F5.
//

import Foundation
import SwiftData

@Model
final class FavoriteMovieRecord {
    @Attribute(.unique) var id: Int
    var title: String
    var posterPath: String?
    var overview: String
    var voteAverage: Double
    var releaseYear: String?
    var genres: [String]
    var addedAt: Date

    init(movie: Movie, addedAt: Date = .now) {
        self.id = movie.id
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.overview = movie.overview
        self.voteAverage = movie.voteAverage
        self.releaseYear = movie.releaseYear
        self.genres = movie.genres
        self.addedAt = addedAt
    }

    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            posterPath: posterPath,
            overview: overview,
            voteAverage: voteAverage,
            releaseYear: releaseYear,
            genres: genres
        )
    }
}
