//
//  PopularView.swift
//  camada: presentation — View burra: consome estado pronto do ViewModel.
//

import SwiftUI

struct PopularView: View {
    let container: AppContainer
    @Bindable var coordinator: TabCoordinator
    @State private var viewModel: PopularViewModel

    init(container: AppContainer, coordinator: TabCoordinator) {
        self.container = container
        self.coordinator = coordinator
        _viewModel = State(initialValue: PopularViewModel(
            getPopularMovies: container.getPopularMovies,
            toggleFavorite: container.toggleFavorite,
            observeIsFavorite: container.observeIsFavorite
        ))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            StateView(state: viewModel.state, onRetry: { Task { await viewModel.reload() } }) { movies in
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
                    .task { await viewModel.loadNextPageIfNeeded(current: movie) }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .refreshable { await viewModel.reload() }
            }
            .background(AppBackground())
            .navigationTitle("Populares")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detail(let movieId):
                    DetailView(container: container, movieId: movieId)
                }
            }
        }
        .task { await viewModel.onAppear() }
    }
}

#Preview {
    PopularView(container: AppContainer(), coordinator: TabCoordinator())
}
