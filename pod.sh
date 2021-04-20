#!/bin/sh

#  Bash scripts for CocoaPods
#  Created by Andy Jarombek on 1/29/19.

# ----------------
# Current Commands
# ----------------

brew install cocoapods

pod --version
ruby --version

pod install

# -------------
# 2019 Commands
# -------------

# Make sure Ruby is installed for CocoaPods to work
brew install ruby

whereis ruby
ruby --version

gem uninstall cocoapods
gem install cocoapods

pod install
pod update
pod deintegrate
