//
//  TabCoordinator.swift
//  camada: presentation (Presentation/Navigation) — navegação desacoplada da
//  View: a tela chama coordinator.goToDetail(id:) sem conhecer a stack de
//  navegação por baixo. Vive dentro de Presentation porque navegação é
//  responsabilidade de apresentação, não uma camada de arquitetura à parte.
//

import SwiftUI

@Observable
final class TabCoordinator {
    var path = NavigationPath()

    func goToDetail(id: Int) {
        path.append(Route.detail(movieId: id))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
