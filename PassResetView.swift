//
//  PassResetView.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 11/23/25.
//

import Foundation
import SwiftUI

struct PassResetView: View {
    @EnvironmentObject var userStore: UserStore
    @Environment(\.navigate) var navigate
    @State var uUsers: [Users] = []
    @State var pUsers: [Users] = []
    @State var uname: String = ""
    @State var oldPwd: String = ""
    @State var pwd: String = ""
    @State var checkUsername: Bool = false
    @State var selectedUser: Users? = nil
    @State var checkPassSucc: Bool = false
    @State var checkOldPass: Bool = false
    var body: some View {
        ZStack {
            Image("bb10")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.60)
                        .ignoresSafeArea()
                )
            
            VStack{
                Image("bb")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 40)
                
                    Menu("Menu"){
                        if(userStore.parentUser?.superUser ==  true)
                        {
                            Button("Menu screen")
                            {
                                navigate(.superUser)
                            }
                        }
                        else
                        {
                            Button("Menu screen")
                            {
                                navigate(.normalUser)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .offset(x: -150, y: -30)
                    .font(.system(size: 16))
                
                
                
                if(checkPassSucc == false)
                {
                    HStack
                    {
                        Text("Username: \(userStore.parentUser?.userName ?? "")")
                            .frame(width: 325, alignment: .leading)
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .task
                            {
                                uname = userStore.parentUser?.userName ?? ""; await checkUser()
                            }
                    }
                    .padding(12)
                    .frame(maxWidth: 350)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .shadow(radius: 1, y: 1)
                    .offset(x: 0, y: 150)
                    
                    
                    HStack
                    {
                        Text("Old Password:")
                            .frame(width: 130, alignment: .leading)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        TextField("Type Here then enter.....", text: $oldPwd)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(.black)
                            .foregroundColor(.black)
                    }
                    .padding(12)
                    .frame(maxWidth: 350)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .shadow(radius: 1, y: 1)
                    .offset(x: 0, y: 150)
                    .onSubmit{
                        Task{
                            await checkPass()
                        }
                    }

                    
                
                if(checkUsername == true && checkOldPass == true) {
                    HStack {
                        Text("New Password:")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        TextField("Type New Password", text: $pwd)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(.black)
                    }
                    .onSubmit{
                        Task{
                            await changePass()
                        }
                    }
                    .frame(maxWidth: 350)
                    .padding(12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .shadow(radius: 1, y: 1)
                    .offset(x: 0, y: 150)
                    
                }
            }
            
            if(checkPassSucc == true)
            {
                   Text("Succesfully Changed Password!")
                    .foregroundColor(Color.white)
                    .font(.system(size:25))
                    .offset(y:250)
            }
                
                Spacer()
            }
            .padding()
        }
    }
    
    func checkPass() async
    {
        await allUsers()
        pUsers = totUsers
        for pUser in pUsers
        {
            if(pUser.isActive)
            {
                if(pUser.passWord.lowercased() == oldPwd.lowercased())
                {
                    checkOldPass = true
                    print("Old pass found")
                    break
                }
            }
        }
        
    }
    
    func checkUser() async
    {
        await allUsers()
        uUsers = totUsers
            for user in uUsers
            {
                if(user.isActive)
                {
                    if(user.userName.lowercased() == uname.lowercased())
                    {
                        selectedUser = user
                        checkUsername = true
                        print("found")
                        break
                    }
                }
            }
    }
    
    func changePass() async {
        do {
            try await supabase
                .from("Users")
                .update(["passWord": pwd])
                .eq("id", value: selectedUser?.id)
                .execute()
            checkPassSucc = true
        }
        catch {
            print("Error loading data: \(error)")
        }
    }
}
#Preview {
    PassResetView()
}
/*
 .from("Users")
 .update(["isActive": false])
 .eq("id",value: selectedUser?.id)
 .execute()
 */
