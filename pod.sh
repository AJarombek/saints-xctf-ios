#!/bin/sh

#  Bash scripts for CocoaPods
#  Created by Andy Jarombek on 1/29/19.

# Make sure Ruby is installed for CocoaPods to work
whereis ruby
ruby --version

gem install cocoapods

pod install
pod update
pod deintegrate
