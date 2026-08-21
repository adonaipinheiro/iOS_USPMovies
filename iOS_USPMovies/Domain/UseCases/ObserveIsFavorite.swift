//
//  ObserveIsFavorite.swift
//  camada: domain — não conhece framework
//

struct ObserveIsFavorite {
    let repository: FavoritesRepository

    func callAsFunction(id: Int) -> Bool {
        repository.isFavorite(id: id)
    }
}
