//
//  ContentView.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 17/12/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>
    
    let apiService = APIServices()

    var body: some View {
        NavigationStack {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink(value: pokemon) {
                        PokedexCellView(pokemon: pokemon)
                    }
                }
            }
            .navigationTitle("Pokedex")
            .navigationDestination(for: Pokemon.self) { pokemon in
                Text(pokemon.name ?? "no name")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") {
                        getPokemon()
                    }
                }
            }
        }
    }

    private func getPokemon() {
        Task {
            for id in 1..<152 {
                do {
                    let pokemonDTO = try await apiService.fetchPokemon(id)
                    let pokemon = Pokemon(context: viewContext)
                    pokemon.id = pokemonDTO.id
                    pokemon.name = pokemonDTO.name
                    pokemon.types = pokemonDTO.types
                    pokemon.hp = pokemonDTO.hp
                    pokemon.attack = pokemonDTO.attack
                    pokemon.defence = pokemonDTO.defence
                    pokemon.specialAttack = pokemonDTO.specialAttack
                    pokemon.specialDefence = pokemonDTO.specialDefence
                    pokemon.speed = pokemonDTO.speed
                    pokemon.sprite = pokemonDTO.sprite
                    pokemon.shiny = pokemonDTO.shiny
                    
                    do {
                        try viewContext.save()
                    } catch {
                        print(error)
                    }
                } catch {
                    throw error
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
