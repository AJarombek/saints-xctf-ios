# saints-xctf-ios

### Overview

An iOS app that goes along with my website `saintsxctf.com`.  All development is done in Swift.  
The backend calls a REST API written in Python.

There is also an Android app that was released August 2017.

You can follow development of the website here: [SaintsXCTF Website GitHub](https://github.com/AJarombek/saints-xctf-web).

You can follow development of the API here: [SaintsXCTF API GitHub](https://github.com/AJarombek/saints-xctf-api).

You can follow development of the android app here: [SaintsXCTF Android GitHub](https://github.com/AJarombek/saints-xctf-android).

### Releases

**V.2.0.0 - Version 2 Release**

> Release Date: Jun 1, 2021

This version of the iOS app aligns with the second version of the web application and API.  While no new features were added to the iOS app, aligning it with 
the new web application and API enables quick updates going forward.

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
