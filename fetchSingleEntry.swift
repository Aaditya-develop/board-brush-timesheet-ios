import Foundation
struct SingleUserEntry: Decodable, Identifiable {
    let id: Int
    let workDate: String
    let hours: Double
    let startTime: String?
    let endTime: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "time_id"
        case workDate = "workdate"  
        case hours
        case startTime = "starttime"
        case endTime = "endtime"
    }
}

//struct is sued for value type
