# saints-xctf-ios

### Overview

An iOS app that goes along with my website `saintsxctf.com`.  All development is done in Swift.  
The backend calls a REST API written in Python.

There is also an Android app that was released August 2017.

You can follow development of the website here: [SaintsXCTF Website GitHub](https://github.com/AJarombek/saints-xctf-web).

You can follow development of the API here: [SaintsXCTF API GitHub](https://github.com/AJarombek/saints-xctf-api).

You can follow development of the android app here: [SaintsXCTF Android GitHub](https://github.com/AJarombek/saints-xctf-android).

### Releases

**V2.1.2 - Monthly Calendar Daylight Savings Fix**

> Release Date: Nov 26, 2022

Fixes an issue where the monthly calendar displays logs offest by one day during daylight savings.

**V2.1.1 - iOS 15 Update**

> Release Date: Dec 30, 2021

The update makes the app support iOS 15, removes the cancel button from the edit log page, fixes the time on the edit log page.

**V.2.1.0 - New Create & Edit Log Pages**

> Release Date: Dec 29, 2021

This update has newly designed create and edit log pages.  These pages are written using SwiftUI, replacing the old Storyboard/UIKit pages.  
Also included in this release is a bug fix for the monthly calendar skipping months while navigating.

**V.2.0.1 - Calendar & Monthly Chart Fixes**

> Release Date: Jun 21, 2021

This update fixes an issue with the monthly calendar and weekly chart.  Days were offset by one in both views, due in part to differences 
in the new API.

**V.2.0.0 - Version 2 Release**

> Release Date: Jun 1, 2021

This version of the iOS app aligns with the second version of the web application and API.  While no new features were added to the iOS app,
 aligning it with the new web application and API enables quick updates going forward.

**V.1.1 - Safety Release**

> Release Date: Mar 5, 2019

The second major release for the SaintsXCTF iOS app.  Besides for bug fixes, this release introduced a EULA which is
presented to users as they sign up.  Another major feature was the report functionality, allowing users to contact the
site administrator about application problems / questionable user content.  Both of these features were added to conform
to Apple guidelines.

**V.1.0 - Official Release**

> Release Date: Oct 19, 2017

This was the first public release of the iOS app.

### Files

| Filename                  | Description                                                                                      |
|---------------------------|--------------------------------------------------------------------------------------------------|
| `SaintsXCTF.xcodeproj`    | Configuration for the XCode project.                                                             |
| `SaintsXCTF.xcworkspace`  | Configuration for the XCode workspace.                                                           |
| `SaintsXCTF`              | Contains code for the main SaintsXCTF application.                                               |
| `SaintsXCTFTests`         | Contains unit tests for the SaintsXCTF application.                                              |
| `Podfile`                 | Cocoapods dependencies for the application.  Written in Ruby.                                    |
| `pod.sh`                  | Important shell commands for working with Cocoapods.                                             |
