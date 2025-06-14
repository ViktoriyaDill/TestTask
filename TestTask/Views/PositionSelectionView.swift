//
//  PositionSelectionView.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI

struct PositionSelectionView: View {
    let positions: [Position]
    @Binding var selectedPosition: Position?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select your position")
                .font(.headline)
            
            ForEach(positions) { position in
                HStack {
                    Button(action: {
                        selectedPosition = position
                    }) {
                        HStack {
                            Image(systemName: selectedPosition?.id == position.id ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(selectedPosition?.id == position.id ? .blue : .gray)
                            Text(position.name)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
