//
//  deleteTimeUsers.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 1/15/26.
//

import Foundation

struct deleteTimeUsers: Decodable, Identifiable {
    let id: Int
    let userName: String
    let firstName: String
    let lastName: String
    let workDate: String
    let userid: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "username"
        case firstName = "firstname"
        case lastName = "lastname"
        case workDate = "workdate"
        case userid = "userid"
    }
}

