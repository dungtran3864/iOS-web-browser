#  ACME Mobile Browser

## Author: Toni Tran

## Setup & Run Project

1. Extract the zip file
2. Open Terminal and change directory to the root project
3. If you haven't installed CocoaPods, install with the following command line: `sudo gem install cocoapods`
4. If you have installed CocoaPods, install the Pods with the following command line: `pod install`
5. After successfully installed the Pods, open NeevaChallenge.xcworkspace in Xcode
6. Press Command + R or click Run (on the top left)

## Features implemented

1. Load the website from the URL input text field
2. Refresh the website
3. Go back to previous web page
4. Go forward to next web page
5. Tabs
    * Add a new blank tab
    * Delete a tab
    * Switch to a tab
    * Cancel switching a tab
6. Bookmark ("advanced" feature)
    * Bookmark the current page
    * Delete a bookmark
    * Cancel selecting a bookmark

## Approach

When I read the description of the project, I start to think about the user experience of a typical mobile browser. I look at common mobile browsers such as Safari or Chrome to see how the features operate and how the user experience is shaped. Afterward, I start to do some mock-ups of the mobile browser to construct the user interface and shape the user experience. I divide the mobile browser into 3 main components: web browser, tabs and bookmarks.

I follow the Model-View-Controller design pattern, which is common among iOS apps. The Model handles the management and logic of tabs and bookmarks. The View is responsible for displaying the content of the app as well as receive inputs from users. The Controller receives inputs from the View and transfer those information to the Model to process, as well as receive responses from the Model and transfer back to the View to display them. This design pattern makes the app more readable, maintainable and loosely coupled.

I use extension and MARK for every delegate that the Controller inherits because the code becomes more readable and pinpoints which functions belong specifically to a particular delegate.

For the tabs and bookmarks navigation, I use "present modally" because it's unintrusive and brings out a smooth work flow. Users immediately encounter tabs and bookmarks they have when the modal comes up. Users then just could simply select a tab or bookmark, and the modal automatically comes down to show the website, or cancel to go back to the current website at ease.

For the tabs, I highlight the current tab in black and other unfocused tabs in gray. I think these coded colors will help users distinguish the tabs easier. 

I create a separate Constants file to organize all the constants used throughout the app. The icons I use in the app are System icons, which help users understand the functionality meaning easily.

A trade-off that I made is to use TabManager and BookmarkManager as classes instead of structs. Structs are recommended by default in Swift. However, when I use structs initially, I find out that BrowserViewController and TabsViewController both share the same TabManager, and BrowserViewController and BookmarkManager both share the same Bookmark Manager. Using structs means I have to update the TabManager or BookmarkManager on the Controllers manually because each Controller holds completely independent struct Models due to structs are passed by value, not reference. Using classes makes more sense in this case because the Controllers point to the same TabManager or BookmarkManager. When a property in TabManager or BookmarkManager is updated, all Controllers will get access to the updated information as well. Of course, I have to be more careful about state changes when using classes because it's unpredictable. However, it's a worthy trade-off.
