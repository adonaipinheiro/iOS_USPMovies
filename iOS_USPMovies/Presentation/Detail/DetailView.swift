//
//  DetailView.swift
//  camada: presentation — View burra: consome estado pronto do ViewModel.
//

import SwiftUI

struct DetailView: View {
    @State private var viewModel: DetailViewModel

    init(container: AppContainer, movieId: Int) {
        _viewModel = State(initialValue: DetailViewModel(
            movieId: movieId,
            getMovieDetails: container.getMovieDetails,
            toggleFavorite: container.toggleFavorite,
            observeIsFavorite: container.observeIsFavorite
        ))
    }

    var body: some View {
        ScrollView {
            StateView(state: viewModel.state, onRetry: { Task { await viewModel.onAppear() } }) { movie in
                DetailContent(movie: movie)
            }
        }
        .background(AppBackground())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavButton(
                    isFavorite: viewModel.isFavorite,
                    onToggle: { Task { await viewModel.toggleFavorite() } }
                )
            }
        }
        .task { await viewModel.onAppear() }
    }
}

private struct DetailContent: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: movie.posterURL) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    Rectangle().fill(.quaternary)
                }
            }
            .frame(height: 420)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.title2.bold())
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                        Text(String(format: "%.1f", movie.voteAverage))
                        if let year = movie.releaseYear {
                            Text("· \(year)").foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)
                }
                .padding(16)
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                .padding(16)
            }

            if !movie.genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(movie.genres, id: \.self) { genre in
                            Text(genre)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .glassEffect(.regular.tint(.accentColor), in: .capsule)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Text(movie.overview)
                .font(.body)
                .padding(.horizontal)
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    NavigationStack {
        DetailView(container: AppContainer(), movieId: 1)
    }
}
