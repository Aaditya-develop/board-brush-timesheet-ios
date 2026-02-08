import SwiftUI

struct SuperUserView: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reportStore: ReportStore
    @EnvironmentObject var parentStore: UserStore


    
    var body: some View {
        VStack {
                 Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 90)
                .offset(y: 150)
            
            //?? is to unwrap the optional command from the User object so that "optional" is not seen
            //Text("Hello \(userStore.currentUser?.firstName ?? "there") What would you like to do?")
            //    .foregroundColor(.white)
             //   .offset(x: 10, y:100)
            Text("Hello \(userStore.parentUser?.firstName ?? "")!")
                .padding(.horizontal,40)
                .padding(.vertical, 8)
                .foregroundColor(.black)
                .font(.custom("Georgia", size: 16))
                .background(Color.white)
                .cornerRadius(8)
                .offset(y: 170)
            
            Menu
            {
                Button("Login Screen"){
                    navigate(.login)
                }
                Menu("Change Password"){
                    Button("Change Password"){
                        navigate(.passReset)
                    }
                    Button("Change Employee Password"){
                        navigate(.employeePassReset)
                    }
                }
                Button("Add a User"){
                    navigate(.addUser)
                }
                Button("Delete a User"){
                    navigate(.deleteUser)
                }
                Button("Record hours"){
                    navigate(.superTimeView)
                }
                Button("Delete a Timesheet"){
                    navigate(.deleteTime)
                }
                Button("Time Report"){
                    navigate(.dateReportCheck)
                }
            } label: {
                Text("Menu")
                    .padding(.horizontal, 50)
                    .padding(.vertical, 5)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .font(.custom("Georgia", size: 16))
                    .cornerRadius(8)
                    .contentShape(Rectangle())
            }
            .offset(x: 0, y: 180)
            
            
                        
            
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
}
#Preview{
    SuperUserView()
}
