import Foundation

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en" {
        didSet {
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.set(selectedLanguage, forKey: "AppLanguage")
            UserDefaults.standard.synchronize()
            
            // Notify the system to update UI text
            Bundle.setLanguage(selectedLanguage)
            objectWillChange.send()
        }
    }
}
