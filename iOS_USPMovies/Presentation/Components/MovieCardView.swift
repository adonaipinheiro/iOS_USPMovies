//
//  MovieCardView.swift
//  camada: presentation — View burra, só renderiza o que recebe.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: movie.posterURL) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    Rectangle().fill(.quaternary)
                }
            }
            .frame(width: 72, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", movie.voteAverage))
                    if let year = movie.releaseYear {
                        Text("· \(year)")
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.subheadline)

                Text(movie.overview)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            FavButton(isFavorite: isFavorite, onToggle: onToggleFavorite)
        }
        .padding(12)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    MovieCardView(
        movie: Movie(
            id: 1,
            title: "Um Filme Qualquer",
            posterPath: nil,
            overview: "Uma sinopse de exemplo para o card do filme.",
            voteAverage: 8.4,
            releaseYear: "2026",
            genres: []
        ),
        isFavorite: true,
        onToggleFavorite: {}
    )
    .padding()
    .background(AppBackground())
}
