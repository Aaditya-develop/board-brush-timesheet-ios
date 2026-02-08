import Foundation

// CODABLE PROTOCOL: Allows automatic JSON encoding/decoding with Supabase
// IDENTIFIABLE: Required for SwiftUI Lists and ForEach loops
struct Users: Codable, Identifiable {
    let id: Int?             // Primary key (optional for new records before insertion)
    let firstName: String    // Maps to database column names
    let lastName: String
    let userName: String
    let passWord: String
    let superUser: Bool      // Determines admin vs normal user permissions
    var isActive: Bool
}


//Used mainly for returning USERS table 
