import SwiftUI

struct AddUserView: View {
    @Environment(\.navigate) var navigate
    @State var enterFirst: String = ""
    @State var enterLast: String = ""
    @State var enterUser: String = ""
    @State var enterPass: String = ""
    @State var enterSuperUser: Bool = false
    @State var activeCheck: Bool = true
    @State private var showSuccess = false
    @EnvironmentObject var reportStore: ReportStore
    @State var users: [Users] = []
    @State var checkDuplicate: Bool = false
    @State var validateCheck: Bool = false
    @State var validationString: String = ""

    var body: some View {
        ZStack
        {
            Image("bb7")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.60)
                )
            VStack
            {
                Image("bb")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 40)
                
                if(checkDuplicate == false && showSuccess == false){
                    Text("Insert Information bellow to Add User!")
                        .foregroundColor(Color.white)
                        .offset(x: 0, y: 50)
                        .font(.custom("Georgia", size: 16))
                }
                
                Button("Home")
                {
                    navigate(.superUser)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: -150, y: -50)
                .font(.system(size: 16))
                
                // First name entry
                HStack(spacing: 12) {
                    Text("First Name:")
                        .frame(width: 110, alignment: .leading)
                        .foregroundColor(.black)
                    
                    TextField("Type here...", text: $enterFirst)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)

                }
                .padding(12)
                .frame(width: 300)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .cornerRadius(12)
                .shadow(radius: 1, y: 1)
                .offset(x: 0, y: 100)
                
                // Last name entry
                HStack(spacing: 12) {
                    Text("Last Name:")
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.black)
                    
                    TextField("Type here...", text: $enterLast)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                .padding(12)
                .frame(width: 300)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .cornerRadius(12)
                .shadow(radius: 1, y: 1)
                .offset(x: 0, y: 110)
                
                // Username entry
                HStack(spacing: 12) {
                    Text("Username:")
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.black)
                    
                    TextField("Type here...", text: $enterUser)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                .padding(12)
                .frame(width: 300)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .cornerRadius(12)
                .shadow(radius: 1, y: 1)
                .offset(x: 0, y: 120)
                
                // Password entry
                HStack(spacing: 12) {
                    Text("Password:")
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.black)
                    
                    SecureField("Type here...", text: $enterPass)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                .padding(12)
                .frame(width: 300)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .cornerRadius(12)
                .shadow(radius: 1, y: 1)
                .offset(x: 0, y: 130)
                
                // Is He/She a superUser?
                HStack(spacing: 12) {
                    Toggle("Is he/she an admin?", isOn: $enterSuperUser)
                        .foregroundColor(.black)
                }
                .padding(12)
                .frame(width: 300)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .cornerRadius(12)
                .shadow(radius: 1, y: 1)
                .offset(x: 0, y: 140)
                
                ZStack {
                    Button("ADD USER")
                    {
                        print("ADD USER button is pressed")
                        Task
                        {
                            validate()
                            if(validateCheck == true){
                                await addUser()
                            }
                            // else: no UI here; message is shown below via validationString
                        }
                    }
                    .opacity(showSuccess ? 0 : 1)
                    
                    Button("Add Another User?")
                    {
                        showSuccess = false
                    }
                    .opacity(showSuccess ? 1 : 0)
                }
                .frame(width: 240, height: 56)
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: 10, y: 240)
                
                if (showSuccess == true)
                {
                    Text("Insert Successful!")
                        .padding(.top, 8)
                        .foregroundColor(Color.white)
                        .offset(x: 0, y: 135)
                }
                
                if(checkDuplicate == true)
                {
                    Text("Username taken...Choose another username")
                        .foregroundColor(Color.white)
                        .font(.custom("Georgia", size: 16))
                        .padding(.top, -350)
                }
                
                if !validationString.isEmpty && !showSuccess {
                    Text(validationString)
                        .foregroundColor(.white)
                        .font(.custom("Georgia", size: 16))
                        .padding(.top, -330)
                }
                
                Spacer()
            }
        }
        .background(
            
        )
    }
    
    //calling funcition in a view, means you have to make it async, in which you need Task{} to call it
    private func validate() {
        if(enterFirst.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || enterPass.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || enterUser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || enterLast.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        {
            validationString = "Invalid Input, check to see if all fields are filled in"
            validateCheck = false
        }
        else {
            validationString = "" // clear any previous message
            validateCheck = true
        }
    }
    func addUser() async {
        let newUser = Users(
            id: nil,
            firstName: enterFirst,
            lastName: enterLast,
            userName: enterUser,
            passWord: enterPass,
            superUser: enterSuperUser,
            isActive: activeCheck
        )
        do {
            let users = try await supabase
                .from("Users")
                .insert(newUser)
                .execute()
            print("Insert Successful!")
            print(newUser.firstName)
            print(newUser.lastName)
            print(newUser.userName)
            print(newUser.passWord)
            print(newUser.superUser)
            // Clear fields after successful insertion
            enterFirst = ""
            enterLast = ""
            enterUser = ""
            enterPass = ""
            checkDuplicate = false
            enterSuperUser = false
            activeCheck = true
            showSuccess = true
            validationString = ""

        } catch {
            print("Error loading data: \(error)")
            checkDuplicate = true
            showSuccess = false
        }
    }
}
#Preview{
    AddUserView()
}


