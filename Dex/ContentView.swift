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

    @FetchRequest<Pokemon>(
        sortDescriptors: [SortDescriptor(\.id)],
        animation: .default)
    private var pokedex
    
    @State private var searchText: String = ""
    
    let apiService = APIServices()
    
    private var dynamicPredicate: NSPredicate {
        var predicates : [NSPredicate] = []
        
        // Search predicate
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name contains[c] %@", searchText))
        }
        
        // Filter predicate
        
        // Combine predicate
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

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
            .searchable(text: $searchText, prompt: "Find a pokemon")
            .autocorrectionDisabled()
            .onChange(of: searchText) {
                pokedex.nsPredicate = dynamicPredicate
            }
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
