//
//  FavoritesRepository.swift
//  camada: domain — não conhece framework, rede nem banco.
//
//  toggle recebe o Movie inteiro (e não só o id) para permitir persistir uma
//  cópia local completa do filme — é isso que faz a tela de favoritos
//  funcionar 100% offline, sem depender de uma nova chamada de rede.
//

protocol FavoritesRepository: AnyObject {
    func getAll() async throws -> [Movie]
    func toggle(_ movie: Movie) async throws
    func isFavorite(id: Int) -> Bool
}
