//
//  PokemonDTO.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 18/12/25.
//

import Foundation

struct PokemonDTO: Decodable {
    let id: Int16
    let name: String
    var types: [String]
    let hp: Int16
    let attack: Int16
    let defense: Int16
    let specialAttack: Int16
    let specialDefence: Int16
    let speed: Int16
    let sprite: URL?
    let shiny: URL?
    
    // MARK: - Helper Structures
    private struct TypeWrapper: Decodable {
        let type: NamedValue
    }
    
    private struct NamedValue: Decodable {
        let name: String
    }
    
    private struct StatWrapper: Decodable {
        let stat: NamedValue
        let baseStat: Int16
    }
    
    private struct SpritesData: Decodable {
        let frontDefault: URL?
        let frontShiny: URL?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
            case frontShiny = "front_shiny"
        }
    }
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode simple properties
        id = try container.decode(Int16.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        // Decode types with map
        types = try container.decodeIfPresent([TypeWrapper].self, forKey: .types)?
            .map { $0.type.name } ?? []
        
        if types.count == 2 && types[0] == "normal" {
            types.swapAt(0, 1)
        }
        
        // Decode stats by name mapping
        let statsArray = try container.decodeIfPresent([StatWrapper].self, forKey: .stats) ?? []
        let statsMap = Dictionary(uniqueKeysWithValues: statsArray.map { ($0.stat.name, $0.baseStat) })
        
        hp = statsMap["hp"] ?? 0
        attack = statsMap["attack"] ?? 0
        defense = statsMap["defense"] ?? 0
        specialAttack = statsMap["special-attack"] ?? 0
        specialDefence = statsMap["special-defense"] ?? 0
        speed = statsMap["speed"] ?? 0
        
        // Decode sprites with fallback
        let spritesData = try container.decodeIfPresent(SpritesData.self, forKey: .sprites)
        sprite = spritesData?.frontDefault
        shiny = spritesData?.frontShiny
    }
}
