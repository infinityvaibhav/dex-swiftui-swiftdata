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
    @State private var filterByFavorite = false
    
    let apiService = APIServices()
    
    private var dynamicPredicate: NSPredicate {
        var predicates : [NSPredicate] = []
        
        // Search predicate
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name contains[c] %@", searchText))
        }
        
        // Filter predicate
        if filterByFavorite {
            predicates.append(NSPredicate(format: "favorite == %d", true))
        }
        
        // Combine predicate
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    var body: some View {
        if pokedex.isEmpty {
            ContentUnavailableView {
                Label("No Pokemon", image: .nopokemon)
            } description: {
                Text("There aren't any pokemon yet\n Fetch some pokemon to get started!")
            } actions: {
                Button("fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                    getPokemon(from: 1)
                }
                .buttonStyle(.borderedProminent)
            }
            
        } else {
            NavigationStack {
                List {
                    Section {
                        ForEach(pokedex) { pokemon in
                            NavigationLink(value: pokemon) {
                                PokedexCellView(pokemon: pokemon)
                            }
                        }
                    } footer: {
                        if pokedex.count < 151 {
                            ContentUnavailableView {
                                Label("Missing pokemon", image: .nopokemon)
                            } description: {
                                 Text("The fetch was interrupted\n Fetch the rest of the pokemons")
                            } actions: {
                                Button("fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                                    getPokemon(from: pokedex.count + 1)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }
                .navigationTitle("Pokedex")
                .searchable(text: $searchText, prompt: "Find a pokemon")
                .autocorrectionDisabled()
                .onChange(of: searchText) {
                    pokedex.nsPredicate = dynamicPredicate
                }
                .onChange(of: filterByFavorite) {
                    pokedex.nsPredicate = dynamicPredicate
                }
                .navigationDestination(for: Pokemon.self) { pokemon in
                    Text(pokemon.name ?? "no name")
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            filterByFavorite.toggle()
                        } label: {
                            Label("Filter by predicate", systemImage: filterByFavorite ? "star.fill": "star")
                        }
                        .tint(.yellow)
                    }
                }
            }
        }
    }

    private func getPokemon(from id: Int) {
        Task {
            for i in id..<152 {
                do {
                    let pokemonDTO = try await apiService.fetchPokemon(i)
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
