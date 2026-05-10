//
//  Persistence.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 17/12/25.
//

import SwiftData
import Foundation

@MainActor
struct PersistenceController {
    
    static var previewPokemon: Pokemon {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        var pokemon: Pokemon!
        do {
            let pokemonData =   try Data(contentsOf: Bundle.main.url(forResource: "samplepokemon", withExtension: "json")!)
            pokemon = try decoder.decode(Pokemon.self, from: pokemonData)
        } catch {
            print("Error in decoding previewPokemon: \(error)")
        }
        
        return pokemon
    }

    /// our sample preview SwiftData database
    static let preview: ModelContainer = {
        let container = try! ModelContainer(for: Pokemon.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        container.mainContext.insert(previewPokemon)
        
        return container
    }()
}
