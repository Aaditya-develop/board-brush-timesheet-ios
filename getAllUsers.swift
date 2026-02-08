//
//  getAllUsers.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 10/26/25.
//

import Foundation
import SwiftUI

//fetches supabase call to the Users table and returns eveerything in the table, then storing it in totUsers. 
func allUsers() async{
    do {
        totUsers = try await supabase
            .from("Users")
            .select()
            .order("firstName", ascending: true)
            .execute()
            .value
    } catch {
        dump(error)
    }
}
