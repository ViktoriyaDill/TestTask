//
//  PhotoUploadView.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI

struct PhotoUploadView: View {
    
    let photoData: Data?
    let errorMessage: String
    
    @Binding var showPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    .frame(height: 56)
                
                HStack {
                    Text(photoData != nil ? "photo.jpg" : "Upload your photo")
                        .foregroundColor(photoData == nil ? .gray : .primary)
                        .font(.system(size: 18))

                    Spacer()

                    Button("Upload") {
                        showPicker = true
                    }
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.cyan)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
