//
//  TimeReportView.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 9/17/25.
//
import SwiftUI


struct TimeReportView: View {
    @Environment(\.navigate) var navigate
    @State var users: [Users] = []
    @State var enterTheUser: String = ""
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reportStore: ReportStore
    @EnvironmentObject var theHoursStore: hoursStore
    @State private var selectedUser: Users? = nil
    @State private var saveAlert: Bool = false;
    var body: some View {
        VStack{
            Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 40)
                .offset(x: 0, y: 30)
            
                Button("Home"){
                    navigate(.superUser)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: -150, y: -40)
                .font(.system(size: 16))
            
            if(userStore.parentUser?.superUser == true)
            {
                Button("Back")
                {
                    navigate(.superUser)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: 150, y: -60)
                .font(.system(size: 16))
            }
            
            HStack(spacing: 12) {
                Text("Username:")
                    .frame(width: 90, alignment: .leading)
                    .foregroundColor(.secondary)
                
                TextField("Type here, then enter", text: $enterTheUser)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit{
                        validate()
                    }
            }
            .padding(12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
            .frame(width:350)
            .cornerRadius(12)
            .shadow(radius: 1, y: 1)
            .offset(x: 0, y: 50)

        
            
            HStack {
                Text("Username")
                    .frame(width: 90, alignment: .leading)
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
            .padding(.horizontal)
            .offset(y: 110)
            
            //List the users array.... user is each index
            List(users) { user in
                    HStack{
                        Text(user.userName+":")
                            .frame(width: 100, alignment: .leading)
                        Text(user.firstName)
                            .frame(width: 100, alignment: .leading)
                        Text(user.lastName)
                            .frame(width: 100, alignment: .leading)
                    }
              
                    .contentShape(Rectangle())
                
                    .onTapGesture{
                        selectedUser = user;
                        enterTheUser = user.userName
                    }
                    .foregroundColor(selectedUser?.id == user.id ? Color.white : Color.black)
                    .listRowBackground(selectedUser?.id == user.id ? Color.blue : Color.gray)
            }
            .scrollContentBackground(.hidden) // Hide default background
            .background(Color.clear) // Transparent background
            .offset(x: 0, y: 100)
            Spacer()
            
             
        }
             
        .background(
            Image("bb13")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.70)
                )
        )
        //task is useful for async
        .task {
            do {
                users = try await supabase.from("Users")
                    .select()
                    .order("firstName", ascending: true)
                    .execute()
                    .value
            } catch {
                dump(error)
            }
        }
    }
    
    private func validate(){
        if enterTheUser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            saveAlert = true;
        }
        else{
            saveUser()
            navigate(.dateReportCheck)
        }

    }
    func saveUser()
    {
        for currUser in users
        {
            if(currUser.userName.lowercased() == enterTheUser.lowercased())
            {
                reportStore.currentTimesheetUserId = currUser;
            }
        }
    }
        
}

#Preview{
    TimeReportView()
}
