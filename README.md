# saints-xctf-ios

## Overview

The SaintsXCTF iOS App goes along with my website SaintsXCTF.com.  All development is done in Swift.  
The backend calls the REST API built on the website server (Written in PHP).

There is also an Android app that was released August 2017.

You can follow development of the website here: [SaintsXCTF Website GitHub](https://github.com/AJarombek/saints-xctf).

You can follow development of the android app here: [SaintsXCTF Android GitHub](https://github.com/AJarombek/saints-xctf-android).

## Releases

**V.1.0 - Official Release**

> Release Date: Oct 19, 2017

This was the first public release of the iOS app.

**V.1.1 - Safety Release**

> Release Date: Mar 5, 2019

The second major release for the SaintsXCTF iOS app.  Besides for bug fixes, this release introduced a EULA which is
presented to users as they sign up.  Another major feature was the report functionality, allowing users to contact the
site administrator about application problems / questionable user content.  Both of these features were added to conform
to Apple guidelines.


Current development is being spent on other projects.  However a codebase is always dynamic.  Future plans include:

* Suggested Features (ex. Delete/Edit Comments)
* Forgot Password
* Real-Time Notifications with a Message Broker

### Files

| Filename                  | Description                                                                                      |
|---------------------------|--------------------------------------------------------------------------------------------------|
| `SaintsXCTF.xcodeproj`    | Configuration for the XCode project.                                                             |
| `SaintsXCTF.xcworkspace`  | Configuration for the XCode workspace.                                                           |
| `SaintsXCTF`              | Contains code for the main SaintsXCTF application.                                               |
| `SaintsXCTFTests`         | Contains unit tests for the SaintsXCTF application.                                              |
| `Podfile`                 | Cocoapods dependencies for the application.  Written in Ruby.                                    |
| `pod.sh`                  | Important shell commands for working with Cocoapods.                                             |
