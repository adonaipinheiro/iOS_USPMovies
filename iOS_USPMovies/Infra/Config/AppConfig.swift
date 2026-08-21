//
//  AppConfig.swift
//  camada: infra — leitura de configuração de ambiente, não conhece o domínio.
//

import Foundation

enum AppConfig {
    static var tmdbAccessToken: String {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
            let token = plist["TMDB_ACCESS_TOKEN"] as? String,
            !token.isEmpty,
            token != "SEU_TOKEN_AQUI"
        else {
            fatalError(
                """
                Configuração da TMDB ausente ou incompleta.
                1. Copie Infra/Config/Secrets.example.plist para Infra/Config/Secrets.plist.
                2. Preencha TMDB_ACCESS_TOKEN com seu token (developer.themoviedb.org > API > "API Read Access Token").
                3. Secrets.plist já está no .gitignore — nunca commite sua chave real.
                """
            )
        }
        return token
    }
}
