//
//  MainNavTitle.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI


struct MainNavTitle: View {
    
    @State var request: String
    
    var body: some View {
        Text("Working with \(request) request")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#F4E041").frame(maxWidth: .infinity))
            .font(.custom("NunitoSans", size: 20))
        Spacer()
    }
    
}
