import SwiftUI

struct FinalDateView: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var reportStore: ReportStore
    @EnvironmentObject var theHoursStore: hoursStore
    @EnvironmentObject var entryStore: hoursStore
    @EnvironmentObject var userStore: UserStore
    @State var timeEntries: [fetchUserEntries] = []
    @State var singleEntries: [SingleUserEntry] = []
    @State private var selectedUser: Users? = nil
    @State var tapped: Bool = false //used to change row color on tap
    @State var checkSuperForSingleUser: Bool = false
    
    
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
                .offset(x: 0, y: 15)
            
            
            Button("Home")
            {
                navigate(.superUser)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue)
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(x: -150, y: -35)
            
            if(userStore.parentUser?.superUser == true)
            {
                Button("Back")
                {
                    navigate(.dateReportCheck)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: 150, y: -70)
                .font(.system(size: 16))
            }

            
            let firstDate = entryStore.startDate
            let endDate = entryStore.endDate
            
            HStack{
                Text(Self.dateFormatter.string(from: firstDate))
                Text("-")
                Text(Self.dateFormatter.string(from: endDate))
            }
            .background(Color.white)
            .bold()
            .foregroundColor(.black)
            .cornerRadius(8)
            .offset(x: 0, y: 25)
            
            
            HStack {
                Text("First name")
                    .frame(width: 110, alignment: .leading)
                    .bold()
                Text("Last name")
                    .frame(width: 110, alignment: .leading)
                    .bold()
                Text("Hours")
                    .frame(width: 110, alignment: .leading)
                    .bold()
            }
            .padding(.horizontal, 10)
            .background(.white)
            .foregroundColor(.black)
            .cornerRadius(8)
            .padding(.horizontal)
            .offset(y: 40)
            //use let to save value of class hoursStore into a current var
                let currentEntryStore = entryStore.timeEntries
                List(currentEntryStore) { entry in
                    HStack {
                        Text("\(entry.firstname)")
                            .frame(width: 100, alignment: .leading)
                        Text("\(entry.lastname)")
                            .frame(width: 100, alignment: .leading)
                        Text("\(entry.total_hours, specifier: "%.2f")")
                            .frame(width: 100, alignment: .leading)
                    }
                    //this is used to make it that we can click anywhere on the row and it will take us
                    .contentShape(Rectangle())
                    //on the tap of the row, what do we want to do?
                    .onTapGesture {
                        tapped = true
                        Task {
                            await allUsers()
                            
                            let allTheUsers = totUsers
                            if(allTheUsers.count == 0){
                                print("true")
                            }
                            for User in allTheUsers{
                                if(entry.username == User.userName){
                                    selectedUser = User
                                    userStore.fetchSingleUser = User
                                    print("reached")
                                    break
                                }
                            }
                            await fetchSingleUserEntry()
                            navigate(.singleUserDisplay)
                        }
                    }
                    .foregroundColor(selectedUser?.userName == entry.username ? Color.white : Color.black)
                    .listRowBackground(selectedUser?.userName == entry.username ? Color.blue : Color.white)
                }
                .scrollContentBackground(.hidden) // Hide default background
                .background(Color.clear)

            
            Spacer()
            
        }
            .background(
                Image("bb14")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                        Color.black.opacity(0.70)
                    )
            )
        
    }
    private func fetchSingleUserEntry() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        struct EntryParams: Codable {
            let start_date: String
            let end_date: String
            let user_id: Int?
        }
        
        guard let userId = userStore.fetchSingleUser?.id else {
               print("User ID is nil for user:")
               return
           }
        
        do {
            let params = EntryParams(
                start_date: dateFormatter.string(from: entryStore.startDate),
                end_date: dateFormatter.string(from: entryStore.endDate),
                user_id: userId
            )
            
            singleEntries = try await supabase.rpc(
                "oneuserentry",
                params: params
            ).execute().value
            
            entryStore.singleEntries = singleEntries
            print("Successfully fetched \(singleEntries.count) entries")

            
        } catch {
            print("Error: \(error)")
            singleEntries = []
        }
    }
    

}

#Preview {
    FinalDateView()
}
