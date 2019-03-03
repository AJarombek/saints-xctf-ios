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
