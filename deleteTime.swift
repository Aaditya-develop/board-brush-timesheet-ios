//
//  deleteTime.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 11/13/25.
//

import Foundation

struct deleteTimeUser: Decodable, Identifiable {
    let id: Int
    let userName: String
    let firstName: String
    let lastName: String
    let workDate: String
    let hours: Double
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "username"
        case firstName = "firstname"
        case lastName = "lastname"
        case workDate = "workdate"
        case hours
    }
}


//FOR FUTURE:
//coding keys is INSIDE the struct.
//case calls have to MAP to the collumns of the table (CRITICAL) You map the variable names of the function call, then the collumns name need to be the SAME


//we will make another file, called deleteUserRecord
//we will call our choose a user to delete from our function we made(list)
//we will display 2 dates we want to select (choose the currwnt dateReportCheck or a new file)
//Lastly, we will delete the current record we are on.
