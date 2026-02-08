//
//  UserStore.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 9/9/25.
//

import SwiftUI
class UserStore: ObservableObject{
    @Published var currentUser: Users? = nil
    @Published var parentUser: Users? = nil
    @Published var fetchSingleUser: Users? = nil
    @Published var delRecUser: deleteTimeUsers? = nil
    @Published var delRecNormalUser: Users? = nil
    @Published var deleteRecord: deleteTimeUser? = nil
}
//currentUser olds the user for the recording times. How do we know which user we want when we navigate to the next view?
//parentUser holds the user of whoever logs in. This is so that the menu can be displayed properly as to know who to log back in for.

