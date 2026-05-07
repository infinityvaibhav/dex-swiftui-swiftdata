//
//  StatsView.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 07/05/26.
//
import SwiftUI
import Charts

struct StatsView: View {
    let pokemon: Pokemon
    
    var body: some View {
        Chart(pokemon.stats) { stat in
            BarMark(
                x: .value("Value", stat.value),
                y: .value("Stat", stat.name)
            )
            .annotation(position: .trailing) {
                Text("\(stat.value)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, -5)
            }
        }
        .frame(height: 200)
        .padding([.horizontal, .bottom])
        .padding()
        .foregroundStyle(pokemon.typesColor)
        .chartXScale(domain: 0...pokemon.highestStat.value+10)
    }
}

#Preview {
    StatsView(pokemon: PersistenceController.previewPokemon)
}
