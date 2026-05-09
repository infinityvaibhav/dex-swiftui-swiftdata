//
//  Persistence.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 17/12/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var previewPokemon: Pokemon {
        let context = PersistenceController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try! context.fetch(fetchRequest)
        
        return results[0]
    }

    /// The thing that controls our sample preview database
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
            let newPokemon = Pokemon(context: viewContext)
            newPokemon.id = 1
            newPokemon.name = "Bulbasaur"
            newPokemon.types = ["Grass", "Poison"]
            newPokemon.hp = 45
            newPokemon.attack = 49
            newPokemon.defense = 49
            newPokemon.specialAttack = 65
            newPokemon.specialDefence = 65
            newPokemon.speed = 45
            newPokemon.spriteURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
            newPokemon.shinyURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
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
        } else {
            container.persistentStoreDescriptions.first!.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.infinityvaibhav.dexapp.dexgroup")!.appending(path: "Dex.sqlite")
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
