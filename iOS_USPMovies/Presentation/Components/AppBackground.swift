//
//  AppBackground.swift
//  camada: presentation — fundo com gradiente para o efeito de vidro (Liquid
//  Glass) ter o que refratar por trás.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.indigo.opacity(0.35),
                Color.black.opacity(0.05),
                Color.teal.opacity(0.25)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
