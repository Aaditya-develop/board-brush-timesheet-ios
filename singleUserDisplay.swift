//
//  singleUserDisplay.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 10/26/25.
//

import SwiftUI


struct singleUserDisplay: View{
    @Environment(\.navigate) var navigate
    @EnvironmentObject var entryStore: hoursStore
    @EnvironmentObject var userStore: UserStore

    var body: some View{
        VStack{
            Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 40)
                .offset(x: 0, y: 30)
            
            Menu("Menu"){
                if(userStore.parentUser?.superUser == true)
                {
                    Button("Menu screen"){
                        navigate(.superUser)
                    }
                    Button("Report View"){
                        navigate(.finalDateView)
                    }
                }
                else
                {
                    Button("Menu screen"){
                        navigate(.normalUser)
                    }
                }
                
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color.blue)
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(x: -150, y: -40)
            .font(.system(size: 16))
            
            if(userStore.parentUser?.superUser == true) {
                Button("Back")
                {
                    navigate(.finalDateView)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: 150, y: -70)
                .font(.system(size: 16))
            }

            
            let name = userStore.fetchSingleUser?.firstName
            HStack{
                Text("Records for \(name ?? "Not Found")")
            }
            .foregroundColor(.white)
            .offset(y:25)
            
            HStack(spacing: 40) {
                Text("Date")
                    .bold()
                Text("Hours")
                    .bold()
                Text("Start")
                    .bold()
                Text("End")
                    .bold()
            }
            .padding(.horizontal, 40)
            .background(.white)
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(y: 90)

            let singleUsers = entryStore.singleEntries
            List(singleUsers) { entry in
                ScrollView(.horizontal){
                    HStack(spacing: 25) {
                        Text("\(entry.workDate)")
                        Text("\(entry.hours, specifier: "%.2f")")
                        Text("\(entry.startTime ?? "")")
                        Text("\(entry.endTime ?? "")")
                    }
                    .padding(.horizontal, 15)
                }
            }
            .frame(width: 430)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .offset(y: 50)
            
            
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
        
    }
    
    
}

#Preview{
    singleUserDisplay()}

