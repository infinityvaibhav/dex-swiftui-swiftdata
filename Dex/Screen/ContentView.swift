//
//  ContentView.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 17/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Pokemon.id, animation: .default) private var pokedex: [Pokemon]
    
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
                            .swipeActions(edge: .leading) {
                                Button(pokemon.favorite ? "Remove from favorite" : "Add to favorite", systemImage: "star") {
                                    pokemon.favorite.toggle()
                                    
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print(error)
                                    }
                                }
                                .tint(pokemon.favorite ? .gray : .yellow)
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
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetailView(pokemon: pokemon)
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
                    modelContext.insert(pokemonDTO)
                } catch {
                    throw error
                }
            }
            await storeSprites()
        }
    }
    
    private func storeSprites() async {
        do {
            for pokemon in pokedex {
                pokemon.sprite = try await URLSession.shared.data(from: pokemon.spriteURL!).0
                pokemon.shiny = try await URLSession.shared.data(from: pokemon.shinyURL!).0
                try modelContext.save()
                
                print("Sprites stored: \(pokemon.id): \(pokemon.name.capitalized)")
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PersistenceController.preview)
}
