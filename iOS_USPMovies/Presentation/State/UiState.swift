//
//  UiState.swift
//  camada: presentation — estados de UI explícitos (loading/data/empty/error).
//

enum UiState<Value> {
    case loading
    case data(Value)
    case empty
    case error(String)
}
