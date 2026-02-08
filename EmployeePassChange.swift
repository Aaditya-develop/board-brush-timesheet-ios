//
//  EmployeePassChange.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 12/6/25.
//

import Foundation
import SwiftUI
struct EmployeePassChange: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var userStore: UserStore
    @State var users: [Users] = []
    @State var passUsers: [Users] = []
    @State var uname: String = ""
    @State var pwd: String = ""
    @State var newpwd: String = ""
    @State var userAndPassCheck: Bool = false //boolean check for when username and pwd are both in database
    @State var checkListView: Bool = true
    @State var finalPassSucess: Bool = false
    @State var selectedUser: Users? = nil
    var body: some View {
        ZStack
        {
            Image("bb7")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.60)
                )
            VStack
            {
                Image("bb")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 40)
                
                Button("Menu")
                {
                    if (userStore.parentUser?.superUser == true)
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
                .font(.system(size: 16))
                .offset(x: -150, y: -15)
                
                
                if(checkListView == true)
                {
                    Text("Select and Enter the User whose password you wish to change")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center) // Better text wrapping
                        .padding(.horizontal)
                        .font(.custom("Georgia", size: 16))
                        .offset(y:50)
                    
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
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .offset(y: 60)
                    
                    List(users) { user in
                        //Group{
                        HStack{
                            Text(user.userName+":")
                                .frame(width: 100, alignment: .leading)
                            Text(user.firstName)
                                .frame(width: 100, alignment: .leading)
                            Text(user.lastName)
                                .frame(width: 100, alignment: .leading)
                        }
                        .contentShape(Rectangle()) //Used so we can tap anywhere on the row
                        //Ontapgesture is how we can interact with the rows. Setting the selectedUser through a tap
                        .onTapGesture
                        {
                            uname = user.userName
                            pwd = user.passWord
                            Task
                            {
                                await checkUserAndPass()
                            }
                        }
                        .foregroundColor(selectedUser?.id == user.id ? Color.white : Color.black)
                        .listRowBackground(selectedUser?.id == user.id ? Color.blue : Color.gray)
                    }
                    .frame(maxWidth: 400)
                    .scrollContentBackground(.hidden) // Hide default background
                    .background(Color.clear) // Transparent background
                    .offset(x: 0, y: 50)
                }
                
                if(userAndPassCheck == true && checkListView == false && finalPassSucess == false)
                {
                    HStack
                    {
                        Text("New Password:")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        TextField("Type Here then enter.....", text: $newpwd)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(.black)
                            .foregroundColor(.black)
                            .onSubmit{
                                Task{
                                    await changeToNewPass()
                                }
                            }
                    }
                    .padding(12)
                    .frame(maxWidth: 340)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .shadow(radius: 1, y: 1)
                    .padding(.top, 15)
                }
                
                if(finalPassSucess == true)
                {
                    Text("Sucessfully Changed Password")
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .font(.custom("Georgia", size: 16))
                }
                
                Spacer()
            }
            .task {
                do {
                    users = try await supabase.from("Users")
                        .select()
                        .eq("isActive",value: true)
                        .order("firstName", ascending: true)
                        .execute()
                        .value
                }
                catch {
                    dump(error)
                }
            }
        }

    }
    func checkUserAndPass() async
    {
        await allUsers()
        passUsers = totUsers
        if(!(uname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && pwd.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
        {
            for passUser in passUsers
            {
                if(passUser.isActive)
                {
                    if(passUser.userName.lowercased() == uname.lowercased() && passUser.passWord.lowercased() == pwd.lowercased())
                    {
                        selectedUser = passUser
                        print(selectedUser?.firstName ?? "None")
                        userAndPassCheck = true
                        checkListView = false
                        break
                    }
                    
                }
            }
        }
    }
    func changeToNewPass() async
    {
        do
        {
            try await supabase
                .from("Users")
                .update(["passWord": newpwd])
                .eq("id", value: selectedUser?.id)
                .execute()
            finalPassSucess = true
        }
        
        catch
        {
            print("Error loading data: \(error)")
        }
    }
}
#Preview
{
    EmployeePassChange()
}
