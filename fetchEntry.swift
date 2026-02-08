struct fetchUserEntries: Identifiable, Decodable {
    var id: String { username }  // Use the same property you decoded
    
    let username: String  // Matches JSON key "userName" if handled by CodingKeys
    let firstname: String  // Matches JSON key "firstName"
    let lastname: String
    let total_hours: Double  // Matches JSON key "total_hours"
    
    
    // CODINGKEYS: Maps JSON field names to Swift property names to ensure decoding variables get passsed.

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case lastname = "lastname"
        case firstname = "firstname"
        case total_hours
    }
}

//Used for supabase function to return timesheet summary
