//
//  PokedexCellView.swift
//  Dex
//
//  Created by वैभव उपाध्याय on 21/12/25.
//
import SwiftUI

struct PokedexCellView: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        AsyncImage(url: pokemon.sprite) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 100)
        
        VStack(alignment: .leading) {
            Text(pokemon.name?.capitalized ?? "NA")
                .fontWeight(.bold)
            
            HStack {
                ForEach(pokemon.types ?? [], id: \.self) { type in
                    Text(type.capitalized)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 5)
                        .background(Color(type.capitalized))
                        .cornerRadius(5)
                }
            }
        }
    }
}
