//
//  DeleteRecordView.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 11/15/25.
//

import Foundation
import SwiftUI

struct DeleteRecordView: View {
    @Environment(\.navigate) var navigate
    @State var deleteRecords: [deleteTimeUser] = []
    @State var deleteAllUserRecords: [deleteTimeUsers] = []
    @State var selectAllValidDelUsers: [deleteTimeUsers] = []
    @State var recUsers: [Users] = []
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var hoursStore: hoursStore
    @State var selectStartDate: Date = .now
    @State var selectEndDate: Date = .now
    @State var checkSuper: Bool = false
    @State var selectedUser: deleteTimeUsers? = nil
    @State var checkToGo: Bool = false
    @State var time_id: Int? = 1
    

    var body: some View {
        
        VStack {
            Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 40)
            
            Button("Home")
            {
                if(userStore.parentUser?.superUser == true)
                {
                    navigate(.superUser)
                }
                else
                {
                    navigate(.normalUser)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue)
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(x: -150, y: -50)
            .font(.system(size: 16))
            if(checkSuper == false)
            {
                HStack(spacing: 12){
                    DatePicker("Select Start Date", selection: $selectStartDate, displayedComponents: .date)
                }
                .padding(12)
                .frame(width:300)
                .background(Color.white)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .cornerRadius(12)
                .offset(y:150)
                
                HStack(spacing: 12){
                    DatePicker("Select End Date", selection: $selectEndDate, displayedComponents: .date)
                }
                .padding(12)
                .frame(width:300)
                .background(Color.white)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .cornerRadius(12)
                .offset(y:175)
            }
            else if (checkSuper == true)
            {
                Button("Back")
                {
                    if(userStore.parentUser?.superUser == true)
                    {
                        checkSuper = false
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: 150, y: -80)
                .font(.system(size: 16))

                HStack {
                    Text("Username")
                        .frame(width: 110, alignment: .leading)
                        .bold()
                    Text("First name")
                        .frame(width: 110, alignment: .leading)
                        .bold()
                    Text("Last name")
                        .frame(width: 110, alignment: .leading)
                        .bold()
                }
                .padding(.horizontal, 10)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(8)
                .padding(.horizontal)
                .offset(y: 120)
                
                .task{
                    deleteUsersToSelect()
                }
                 
                List(selectAllValidDelUsers) { delRec in
                    HStack{
                        Text(delRec.userName)
                            .frame(width: 100, alignment: .leading)
                        Text(delRec.firstName)
                            .frame(width: 100,alignment: .leading)
                        Text(delRec.lastName)
                            .frame(width: 100, alignment: .leading)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedUser = delRec
                        Task{
                            await fetchDelRecUsers()
                        }
                    }
                    .foregroundColor(selectedUser?.id == delRec.id ? Color.white : Color.black)
                    .listRowBackground(selectedUser?.id == delRec.id ? Color.blue : Color.gray)
                    
                }
                .scrollContentBackground(.hidden) // Hide default background
                .background(Color.clear) // Transparent background
                .offset(x: 0, y: 100)
                
            }
            
            
            Button("View Hours")
            {
                print("View Report button is pressed")
                hoursStore.delStartDate = selectStartDate
                hoursStore.delEndDate = selectEndDate
                if(userStore.parentUser?.superUser == true)
                {
                    
                    Task{
                        await fetchAllDeleteTimeUsers()
                    }
                    checkSuper = true
                }
                
                else
                {
                    Task {
                        await normalDelRecUsers()
                    }
                }
                 
            }
            .font(.custom("Georgia", size: 16))
            .padding(.vertical, 20)
            .padding(.horizontal, 35)
            .background(Color.blue)
            .foregroundColor(Color.black)
            .cornerRadius(8)
            .offset(x: 10, y: 250)
            
            Spacer()
        }
        .background(
            Image("bb8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.70)
                )
        )
    }
    private func fetchUsers() async {
        await allUsers()
        recUsers = totUsers
        await fetchDelRecUsers()
    }
    
    func deleteUsersToSelect() {
        print("Start Here")
        print(deleteAllUserRecords.count)

        for i in deleteAllUserRecords.indices {
            print("i \(i)")
            var count: Int = 0
            for j in selectAllValidDelUsers.indices {
                print("j \(j)")
                if(deleteAllUserRecords[i].userName.lowercased()==selectAllValidDelUsers[j].userName.lowercased()){
                    print("found record")
                    count+=1
                }
            }
            if(count==0){
                print("reached")
                selectAllValidDelUsers.append(deleteAllUserRecords[i])
                print(deleteAllUserRecords[i].firstName)
            }
            print("Array count: \(selectAllValidDelUsers.count)")
        }
        print("End Here")
        print(selectAllValidDelUsers.count)
    }
    
    func fetchAllDeleteTimeUsers() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        struct delAllUserParams: Codable {
            let time_id: Int
            let start_date: String
            let end_date: String
        }
            guard let timeid = time_id else {
                print("User ID is nil for user:")
                return;
            }
            
        do {
            let params = delAllUserParams(
                time_id: timeid,
                start_date: dateFormatter.string(from: hoursStore.delStartDate),
                end_date: dateFormatter.string(from: hoursStore.delEndDate),
            )
            
            deleteAllUserRecords = try await supabase.rpc(
                "deltimeusers",
                params: params,
            ).execute().value
        }
        catch {
            print("Error: \(error)")
            deleteAllUserRecords = []
        }
        print("Entries found for the new func")
        print(deleteAllUserRecords.count)
        deleteUsersToSelect()
    }
    
    func fetchDelRecUsers() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        struct delParams: Codable {
            let start_date: String
            let end_date: String
            let user_id: Int
        }
        
        guard let userid = selectedUser?.userid else {
            print("User ID is nil for user:")
            return;
        }
        print(selectedUser?.userid)
        do {
            let params = delParams(
                start_date: dateFormatter.string(from: hoursStore.delStartDate),
                end_date: dateFormatter.string(from: hoursStore.delEndDate),
                user_id: userid
            )
            
            deleteRecords = try await supabase.rpc(
                "deltime",
                params: params,
            ).execute().value
        }
        catch {
            print("Error: \(error)")
            deleteRecords = []
        }
        print("Entries found")
        print(deleteRecords.count)
        hoursStore.deleteRec = deleteRecords
        userStore.delRecUser = selectedUser
        navigate(.finDeleteTime)
    }
    
    
    func normalDelRecUsers() async {
        //use the parentstore id for this part.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        struct delParams: Codable {
            let start_date: String
            let end_date: String
            let user_id: Int
        }
        
        guard let userid = userStore.parentUser?.id else {
            print("User ID is nil for user:")
            return;
        }
        
        do {
            let params = delParams(
                start_date: dateFormatter.string(from: hoursStore.delStartDate),
                end_date: dateFormatter.string(from: hoursStore.delEndDate),
                user_id: userid
            )
            
            deleteRecords = try await supabase.rpc(
                "deltime",
                params: params,
            ).execute().value
        }
        catch {
            print("Error: \(error)")
            deleteRecords = []
        }
        hoursStore.deleteRec = deleteRecords
        userStore.delRecNormalUser = userStore.parentUser
        print(userStore.delRecUser?.firstName ?? "!")
        navigate(.finDeleteTime)
    }
    
}
#Preview{
    DeleteUserView()
}

//Key functionality:
//First we display two dates then we have a button. We press it and check if the parent's superuser value is true. If it is true, we display a list with an on tap gesture which selected a user which can then be used for the id in the function call. Otherwise if parent is a normal user, we just use the normal user value all in this one file.

//Next steps: navigate to next screen where we display the content from the function. Then we will select what to delete from there.
