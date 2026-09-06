//
//  MovieDTO.swift
//  camada: data — formato bruto vindo da fonte remota (TMDB). O domínio nunca
//  vê JSON: quem traduz DTO → entidade é o Data/Mapper, e quem decide o que
//  fazer com o resultado (cache, fallback) é o Repository, não esta camada.
//

import Foundation

struct MoviesPageDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let releaseDate: String?
    let genres: [GenreDTO]?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}
