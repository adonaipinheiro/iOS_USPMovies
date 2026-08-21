//
//  MovieMapper.swift
//  camada: repositories — mapeia DTO(TMDB) ↔ entidade de domínio.
//

enum MovieMapper {
    static func toDomain(_ dto: MovieDTO) -> Movie {
        Movie(
            id: dto.id,
            title: dto.title,
            posterPath: dto.posterPath,
            overview: dto.overview,
            voteAverage: dto.voteAverage,
            releaseYear: dto.releaseDate.flatMap { $0.count >= 4 ? String($0.prefix(4)) : nil },
            genres: dto.genres?.map(\.name) ?? []
        )
    }
}
