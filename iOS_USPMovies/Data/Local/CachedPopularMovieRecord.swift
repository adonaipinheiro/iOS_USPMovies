//
//  CachedPopularMovieRecord.swift
//  camada: data — esquema de cache local (SwiftData) para F6. Assim como o
//  FavoriteMovieRecord, é só o "molde" da tabela; a lógica de fallback
//  online→cache mora no Repository (MoviesRepositoryImpl).
//

import Foundation
import SwiftData

@Model
final class CachedPopularMovieRecord {
    @Attribute(.unique) var id: Int
    var title: String
    var posterPath: String?
    var overview: String
    var voteAverage: Double
    var releaseYear: String?
    var genres: [String]
    var position: Int

    init(movie: Movie, position: Int) {
        self.id = movie.id
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.overview = movie.overview
        self.voteAverage = movie.voteAverage
        self.releaseYear = movie.releaseYear
        self.genres = movie.genres
        self.position = position
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
