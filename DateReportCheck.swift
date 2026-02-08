//
//  DateReportCheck.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 9/19/25.
//

import SwiftUI

struct DateReportCheck: View{
    @Environment(\.navigate) var navigate
    @State var selectStartDate: Date = .now
    @State var selectEndDate: Date = .now
    @State var users: [Users] = []
    @State var timeUsers: [timesheet] = []
    @State var totalHours: Double = 0.0;
    @State var showResult: Bool = false
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reportStore: ReportStore
    @EnvironmentObject var theHoursStore: hoursStore
    @EnvironmentObject var entryStore: hoursStore
    @State var timeEntries: [fetchUserEntries] = []
    @State var singleEntries: [SingleUserEntry] = []

    
    var body: some View{
        VStack{
            Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 40)
                .offset(x: 0, y: 30)
            
            Button("Home")
            {
                navigate(.superUser)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue)
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(x: -150, y: -60)
            .font(.system(size: 16))
            

            
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
            
            HStack{
                DatePicker("Select End Date", selection: $selectEndDate, displayedComponents: .date)
            }
            .padding(12)
            .frame(width:300)
            .background(Color.white)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.15), lineWidth:1)
            )
            .cornerRadius(12)
            .offset(y:175)
            
            
            Button("View Report") {
                print("View Report button is pressed")
                theHoursStore.startDate = selectStartDate;  //save the start date to our hoursStore class
                theHoursStore.endDate = selectEndDate; //save end date to hours store class
                
                //edit conditional here under task, if the parent user is admin, then use fetchuserentry otherwise if not admin then we make another function in which we call the function directly with the userid
                Task{
                    if(userStore.parentUser?.superUser == true)
                    {
                        await fetchUserEntries()
                        navigate(.finalDateView)
                    }
                    else
                    {
                        userStore.fetchSingleUser = userStore.parentUser
                        await normalUserEntry()
                        navigate(.singleUserDisplay)
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .background(Color.blue)
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(x: 10, y: 250)
            

            
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
    func normalUserEntry() async{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        struct normalEntryParams: Codable{
            let start_date: String
            let end_date: String
            let user_id: Int?
        }
        
        guard let userid = userStore.parentUser?.id else {
            print("User ID is nil for user:")
            return;
        }
        //guard check checks for userid if it exists otherwise throws print error
        
        do {
            let params = normalEntryParams(
                start_date: dateFormatter.string(from: entryStore.startDate),
                end_date: dateFormatter.string(from: entryStore.endDate),
                user_id: userid
            )
        //params that go into the rpc call
        //then store the results from the database call into array singleEntries
            singleEntries = try await supabase.rpc(
                "oneuserentry",
                params: params
            ).execute().value
            
            entryStore.singleEntries = singleEntries
            print("Successfully fetched \(singleEntries.count) entries")

        }
        catch {
            print("Error: \(error)")
            singleEntries = []
        }
        
        
    }
    
    func fetchUserEntries() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"     //date formatter for same valuer as supabase
        
        do {
            let params = [
                "start_date": dateFormatter.string(from: theHoursStore.startDate),
                "end_date": dateFormatter.string(from: theHoursStore.endDate)
            ]
            
            // Direct assignment - this WOULD work
            timeEntries = try await supabase.rpc(            //supabase function call means rpc()
                "allentries",
                params: params
            ).execute().value
            
            entryStore.timeEntries = timeEntries        //save our timeEntries array we just fetched from our supabase call to our hourStore class

            print("Successfully fetched \(timeEntries.count) entries")
            
        } catch {
            print("Error: \(error)")
            timeEntries = []
        }
    }

}
    //Swift's automatic JSON decoder is TOO STRICT
    //It only understands proper JSON objects with field names
    //It chokes on simple values like raw numbers, strings, or booleans

#Preview{
    DateReportCheck()
}

//.eq() - equal to

// .neq() - not equal to

//.gt() - greater than

//.gte() - greater than or equal to

//.lt() - less than

//.lte() - less than or equal to

//.between() - between two values

//.range() - range of rows
