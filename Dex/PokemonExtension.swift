//
//  PokemonExtension.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 07/05/26.
//
import SwiftUI

extension Pokemon {
    
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
        switch types![0] {
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
        Color(types![0].capitalized)
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
}

struct Stat: Identifiable {
    let id: Int
    let name: String
    let value: Int16
}
