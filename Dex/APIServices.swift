//
//  APIServices.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 20/12/25.
//
import Foundation

enum APIError: Error {
    case badResponse
}

actor APIServices {
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
 
    func fetchPokemon(_ id: Int) async throws -> PokemonDTO {
        // 1. get URl
        let fetchURL = baseURL.appending(path: String(id))
        
        // 2. fetch data and response from URLSession
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // 3. Validate Response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.badResponse
        }
        
        // 4. decode data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let pokemon = try decoder.decode(PokemonDTO.self, from: data)
        
        print("Fetched PokemonDTO: \(pokemon.id): \(pokemon.name)")
        
        // 5. return data
        return pokemon
    }
}
