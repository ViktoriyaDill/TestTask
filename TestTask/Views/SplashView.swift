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
            Color.yellow
                .ignoresSafeArea()
            
            VStack(spacing: 16) {             
                Image("Cat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                Text("TESTTASK")
                    .font(.custom("NunitoSans-Bold", size: 20))
                    .foregroundColor(.black)
            }
        }
    }
}
