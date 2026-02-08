//
//  ContentView.swift
//  SpBaseHelloWorld
//
//  Created by Aaditya Chandola on 8/6/25.
//

import SwiftUI

//central control block, this is used for ALL of our screens. When we hit navigate on any file, we come back here and the switch logic picks the desired output.
enum Screen {
    case login
    case passReset
    case employeePassReset
    case superUser
    case normalUser
    case addUser
    case deleteUser
    case recordTime
    case superTimeView
    case deleteTime
    case finDeleteTime
    case reportTimeView
    case dateReportCheck
    case finalDateView
    case singleUserDisplay
}

struct ContentView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reportStore: ReportStore
    @EnvironmentObject var theHoursStore: hoursStore
    @EnvironmentObject var parentStore: UserStore
    @EnvironmentObject var fetchSingleStore: UserStore
    @State private var screen: Screen = .login

    init() {
        #if DEBUG
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-uiTestStartAtAddUser") {
            _screen = State(initialValue: .addUser)
        } else if args.contains("-uiTestStartAtSuperUser") {
            _screen = State(initialValue: .superUser)
        } else if args.contains("-uiTestStartAtNormalUser") {
            _screen = State(initialValue: .normalUser)
        } else if args.contains("-uiTestStartAtDateReport") {
            _screen = State(initialValue: .dateReportCheck)
        } else if args.contains("-uiTestStartAtDeleteRecord") {
            _screen = State(initialValue: .deleteTime)
        } else if args.contains("-uiTestStartAtLogin") {
            _screen = State(initialValue: .login)
        }
        #endif
    }
    
    var body: some View {
        Group {
            switch screen {
            case .login:
                LoginView()
            case .passReset:
                PassResetView()
            case .employeePassReset:
                EmployeePassChange()
            case .superUser:
                SuperUserView()
            case .normalUser:
                NormalUserView()
            case .addUser:
                AddUserView()
            case .deleteUser:
                DeleteUserView()
            case .recordTime:
                RecordTimeView()
            case .superTimeView:
                SuperTimeView()
            case .deleteTime:
                DeleteRecordView()
            case .finDeleteTime:
                FinalDelRecView()
            case .reportTimeView:
                TimeReportView()
            case .dateReportCheck:
                DateReportCheck()
            case .finalDateView:
                FinalDateView()
            case .singleUserDisplay:
                singleUserDisplay()
            }

        }
        .environment(\.navigate) { newScreen in
            screen = newScreen
        //ContentView says: "Anyone who needs to navigate, use this function - it will update my screen state!"

        }
    }
}


struct NavigationKey: EnvironmentKey {
    static let defaultValue: (Screen) -> Void = { _ in }
}

extension EnvironmentValues {
    var navigate: (Screen) -> Void {
        get { self[NavigationKey.self] }
        set { self[NavigationKey.self] = newValue }
    }
}

#Preview {
    ContentView()
}
