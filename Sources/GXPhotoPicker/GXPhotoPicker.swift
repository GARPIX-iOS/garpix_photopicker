//
//  PHPPhotoPicker.swift
//
//
//  Created by yns on 21.12.2021.
//

import SwiftUI
import PhotosUI

/// PHPPhotoPicker чтобы выбрать фотографию из библиотеки или сделать снимок с камеры.
@available(iOS 14, *)
public struct GXPhotoPicker: UIViewControllerRepresentable {
    /// Массив картинок, которые передаются из библиотеки
    @Binding var images: [UIImage]
    @Environment(\.presentationMode) private var presentationMode
    /// Сколько фотографий можно выбрать. 0 означает отсутствие ограничений.
    var imageCount: Int
    /// Обработчик, который передает URL сделанной фотографии
    let handlePickedImage: (URL) -> Void
    
    /// Функция для настройки конфигурации пикера, принимает параметр количество изображений imageCount.
    /// - Returns: PHPickerConfiguration
    func configurePHPPicker() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = imageCount
        configuration.preferredAssetRepresentationMode = .current
        return configuration
    }
    
    /// Функция для создания UIViewController, вызывается один раз.
    /// - Parameter context: Контекст, который мы помещаем в UIViewController
    /// - Returns: UIViewController с нашим контекстом - PHPickerViewController
    
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let photoPickerViewController = PHPickerViewController(configuration: configurePHPPicker())
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    /// Этот метод пуст, потому что он никогда не будет обновлен.
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    /// Функция создает координатор для связи с контроллером
    /// - Returns: Координатор
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, handlePickedImage: handlePickedImage)
    }
    
    public class Coordinator: PHPickerViewControllerDelegate {
        private let parent: GXPhotoPicker
        private let handlePickedImage: (URL) -> Void
        
        init(_ parent: GXPhotoPicker, handlePickedImage: @escaping (URL) -> Void) {
            self.parent = parent
            self.handlePickedImage = handlePickedImage
        }
        
        public func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let imageUrl = info[.imageURL] as? URL {
                handlePickedImage(imageUrl)
            }
            /// Dismiss the picker.
            parent.presentationMode.wrappedValue.dismiss()
        }
        /// Вызывается, когда пользователь заканчивает выбор фотографии.
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            /// Удаляется предыдущие изображения из основного представления
            parent.images.removeAll()
            
            /// Распаковка выбранные элементы
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        if let error = error {
                            print("Can't load image \(error.localizedDescription)")
                        } else if let image = newImage as? UIImage {
                            DispatchQueue.main.async {
                                self?.parent.images.append(image)
                            }
                        }
                    }
                } else {
                    print("Can't load asset")
                }
                                
            }
            /// Dismiss the picker.
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
