//
//  time.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 9/6/25.
//

import Foundation
struct timesheet: Codable, Identifiable {
    let id: Int?
    let hours: Double
    let workdate: Date
    let recordedat: Date
    let userid: Int?
    let starttimedecimal: Double
    let endtimedecimal: Double
    let starttime: String
    let endtime: String
}

//used for ADDING a new time sheet for someone 
