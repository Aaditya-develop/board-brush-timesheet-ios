//
//  DeleteUserView.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 11/8/25.
//

import Foundation
import SwiftUI

struct DeleteUserView: View {
    @Environment(\.navigate) var navigate
    @State private var deleteTheUser: [Users] = []
    @State private var selectedUser: Users? = nil
    @State private var checkDel: Bool = false
    @State private var checkAfterDel: Bool  = false
    @State private var mistakeDel: Bool = false
    
    var body: some View {
        VStack {
            Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 40)
            
            Button("Home")
            {
                navigate(.superUser)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue)
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(x: -150, y: -50)
            .font(.system(size: 16))
           
            if(checkDel == false)
            {
                Text("Select and Enter the User you want to Delete")
                     .font(.custom("Georgia", size: 16))
                     .foregroundColor(.white)
                     .offset(y:20)
                
                .task
                {
                    await allUsers()
                    for i in totUsers.indices {
                        if(totUsers[i].isActive == true)
                        {
                            deleteTheUser.append(totUsers[i])
                            //use append because deleteTheUser is an empty array initially
                            //print(deleteTheUser[i].firstName)
                        }
                    }
                    if(deleteTheUser.isEmpty){
                        print("Empty")
                    }
                    else{
                        print(deleteTheUser.count)
                    }
                }
                
                if deleteTheUser.isEmpty{
                    Text("Not loading")
                }
                else {
                    HStack {
                        Text("Username")
                            .frame(width: 120, alignment: .leading)
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
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
                    .offset(y: 70)
                    List(deleteTheUser) { dUser in
                        HStack{
                            Text(dUser.userName)
                                .frame(width: 110, alignment: .leading)
                            Text(dUser.firstName)
                                .frame(width: 110,alignment: .leading)
                            Text(dUser.lastName)
                                .frame(width: 110, alignment: .leading)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedUser = dUser
                            checkDel = true
                        }
                        .foregroundColor(selectedUser?.id == dUser.id ? Color.white : Color.black)
                        .listRowBackground(selectedUser?.id == dUser.id ? Color.blue : Color.gray)
                    }
                    .scrollContentBackground(.hidden) // Hide default background
                    .background(Color.clear) // Transparent background
                    .offset(x: 0, y: 40)
                }
            }
            
            else if (checkDel == true)
            {
                if(!checkAfterDel && !mistakeDel)
                {
                    VStack(spacing: 30)
                    {
                        VStack(spacing: 20)
                        {
                            Text("Confirmation to delete \(selectedUser?.firstName ?? "") \(selectedUser?.lastName ?? "")")
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        
                        HStack(spacing: 50)
                        {
                            Button
                            {
                                print("Cancel tapped!")
                                checkDel = false
                                mistakeDel = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            
                            Button {
                                print("Confirm tapped!")
                                Task {
                                    await delUser()
                                }
                                checkDel = false
                                checkAfterDel = true
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .font(.system(size: 50))
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 35)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .offset(y: 150)
                }
                else if(checkAfterDel)
                {
                    Text("\(selectedUser?.firstName ?? "") \(selectedUser?.lastName ?? "") is now unactive!!")
                        .offset(y:75)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
 
            }

                
            
           Spacer()
        }
            .background(
                Image("bb15")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                        Color.black.opacity(0.60)
                    )
            )
    }
    
    func delUser() async{
            do {
                try await supabase
                    .from("Users")
                    .update(["isActive": false])
                    .eq("id",value: selectedUser?.id)
                    .execute()
            }
            catch {
                print("Failed to update database: \(error)")
            }
            checkDel = true;
        }
    

        
}

#Preview{
    DeleteUserView()
}
