//
//  ContentView.swift
//  iOS_USPMovies
//
//  Created by Adonai Pinheiro on 21/08/26.
//

import SwiftUI

struct ContentView: View {
    let container: AppContainer

    @State private var popularCoordinator = TabCoordinator()
    @State private var searchCoordinator = TabCoordinator()
    @State private var favoritesCoordinator = TabCoordinator()

    var body: some View {
        TabView {
            Tab("Populares", systemImage: "flame.fill") {
                PopularView(container: container, coordinator: popularCoordinator)
            }

            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                SearchView(container: container, coordinator: searchCoordinator)
            }

            Tab("Favoritos", systemImage: "heart.fill") {
                FavoritesView(container: container, coordinator: favoritesCoordinator)
            }
        }
    }
}

#Preview {
    ContentView(container: AppContainer())
}
