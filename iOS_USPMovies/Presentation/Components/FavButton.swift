//
//  FavButton.swift
//  camada: presentation
//

import SwiftUI

struct FavButton: View {
    let isFavorite: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(isFavorite ? .red : .primary)
                .font(.title3)
                .frame(width: 36, height: 36)
                .symbolEffect(.bounce, value: isFavorite)
        }
        .buttonStyle(.glass)
        .sensoryFeedback(.selection, trigger: isFavorite)
    }
}

#Preview {
    FavButton(isFavorite: false, onToggle: {})
        .padding()
        .background(AppBackground())
}
