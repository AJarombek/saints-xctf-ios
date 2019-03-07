### Overview

Code for the main SaintsXCTF iOS application.  There are two main types of code:

- Storyboard/Xib UI Code
- Swift Business Code

The Storyboard/Xib code is XML that controls what the UI looks like for an application user.  The XML isn't modified
directly, instead configured through a user interface in XCode.  The Swift code is written by hand and contains the
business logic for the application.  It also contains controllers for each view, determining what occurs when users
interact with the UI.

### Project Layout

From GitHub, it appears that each application file exists in the SaintsXCTF directory.  In reality when viewed from
XCode, these files are separated into groups.  Each group designates a component of the application.  There are some files that
sit in the root directory of the application, and then there are two main subgroups.  The first subgroup is API Client, and the second
subgroup is App.

### Root Group

The files that sit in the root directory relate to configuration, lifecycles, and assets for the entire application.

| Filename                              | Description                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------|
| `Assets.xcassets/`                    | All the assets (images) for the application.                                         |
| `Base.lproj/LaunchScreen.storyboard`  | The UI displayed when the application launches.                                      |
| `Base.lproj/Main.storyboard`          | The UI for all the views in the application.                                         |
| `SortView.xib`                        | UI for a SortView, which sorts exercise types.  `.xib` files create a UI component.  |
| `Info.plist`                          | Provides key->value properties for the application.                                  |
| `AppDelegate.swift`                   | Provides lifecycle hooks for the application.                                        |

### API Client Group

API Client is the first of the two main groups.  It contains code for communicating with the SaintsXCTF REST API,
which lives on a web server.  This is how the mobile application gets persistent data from the database.

**APIClient**

`APIRequest` communicates with the REST API.  `APIClient` makes API communication easier for the entire application.

| Filename             | Description                                                                          |
|----------------------|--------------------------------------------------------------------------------------|
| `APIClient.swift`    | Provides methods to call each REST API endpoint.                                     |
| `APIRequest.swift`   | Provides a low-level helper methods for creating HTTP requests for a given Verb.     |

**APIClient.Models**

Data models can be converted to and from JSON for use in REST API calls and throughout the application.

| Filename                 | Description                                                            |
|--------------------------|------------------------------------------------------------------------|
| `User.swift`             | Data model for an application user.                                    |
| `Log.swift`              | Data model for an exercise log.                                        |
| `Group.swift`            | Data model for a group (St. Lawrence team).                            |
| `Comment.swift`          | Data model for a comment on an exercise log.                           |
| `Message.swift`          | Data model for a group message.                                        |
| `Notification.swift`     | Data model for a user notification.                                    |
| `RangeView.swift`        | Data model for a view of activity over a period of time.               |
| `LeaderboardItem.swift`  | Data model for an entry in a leaderboard.                              |
| `Credentials.swift`      | Data model for API credentials.                                        |
| `ActivationCode.swift`   | Data model for a users activation code to the application.             |
| `GroupMember.swift`      | Data model for a member of a group (team).                             |
| `GroupInfo.swift`        | Data model for information about a group.                              |
| `Mail.swift`             | Data model representing an email.                                      |

### App Group

App is the second of the two main groups.  It contains code that helps control the business logic behind the UI.

**App**

Contains controllers for views used before a user is signed in.  Also has pieces of functionality used throughout the
application.

| Filename                         | Description                                                               |
|----------------------------------|---------------------------------------------------------------------------|
| `HomeViewController.swift`       | Controller for the view displayed before a user is signed in.             |
| `SignUpViewController.swift`     | Controller for the view containing a form to sign up.                     |
| `SignOutViewController.swift`    | Controller for the view allowing a user to sign out.                      |
| `PickGroupViewController.swift`  | Controller for the view where users pick groups to join.                  |
| `SignedInUser.swift`             | Helper methods to save and retrieve a signed in user from the filesystem. |
| `StartViewController.swift`      | Controller for the view displayed as the app loads.                       |
| `Utils.swift`                    | Utility functions used throughout the application.                        |
| `LoadingView.swift`              | Storyboard view which displays a loading spinner.                         |

**App.Group**

Swift code used throughout the Group pages of the application.

| Filename                          | Description                                                               |
|-----------------------------------|---------------------------------------------------------------------------|
| `GroupListViewController.swift`   | Controller for the view displaying all the groups in the app.             |
| `GroupViewController.swift`       | Controller for the view displaying a specific groups information.         |
| `LeaderboardViewController.swift` | Controller for the view showing the groups exercise leaderboard.          |
| `LeaderboardTableViewCell.swift`  | Controller for a cell in the groups exercise leaderboard.                 |
| `SortView.swift`                  | A view with filters for different exercise types.                         |
| `MessageViewController.swift`     | Controller for the view displaying private group messages.                |
| `MessageTableViewCell.swift`      | Controller for a cell in the groups messages.                             |
| `NewMessageTableViewCell.swift`   | Controller for a cell allowing the creation of a new group message.       |
| `MemberViewController.swift`      | Controller for the view displaying group members.                         |
| `MemberTableViewCell.swift`       | Controller for a cell in the group member list.                           |
| `AdminViewController.swift`       | Controller for the view providing administrative functions.               |

**App.Profile**

Swift code used throughout the Profile pages of the application.

| Filename                          | Description                                                               |
|-----------------------------------|---------------------------------------------------------------------------|
| `ProfileViewController.swift`     | Controller for viewing a users profile.                                   |
| `EditProfileViewController.swift` | Controller for providing a user options to edit their profile.            |
| `DetailsViewController.swift`     | Controller allowing users to edit their profile details.                  |
| `ProPicViewController.swift`      | Controller allowing users to change their profile picture.                |
| `MonthlyViewController.swift`     | Controller for the view displaying a monthly calendar of workouts.        |
| `WeeklyViewController.swift`      | Controller for the view displaying a weekly graph of workouts.            |
| `BarChartFormatter.swift`         | Extension of the BarChartView class which draws a bar chart.              |
| `ReportViewController.swift`      | Controller allowing users to report issues to the application admin.      |

**App.Log**

Swift code used for creating and updating exercise logs.

| Filename                          | Description                                                               |
|-----------------------------------|---------------------------------------------------------------------------|
| `LogViewController.swift`         | Controller for the form used to create/update exercise logs.              |

**App.Comment**

Swift code used for commenting functionality on exercise logs.

| Filename                          | Description                                                               |
|-----------------------------------|---------------------------------------------------------------------------|
| `NewCommentTableViewCell.swift`   | Cell for writing a comment on a users exercise log.                       |
| `CommentViewController.swift`     | Controller for the comments on a users exercise log.                      |
| `CommentTableViewCell.swift`      | Cell for a single comment in a table view.                                |

**App.Constants**

Constants used in Swift code throughout the application.

| Filename                          | Description                                                               |
|-----------------------------------|---------------------------------------------------------------------------|
| `Constants.swift`                 | Swift constant arrays and functions to retrieve items from these arrays.  |

**App.Main**

Swift code for the main page of the application.  The main page is displayed as soon as the user logs in, and showcases
all the latest exercise logs.

| Filename                          | Description                                                               |
|-----------------------------------|---------------------------------------------------------------------------|
| `LogDataSource.swift`             | An array of LogData objects which are displayed on the main page.         |
| `MainViewController.swift`        | Controller for displaying an infinite scroll of exercise logs.            |
| `LogTableViewCell.swift`          | Cell displaying a single exercise log.                                    |
| `LogData.swift`                   | Model representing the data shown in an exercise log.                     |

**App.Extensions**

Extensions for existing classes and structs in the Swift standard library and third party tools.

| Filename                    | Description                                                               |
|-----------------------------|---------------------------------------------------------------------------|
| `UITextFieldExt.swift`      | Extension for the UITextField class from UIKit.                           |
| `UIColorExt.swift`          | Extension for constructing the UIColor class from UIKit.                  |
| `UITableExt.swift`          | Extension for the UITable class from UIKit.                               |
| `UIToolbarExt.swift`        | Extension for the UIToolbar class from UIKit.                             |
| `StringExt.swift`           | Extension for the standard library String struct.                         |
| `TextViewExt.swift`         | Extension for the UITextView class from UIKit.                            |
