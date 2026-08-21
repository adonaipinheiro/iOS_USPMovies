//
//  iOS_USPMoviesApp.swift
//  iOS_USPMovies
//
//  Created by Adonai Pinheiro on 21/08/26.
//

import SwiftUI

@main
struct iOS_USPMoviesApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
