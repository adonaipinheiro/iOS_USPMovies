//
//  SearchView.swift
//  camada: presentation — View burra: consome estado pronto do ViewModel.
//

import SwiftUI

struct SearchView: View {
    let container: AppContainer
    @Bindable var coordinator: TabCoordinator
    @State private var viewModel: SearchViewModel

    init(container: AppContainer, coordinator: TabCoordinator) {
        self.container = container
        self.coordinator = coordinator
        _viewModel = State(initialValue: SearchViewModel(
            searchMovies: container.searchMovies,
            toggleFavorite: container.toggleFavorite,
            observeIsFavorite: container.observeIsFavorite
        ))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ContentUnavailableView(
                        "Buscar filmes",
                        systemImage: "magnifyingglass",
                        description: Text("Digite um título para começar.")
                    )
                } else {
                    StateView(state: viewModel.state, onRetry: { viewModel.onQueryChange(viewModel.query) }) { movies in
                        List(movies) { movie in
                            MovieCardView(
                                movie: movie,
                                isFavorite: viewModel.isFavorite(movie),
                                onToggleFavorite: { Task { await viewModel.toggleFavorite(movie) } }
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture { coordinator.goToDetail(id: movie.id) }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .background(AppBackground())
            .navigationTitle("Buscar")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detail(let movieId):
                    DetailView(container: container, movieId: movieId)
                }
            }
        }
        .searchable(text: $viewModel.query, prompt: "Título do filme")
        .onChange(of: viewModel.query) { _, newValue in
            viewModel.onQueryChange(newValue)
        }
    }
}

#Preview {
    SearchView(container: AppContainer(), coordinator: TabCoordinator())
}
