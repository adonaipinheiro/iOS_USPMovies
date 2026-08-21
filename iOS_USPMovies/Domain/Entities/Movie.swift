//
//  Movie.swift
//  camada: domain — não conhece framework, rede nem banco.
//

import Foundation

struct Movie: Identifiable, Equatable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let releaseYear: String?
    let genres: [String]

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}
