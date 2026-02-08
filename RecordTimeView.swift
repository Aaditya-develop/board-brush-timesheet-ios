import SwiftUI

struct RecordTimeView: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reportStore: ReportStore
    @EnvironmentObject var theHoursStore: hoursStore
    @State var userId: Int = 0
    @State var timeSheetUsers: [timesheet] = []
    @State var finalStartTime: String = ""
    @State var finalEndTime: String = ""
    @State var startTimeDec: Double = 0.0
    @State var endTimeDec: Double = 0.0
    @State var enterHours: Double = 0.0
    @State var startTime: Date = .now       //save this globally (report)
    @State var endTime: Date = .now         //save this globally (report)
    @State var selectedDate: Date = .now
    @State private var recordedAt: Date = .now
    @State private var showSuccess = false
    @State var checkDone: Bool = false

//WE ARE TRACKING PARENT STORE -> NEED TO CHECK WHAT TO DO WHEN DONE ENTERING HOURS
//After parent user is done what do we want them to do or see? record someone else? home page? another record?
    
    var body: some View {
        VStack {
            Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 40)
            
            Button("Home") {
                
                let _ = print(" hey SuperUser value: \(userStore.parentUser?.superUser ?? false)")
                
                if userStore.parentUser?.superUser == true
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
            
            Text("Insert Information bellow to Record Time!")
                .foregroundColor(Color.white)
                .offset(x: 0, y: 50)
            
            
            //Enter the date for which you are putting the hours
            HStack(spacing: 12) {
                DatePicker("Start Time (24 Hour)", selection: $startTime, displayedComponents: .hourAndMinute)
            }
            .environment(\.locale, Locale(identifier: "en_GB")) // Forces 24-hour format
            .padding(12)
            .frame(width: 300)
            .foregroundColor(.black)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
            .cornerRadius(12)
            .shadow(radius: 1, y: 1)
            .offset(x: 0, y: 130)
            
            HStack(spacing: 12) {
                DatePicker("End Time (24 Hour)", selection: $endTime, displayedComponents: .hourAndMinute)
            }
            .environment(\.locale, Locale(identifier: "en_GB")) // Forces 24-hour format
            .padding(12)
            .frame(width: 300)
            .foregroundColor(.black)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
            .cornerRadius(12)
            .shadow(radius: 1, y: 1)
            .offset(x: 0, y: 130)
            
            //Exact time you recorded
            HStack(spacing: 12) {
                DatePicker("Select a Date", selection: $selectedDate, displayedComponents: .date)
            }
            .padding(12)
            .frame(width: 300)
            .foregroundColor(.black)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
            .cornerRadius(12)
            .shadow(radius: 1, y: 1)
            .offset(x: 0, y: 130)
            
            
            if (checkDone == false) {
                Button("Click to record time") {
                    print("Record Time button is pressed")
                    Task {
                        checkDone = true
                        await recordTime()
                    }
                }
                .font(.system(size: 16, weight: .regular))          // ensure same font
                .frame(width: 280, height: 56)                      // fixed size
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: 10, y: 250)
            }
            
            if (showSuccess == true)
            {
                Text("Successful!")
                    .padding()
                    .offset(x: 10, y: 175)
                    .foregroundColor(Color.white)
                
                Button("Insert Another Record?") {
                    checkDone = false
                    showSuccess = false
                }
                .font(.system(size: 16, weight: .regular))          // same font
                .frame(width: 280, height: 56)                      // same fixed size
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
                .offset(x: 10, y: 190)                              // same position
            }
            
            Spacer()
        }
        
        .background(
            Image("bb8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.70)
                )
        )
    }
    //remember outside of view, means async call
    
    func dateToDecimal(from date: Date) -> Double  {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        return Double(hour) + Double(minutes) / 60.0
    }
    
    func convertDateToTime(from date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"  // Only time, no date!
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    func recordTime() async {
        
        //declare new timesheet object of the variables types we just made user input.
        startTimeDec = dateToDecimal(from: startTime)
        endTimeDec = dateToDecimal(from: endTime)
        
        finalStartTime = convertDateToTime(from: startTime)
        finalEndTime = convertDateToTime(from: endTime)

        let hoursConversion = endTimeDec - startTimeDec
        let hoursTruncated = floor(hoursConversion * 10) / 10
        
        guard let validId = userStore.currentUser?.id ?? userStore.parentUser?.id
        else
        {
            print("Cannot insert timesheet: no valid user id")
            checkDone = false
            return
        }

        userId = validId
        
        let newTime = timesheet(
            id: nil,
            hours: hoursTruncated,
            workdate: selectedDate,
            recordedat: recordedAt,
            userid: userId,
            starttimedecimal: startTimeDec,
            endtimedecimal: endTimeDec,
            starttime: finalStartTime,
            endtime: finalEndTime
        )
        print(newTime.id);
        print(newTime.hours)
        print(newTime.workdate)
        print(newTime.recordedat)
        print(newTime.userid)
        showSuccess = true;
    
        do {
            timeSheetUsers = try await supabase
                .from("timesheet")
                .insert(newTime)
                .execute()
                .value
            print("Insert Successful!")
        } catch {
            print("Error loading data: \(error)")
        }
    }
    
}
#Preview {
    RecordTimeView()
}
