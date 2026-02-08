import SwiftUI

struct SuperTimeView: View {
    @Environment(\.navigate) var navigate
    @State var users: [Users] = []
    @State var enterTheUser: String = ""
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reportStore: ReportStore
    @State private var selectedUser: Users? = nil
    @EnvironmentObject var parentStore: UserStore

    
    var body: some View {
        ZStack { // Use ZStack instead of VStack for background
            // Background first - applies to entire screen
            Image("bb10")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.70)
                )
            // Content on top
            VStack {
                Button("Home"){
                    navigate(.superUser)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: -150, y: -15)
                .font(.system(size: 16))
                
                Image("bb")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 40)
                    .offset(x: 0, y: -20)

            
                Text("Select and Enter the User you want to record time for")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center) // Better text wrapping
                    .padding(.horizontal)
                    .font(.custom("Georgia", size: 16))
                
                Spacer()

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
                
                List(users){ user in
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
                            selectedUser = user
                            enterTheUser = user.userName
                            validate()
                        }
                        .foregroundColor(selectedUser?.id == user.id ? Color.white : Color.black)
                        .listRowBackground(selectedUser?.id == user.id ? Color.blue : Color.gray)
                   // }
                }
               // .listStyle(PlainListStyle()) // Remove default list styling
                .scrollContentBackground(.hidden) // Hide default background
                .background(Color.clear) // Transparent background
                .offset(x: 0, y: 50)
                
            }
            .padding()
        }
        //we need.task here since we are aking the call inside the view itself.
        .task {
            do {
                users = try await supabase
                    .from("Users")
                    .select()
                    .eq("isActive",value: true)
                    .order("firstName", ascending: true)
                    .execute()
                    .value
            } catch {
                dump(error)
            }
        }

    }

    private func validate(){
        if !(enterTheUser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            enterUser()
            navigate(.recordTime)
        }

    }
    func enterUser(){
        for currUser in users{
            if(currUser.userName.lowercased() == enterTheUser.lowercased()){
                userStore.currentUser = currUser;
            }
        }
    }
}


#Preview {
    SuperTimeView()
}

/*
//supabase
.from("table")      // 1. Specify table
.select()           // 2. Choose columns
.order()            // 3. Add ordering
.eq() / .filter()   // 4. Add filters
.execute()          // 5. FINALLY execute the built query
*/
