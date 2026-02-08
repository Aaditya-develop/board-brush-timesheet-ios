//
//  FinalDelRecView.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 11/16/25.
//
import Foundation
import SwiftUI

struct FinalDelRecView: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var hoursStore: hoursStore
    @State var newDelTime: [deleteTimeUser] = []
    @State var check: Bool = false
    @State var deleteRecUser: deleteTimeUser? = nil
    @State var checkTapSuc: Bool = false
    @State var mistakeDelRec: Bool = false
    @State var checkAfterDelRec: Bool = false
    
    // Computed property to get the correct user name
    private var displayUserName: String {
        if userStore.parentUser?.superUser == true {
            return userStore.delRecUser?.firstName ?? "Unknown"
        } else {
            return userStore.delRecNormalUser?.firstName ?? "Unknown"
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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
            
            Button("Back")
            {
                if(userStore.parentUser?.superUser == true)
                {
                    navigate(.deleteTime)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue)
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(x: 150, y: -80)
            .font(.system(size: 16))

            
            if(checkTapSuc == false)
            {
                let newDelTime = hoursStore.deleteRec
                let firstDate = hoursStore.delStartDate
                let endDate = hoursStore.delEndDate
                
                HStack
                {
                    VStack
                    {
                        VStack
                        {
                            Text("User: \(displayUserName)")
                            Text("Select the timesheet you want to delete from")
                        }
                        HStack
                        {
                            Text(Self.dateFormatter.string(from: firstDate))
                            Text("-")
                            Text(Self.dateFormatter.string(from: endDate))
                        }
                    }
                    
                }
                .foregroundColor(.white)
                .bold()
                .font(.system(size:15))
                .offset(y:50)
                
                HStack(spacing: 75) {
                    Text("Date Worked")
                        .frame(width: 90, alignment: .leading)
                        .bold()
                    Text("Hours")
                        .frame(width: 90, alignment: .leading)
                        .bold()
                }
                .padding(.horizontal, 40)
                .foregroundColor(Color.black)
                .background(Color.white)
                .cornerRadius(8)
                .font(.system(size: 14))
                .offset(y:125)
                
                
                List(newDelTime) { dUser in
                    HStack(spacing: 85){
                        Text(dUser.workDate)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(dUser.hours))
                            .frame(width: 100, alignment: .leading)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        userStore.deleteRecord = dUser
                        deleteRecUser = dUser
                        print("tapped")
                        checkTapSuc = true
                    }
                    .foregroundColor(deleteRecUser?.id == dUser.id ? Color.white : Color.black)
                    .listRowBackground(deleteRecUser?.id == dUser.id ? Color.blue : Color.gray)
                }
                .padding(.horizontal, 10)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .offset(x: 0, y: 100)
            }
            
            else if(checkTapSuc == true)
            {
                if(!mistakeDelRec && !checkAfterDelRec)
                {
                    VStack(spacing: 30)
                    {
                        VStack(spacing: 20)
                        {
                            Text("Confirmation to delete \(String(format: "%.1f", deleteRecUser?.hours ?? 0)) hours from")
                            if let dateString = deleteRecUser?.workDate,
                               let date = Self.dateFormatter.date(from: dateString) {
                                Text(Self.dateFormatter.string(from: date))
                            } else {
                                Text("Invalid date")
                            }
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
                            Button {
                                print("Tapped!")
                                checkTapSuc = false
                                mistakeDelRec = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            Button {
                                print("Tapped!")
                                Task{
                                    await delTheRec()
                                }
                                checkAfterDelRec = true;
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
                
                else if(checkAfterDelRec == true)
                {
                    VStack(spacing: 20){
                        Text("\(String(format: "%.1f", deleteRecUser?.hours ?? 0)) hours is deleted for \(displayUserName) from...")
                        if let dateString = deleteRecUser?.workDate,
                           let date = Self.dateFormatter.date(from: dateString) {
                            Text(Self.dateFormatter.string(from: date))
                        } else {
                            Text("Invalid date")
                        }
                    }
                    .offset(y:75)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                }

            }
            Spacer()
        }
        .background(
            Image("bb6")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.60)
                )
        )
    }
    
    
    func delTheRec() async {
        let id = deleteRecUser?.id
        print(id)
        do{
            try await supabase
                .from("timesheet")
                .delete()
                .eq("timeid", value: id)
                .execute()
        }
        catch{
            print("Error deleting record: \(error)")
        }
    }
    
}
#Preview{
    FinalDelRecView()
}

/*
 try await supabase
 .from("timesheet")
 .delete()
 .eq("id", value: item.id)
 .execute()
 */
