import SwiftUI

struct LoginView: View {
    @State var names: [Users] = []
    @State var pword: String = ""
    @State var uname: String = ""
    @State private var message: String = "Button tapped!"
    @EnvironmentObject var reportStore: ReportStore
    @State var showSucess = false;
    @Environment(\.navigate) var navigate
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var parentStore: UserStore
    @State var showPassword: Bool = false
    @State var checkLogin: Bool = false
    @State var checkActive: Bool = false
    @State var loginSuc: Bool = false
    
    var body: some View {
        VStack {
            Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 40)
            
            //username
            HStack(spacing: 12) {
                Text("Username:")
                    .frame(width: 100, alignment: .leading)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                
                TextField("Type here", text: $uname)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)

            }
            .padding(12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
            .cornerRadius(12)
            .shadow(radius: 1, y: 1)
            .offset(x: 0, y: 250)
            
            //password
            
            HStack(spacing: 12) {
                Text("Password:")
                    .frame(width: 100, alignment: .leading)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                if(showPassword){
                    SecureField("Type here", text: $pword)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                }
                else{
                    TextField("Type here", text: $pword)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Password")
                        .onSubmit{
                            validate()
                        }
                }
            }
            .padding(12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
                //.frame(width: 100, height: 50) // Adjust width and/or height
            )
            .cornerRadius(12)
            .shadow(radius: 1, y: 1)
            .offset(x: 0, y: 250)
            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.red)
            }
            .offset(x: 150, y: 220)
            
            
            if(checkLogin == false){
                Button("LOGIN") {
                    print("Button Tapped!")
                    checkUser()
                    checkLogin = true;
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .font(.custom("Georgia", size: 16))
                .offset(x: 0, y: 300)
            }
            else if(checkLogin && loginSuc){
                Text("Succesfully Logged In")
                    .foregroundColor(Color.white)
                    .offset(y: 300)
                    .font(.custom("Georgia", size: 16))
            }
            else if(checkActive){
                Text("User not Active in Database")
                    .foregroundColor(Color.white)
                    .offset(y: 300)
                    .font(.custom("Georgia", size: 16))
            }
            else {
                Text("Incorrect Username or Password")
                    .foregroundColor(Color.white)
                    .offset(y: 300)
                    .font(.custom("Georgia", size: 16))
            }
            
            if(showSucess)
            {
                Menu("Menu")
                {
                    if((parentStore.parentUser?.superUser) != false)
                    {
                        Button("Add a User")
                        {
                            navigate(.addUser)
                        }
                        Button("Delete a User")
                        {
                            navigate(.deleteUser)
                        }
                        Button("Record hours")
                        {
                            navigate(.superTimeView)
                        }
                        Button("Delete a Record")
                        {
                            navigate(.deleteTime)
                        }
                        Button("Time Report")
                        {
                            navigate(.dateReportCheck)
                        }
                    }
                    else
                    {
                        Button("Record hours")
                        {
                            navigate(.recordTime)
                        }
                        Button("Report")
                        {
                            navigate(.dateReportCheck)
                        }
                    }
                    
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: -150, y: -225)
                .font(.system(size: 16))
            }
            
            
            Spacer()
        }
        .padding()
        
        .background(
            Image("bbphoto3")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.60)
                )
        )
        
        //we use this SQL + SwiftUI combination to store the rows of tthe Users table in a "names" array. For example one row would be names[0], row 2 would be names[1]
        .task {
            do {
                names = try await supabase
                    .from("Users")
                    .select()
                    .execute()
                    .value
            } catch {
                print("Error loading data: \(error)")
            }
        }
    }

    
    //names is the array of the database we made above
    //We are iterating through it, finding a match for our desired log in
    //the currentUser is an updating value of type userStore in which we can now save the current user for other views
    //whehn we find our user, we navigate to the next screen.
    //We set foundUser to the info which gives us the desired User, which we use in the statements preceeding that.
    private func validate(){
        if(uname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && pword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            Text("Error")
        }
        else{
            checkUser()
            checkLogin = true;
        }
    }
    func checkUser() {
        print("here???")
        var foundUser: Users?
        var isLoggedIn: Bool = false
        for info in names {
            if info.userName.lowercased() == uname.lowercased() && info.passWord.lowercased() == pword.lowercased() {
                if (info.isActive) {
                    if info.superUser {
                        parentStore.parentUser = info
                        foundUser = info
                        isLoggedIn = true
                        showSucess = true;
                        loginSuc = true;
                        navigate(.superUser)
                        break
                    } else {
                        foundUser = info
                        parentStore.parentUser = info
                        isLoggedIn = true
                        showSucess = true;
                        loginSuc = true;
                        navigate(.normalUser)
                        break
                    }
                }
                else
                {
                    print("Not active in the database")
                    checkActive = true
                }
            }
        }
        //We have to use let to declare something as soemthing. Otherwise we can not use "foundUser" SwiftUI does not know what it means when you dont use "let"
        //basically use let to set it to some variable so that you can compare it
        if isLoggedIn, let user = foundUser {
            print("Access Granted: \(user.firstName) is found")
            print(parentStore.parentUser?.id)
            //print(userStore.currentUser?.firstName)
        } else {
            print("Access Denied: User not found")
        }
    }
}
//This gives the view 
#Preview {
    LoginView()
}


