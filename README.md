# GXPhotoPicker

## SwiftUI + PHPicker.

# 🔷 Требования

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Xcode 12.0  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Swift 5+  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ iOS 14

# 🔷 Установка

`GXPhotoPicker` доступен через [Swift Package Manager](https://swift.org/package-manager).

Используя Xcode 12 и выше, нужно зайти в  `File -> Swift Packages -> Add Package Dependency` ввести адрес репозитория. 
Выбираем последнюю версию по тегу, ждем синхронизации, вуаля, можно использовать утилитки) 
При обновлении утилит, можно воспользоваться `File -> Swift Packages -> Update to Latest packages versions`

# 🔷 Documentation

``` swift
struct ContentView: View {
    @State var showPicker: Bool = false   
    @State var pickedImage: [UIImages] = [] 
    var body: some View {
        Button("Show Photopicker") {
            showPicker.toggle()
        }
        .padding()
        .sheet(isPresented: $showPicker) {
            GXPhotoPicker(images: $pickedImages, imageCount: 2, handlePickedImage { _ in 
            // do whatever you want...
            })
        }
    }
}
```

![example](./exampleLook.jpg)

# 🔷 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

🔷🔷🔷 https://garpix.com 🔷🔷🔷
