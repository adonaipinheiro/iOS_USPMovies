//
//  StateView.swift
//  camada: presentation — renderiza loading/data/empty/error de forma
//  padronizada em todas as telas de dados.
//

import SwiftUI

struct StateView<Value, Content: View>: View {
    let state: UiState<Value>
    let onRetry: () -> Void
    @ViewBuilder let content: (Value) -> Content

    var body: some View {
        switch state {
        case .loading:
            ProgressView("Carregando...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .data(let value):
            content(value)

        case .empty:
            ContentUnavailableView(
                "Nada por aqui",
                systemImage: "film",
                description: Text("Não há filmes para mostrar no momento.")
            )

        case .error(let message):
            ContentUnavailableView {
                Label("Não foi possível carregar", systemImage: "wifi.slash")
            } description: {
                Text(message)
            } actions: {
                Button("Tentar novamente", action: onRetry)
                    .buttonStyle(.glassProminent)
            }
        }
    }
}
