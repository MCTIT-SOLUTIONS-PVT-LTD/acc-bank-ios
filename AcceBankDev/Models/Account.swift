import Foundation

struct Account: Identifiable, Codable {
    var id = UUID()
    var accountName: String  // e.g., "No Fee"
    var accountType: String  // e.g., "Chequing"
    var accountNumber: String // e.g., "100108226953"
    var balance: String       // e.g., "$51,494.78"
}
