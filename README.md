# Flutter E-Ticaret

Flutter ile geliştirilmiş, Android, iOS ve Web platformlarında çalışan bir e-ticaret uygulaması.

## Kullanılan Flutter Sürümü

- **Flutter Kanalı:** stable
- **Flutter Revision:** `c9a6c48423`
- **Dart SDK:** `^3.12.2` (<4.0.0)
- **Desteklenen Platformlar:** Android, iOS, Web

## Çalıştırma Adımları

### 1. Gereksinimler

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable kanal, sürüm 3.18+) kurulu olmalıdır.
- Bir IDE (Android Studio, VS Code veya IntelliJ) veya komut satırı.

### 2. Projeyi Klonlama

```bash
git clone https://github.com/ahmet0033/flutter-projesi.git
cd flutter_projesi
```

### 3. Bağımlılıkları Yükleme

```bash
flutter pub get
```

Bu komut, `pubspec.yaml` dosyasındaki bağımlılıkları indirir ve Android Gradle wrapper (`gradlew`) dosyalarını otomatik oluşturur.

### 4. Uygulamayı Çalıştırma

- **Bağlı bir cihaz veya emülatör ile:**

  ```bash
  flutter run
  ```

- **Web tarayıcıda:**

  ```bash
  flutter run -d chrome
  ```

- **Belirli bir platform için derleme:**

  ```bash
  flutter build apk          # Android APK
  flutter build ios           # iOS (yalnızca macOS)
  flutter build web           # Web
  ```

### Notlar

- `android/local.properties` dosyası `.gitignore` ile ignore edilmiştir. `flutter pub get` çalıştırıldığında otomatik oluşur. El ile oluşturmak gerekmez.
- `android/gradlew` ve `android/gradlew.bat` dosyaları artık sürüm kontrolüne dahil edilmiştir. `flutter pub get` alternatif olarak bunları yeniden oluşturabilir.
- `.dart_tool/`, `/build/`, `.idea/` gibi dizinler `.gitignore` ile ignore edilmiştir ve sürüm kontrolünde yer almaz.
