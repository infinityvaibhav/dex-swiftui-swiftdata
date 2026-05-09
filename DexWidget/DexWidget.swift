//
//  DexWidget.swift
//  DexWidget
//
//  Created by वैभव उपाध्याय on 09/05/26.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry.placeholder
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 10 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset * 5, to: currentDate)!
            let entryPokemon = randomPokemon
            let entry = SimpleEntry(date: entryDate,
                                    name: entryPokemon.name!,
                                    types: entryPokemon.types!,
                                    sprite: entryPokemon.spriteImage)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    var randomPokemon: Pokemon {
        var results: [Pokemon] = []
        
        do {
            let viewContext = PersistenceController.shared.container
                .viewContext
            results = try viewContext.fetch(Pokemon.fetchRequest())
        } catch {
            print("Couldn't fetch")
        }
        
        if let randomPokemon = results.randomElement() {
            return randomPokemon
        }
        return PersistenceController.previewPokemon
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let types: [String]
    let sprite: Image
    
    static var placeholder: Self {
        SimpleEntry(date: .now, name: "Bulbasaur", types: ["grass", "Poison"], sprite: Image(.bulbasaur))
    }
    
    static var placeholder2: Self {
        SimpleEntry(date: .now, name: "Mew", types: ["psychic"], sprite: Image(.mew))
    }
}

struct DexWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetSize
    var entry: Provider.Entry

    var body: some View {
        switch widgetSize {
        case .systemMedium:
            HStack {
                pokemonImage
                Spacer()
                VStack(alignment: .leading, spacing: 1) {
                    Text(entry.name.capitalized)
                        .font(.title)
                    
                    HStack {
                        typesView
                    }
                }
                .layoutPriority(1)
                Spacer()
            }
        case .systemLarge:
            ZStack {
                pokemonImage
                
                VStack(alignment: .leading) {
                    Text(entry.name.capitalized)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Spacer()
                    
                    HStack {
                        Spacer()
                        typesView
                    }
                }
            }
        default:
            pokemonImage
        }
    }
    
    var pokemonImage: some View {
        entry.sprite
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .shadow(radius: 6)
    }
    
    var typesView: some View {
        ForEach(entry.types, id: \.self) { type in
            Text(type.capitalized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .padding(.horizontal, 13)
                .padding(.vertical, 5)
                .background(Color(type.capitalized))
                .cornerRadius(5)
                .shadow(radius: 3)
        }
    }
}

struct DexWidget: Widget {
    let kind: String = "DexWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DexWidgetEntryView(entry: entry)
                    .foregroundStyle(.black)
                    .containerBackground(Color(entry.types[0].capitalized), for: .widget)
            } else {
                DexWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Pokemon")
        .description("See a random pokemon.")
    }
}

#Preview(as: .systemSmall) {
    DexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}

#Preview(as: .systemMedium) {
    DexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}

#Preview(as: .systemLarge) {
    DexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}
