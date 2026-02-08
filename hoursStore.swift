//
//  hoursStore.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 10/6/25.
//

import Foundation
import SwiftUI

//class to save and access the variables across different views. Observable Object helps us with that. 
class hoursStore: ObservableObject {
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var timeEntries: [fetchUserEntries] = []    //For first fucntion (summary report)
    @Published var singleEntries: [SingleUserEntry] = []    //For second fgunction (for one user report)
    @Published var deleteRec: [deleteTimeUser] = [] //For delete time record function
    @Published var delStartDate: Date = Date()
    @Published var delEndDate: Date = Date()
    
    //@Published var totalHours: Double = 0.0
    //@Published var selectedUserId: Int? = nil
}

//How do we save data that we need globally?
//Make a class with an observable object, declare all variables you need, then update them throughout other files. 
