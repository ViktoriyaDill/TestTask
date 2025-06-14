//
//  SplashView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


struct SplashView: View {
    
    var body: some View {
        ZStack {
            Color(hex: "#F4E041")
                .ignoresSafeArea()
            
            VStack(spacing: 16) {             
                Image("Cat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 95, height: 65)
                
                Text("TESTTASK")
                    .font(.custom("NunitoSans", size: 40))
                    .foregroundColor(.black)
            }
        }
    }
}
