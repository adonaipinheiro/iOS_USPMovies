//
//  Route.swift
//  camada: presentation (Presentation/Navigation) — rota tipada. Navegação é
//  detalhe de apresentação, por isso mora dentro de Presentation e não numa
//  camada própria.
//

enum Route: Hashable {
    case detail(movieId: Int)
}
