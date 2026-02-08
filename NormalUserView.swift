import SwiftUI

struct NormalUserView: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reportStore: ReportStore
    var body: some View {
        VStack {
            Image("bb")
               .resizable()
               .scaledToFill()
               .frame(width: 250, height: 90)
               .offset(y: 150)
            
            Text("Hello \(userStore.parentUser?.firstName ?? "")!")
                .padding(.horizontal,40)
                .padding(.vertical, 8)
                .foregroundColor(.black)
                .font(.custom("Georgia", size: 16))
                .background(Color.white)
                .cornerRadius(8)
                .offset(y: 170)
            
            Menu {
                Button("Log Out")
                {
                    navigate(.login)
                }
                Button("Record hours")
                {
                    navigate(.recordTime)
                }
                Button("Change Password")
                {
                    navigate(.passReset)
                }
                Button("Delete a Timesheet")
                {
                    navigate(.deleteTime)
                }
                Button("Report")
                {
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
    NormalUserView()
}
