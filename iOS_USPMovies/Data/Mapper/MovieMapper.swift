//
//  MovieMapper.swift
//  camada: data — traduz o DTO (formato da TMDB) para a entidade de domínio
//  `Movie`. É a "fronteira de tradução": tudo que sai daqui já fala a língua
//  do domínio, e quem chama (Repository) não precisa saber do formato remoto.
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
