//
//  Persistence.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 17/12/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
            let newPokemon = Pokemon(context: viewContext)
            newPokemon.id = 1
            newPokemon.name = "Bulbasaur"
            newPokemon.types = ["Grass", "Poison"]
            newPokemon.hp = 45
            newPokemon.attack = 49
            newPokemon.specialAttack = 65
            newPokemon.specialDefence = 65
            newPokemon.speed = 45
            newPokemon.sprite = URL(string: "https://www.githubsercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
            newPokemon.shiny = URL(string: "https://www.githubsercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dex")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error)
            }
        })
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
