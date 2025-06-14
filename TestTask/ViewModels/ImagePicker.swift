//
//  ImagePicker.swift
//  TestTask
//
//  Created by Пользователь on 14.06.2025.
//

import SwiftUI
import UIKit




enum ImageEncoding {
    case jpeg(compressionQuality: CGFloat)
    case png

    
    func data(from image: UIImage) -> Data? {
        switch self {
        case .jpeg(let quality):
            return image.jpegData(compressionQuality: quality)
        case .png:
            return image.pngData()
        }
    }
}



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var data: Data?
    let encoding: ImageEncoding
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    
    final class Coordinator: NSObject,
                             UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {

        let parent: ImagePicker
        init(parent: ImagePicker) { self.parent = parent }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage,
               let data = parent.encoding.data(from: image) {
                parent.data = data
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.sourceType = sourceType              
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
}

