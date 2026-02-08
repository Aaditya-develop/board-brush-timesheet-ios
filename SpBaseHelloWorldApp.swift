import SwiftUI

// Parameters for RPC (Remote Procedure Call) function - matches database function signature
struct TotalHoursParams: Encodable {
    let start_date: String
    let end_date: String
    let user_id: Int
}

// MAIN APP FILE - Root structure where global state is managed
@main
struct SpBaseHelloWorldApp: App {
    // The apps global state containers
    // @StateObject creates and owns the object, @EnvironmentObject shares it with views
    @StateObject private var parentStore = UserStore()      // Stores current logged-in user
    @StateObject private var userStore = UserStore()        // For user management
    @StateObject private var reportStore = ReportStore()    // For report-related state
    @StateObject private var theHoursStore = hoursStore()   // For time tracking state
    @StateObject private var fetchSingleStore = UserStore()
    
    var body: some Scene {
        //window group holds main app interface
        WindowGroup {
            ContentView()
                // ENVIRONMENT OBJECT INJECTION: Makes these stores available to all child views of this main which is the top 
                .environmentObject(userStore)
                .environmentObject(reportStore)
                .environmentObject(theHoursStore)
                .environmentObject(fetchSingleStore)
        }
    }
}
/*Things to add
    -User should be able to see their own timesheet    DONE
    -User/Admin should be able to reset password or change it if they wish      DONE
    -Admin should be able to delete a record -> ask user in person to re do it.  DONE
    -Admin should be able to delete a user. "flag"      DONE
 */

/*
 two entries for time clocked in and time clocked out. The time clocked in and out will both be a time and it will calculate the hours from the two. 
 */


/* SQL QUERY EXAMPLES FOR REFERENCE:
// Join tables to get timesheet data with user info
SELECT t.*, u.*
FROM timesheet AS t
JOIN "Users" u ON t.userid = u.id

// Get specific user by ID
SELECT "firstName" from "Users" WHERE "id" = 1
*/
