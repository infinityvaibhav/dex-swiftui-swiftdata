//
//  Pokemon.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 09/05/26.
//
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Pokemon: Decodable {
    @Attribute(.unique) var id: Int
    var name: String
    var types: [String]
    var hp: Int
    var attack: Int
    var defense: Int
    var specialAttack: Int
    var specialDefence: Int
    var speed: Int
    var shinyURL: URL?
    var spriteURL: URL?
    var shiny: Data?
    var sprite: Data?
    var favorite: Bool = false
    
    // MARK: - Helper Structures
    private struct TypeWrapper: Decodable {
        let type: NamedValue
    }
    
    private struct NamedValue: Decodable {
        let name: String
    }
    
    private struct StatWrapper: Decodable {
        let stat: NamedValue
        let baseStat: Int
    }
    
    private struct SpritesData: Decodable {
        let spriteURL: URL?
        let shinyURL: URL?
        
        enum CodingKeys: String, CodingKey {
            case spriteURL = "frontDefault"
            case shinyURL = "frontShiny"
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
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode simple properties
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        // Decode types with map
        types = try container.decodeIfPresent([TypeWrapper].self, forKey: .types)?
            .map { $0.type.name } ?? []
        
        // Decode stats by name mapping
        let statsArray = try container.decodeIfPresent([StatWrapper].self, forKey: .stats) ?? []
        let statsMap = Dictionary(uniqueKeysWithValues: statsArray.map { ($0.stat.name, $0.baseStat) })
        
        hp = statsMap["hp"] ?? 0
        attack = statsMap["attack"] ?? 0
        defense = statsMap["defense"] ?? 0
        specialAttack = statsMap["special-attack"] ?? 0
        specialDefence = statsMap["special-defense"] ?? 0
        speed = statsMap["speed"] ?? 0
        
        if types.count == 2 && types[0] == "normal" {
            types.swapAt(0, 1)
        }
        
        // Decode sprites with fallback
        let spritesData = try container.decodeIfPresent(SpritesData.self, forKey: .sprites)
        spriteURL = spritesData?.spriteURL
        shinyURL = spritesData?.shinyURL
    }
    
    var spriteImage: Image {
        if let data = sprite, let image = UIImage(data: data) {
            return Image(uiImage: image)
        }
        return Image(.nopokemon)
    }
    
    var shinyImage: Image {
        if let data = shiny, let image = UIImage(data: data) {
            return Image(uiImage: image)
        }
        return Image(.nopokemon)
    }
    
    var background: ImageResource {
        switch types[0] {
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
                .rockgroundsteelfightingghostdarkpsychic
        case "fire", "dragon":
                .firedragon
        case "flying", "bug":
                .flyingbug
        case "ice":
                .ice
        case "water":
                .water
        default:
                .normalgrasselectricpoisonfairy
        }
    }
    
    var typesColor: Color {
        Color(types[0].capitalized)
    }
    
    var stats: [Stat] {
        [
            Stat(id: 1, name: "HP", value: hp),
            Stat(id: 2, name: "Attack", value: attack),
            Stat(id: 3, name: "Defense", value: defense),
            Stat(id: 4, name: "Special Attack", value: specialAttack),
            Stat(id: 5, name: "Special Defence", value: specialDefence),
            Stat(id: 6, name: "Speed", value: speed)
        ]
    }
    
    var highestStat: Stat {
        stats.max { $0.value < $1.value }!
    }
    
    struct Stat: Identifiable {
        let id: Int
        let name: String
        let value: Int
    }
}
