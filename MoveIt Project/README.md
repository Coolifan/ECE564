# MoveIt!
![logo](./doc/img/AppIcon.png)

## Getting Started

1. Clone/Download the complete project folder
2. Open the xcworkspace file `MoveIt.xcworkspace` in Xcode
2. Build the project and run on a target device


## Environment Requirements

- Xcode 10.1+
- iOS 12.1+
- CocoaPods 1.5.3
    - Alamofire 4.7.3
    - Charts 3.4.1
    - Eureka 4.3.0
    - Firebase 5.11.0
    - SwiftyJSON 4.2.0

## File Structure

```bash
├── doc            # resources(screenshots) used for README(this file)
│   ├── MoveIt!*   # the presentation slides used by our team  
├── MoveIt         # the complete project folder
│   ├── MoveIt     # the main project folder of MoveIt 
│   │   ├── Assets.xcassets        # image resources used for the app
│   │   ├── Controllers            # View Controllers (C of MVC)
│   │   ├── Storyboards            # Views (V of MVC)
│   │   ├── Model                  # Data Models (M of MVC)
│   │   ├── Utilities              # axillary helper functions
│   │   ├── AppDelegate.swift   
│   │   ├── Info.plist   
│   │   ├── GoogleService-Info.plist
│   │   ├── MoveIt.entitlements 
|   |   └── Base.lproj   
│   ├── Pods       # the Cocoapods project folder containing all used third-party libraries 
│   │   ├── Alamofire              # an HTTP networking library written in Swift
│   │   ├── Charts                 # an easy to use chart library
│   │   ├── Eureka                 # elegent form builder in Swift
│   │   ├── Firebase*              # online real-time database
│   │   ├── SwiftyJSON             # a fast JSON file handler
│   ├── Podfile*   # Cocoapods settings
│   └── MoveIt.*   # Xcode workspace files
├── README.md
└── .gitignore
```

## Key Features/Functions
### Part 1: Homepage
<img src="./doc/img/homepage.PNG"  width="300" height="540">


`Restaurants` button: Display the top-10 recommended nearby restaurants ranked by keywords of menu items. The ranking algorithm can be customized by 
developers.

`Gardens` button: Display the nearby gardens.

Activity goals button: The two buttons at the top half of the homepage. The current daily activity goal progress can be previewed.

### Part 2: Activity Goals 
<img src="./doc/img/activity.PNG"  width="300" height="540">

This page consists of a pie chart and a line chart. The pie chart shows the percentage of days that the user achieves daily goal in a week, and the 
line chart shows the step counts for the most recent 7 days. The red line on the line chart is the daily step goal set by the user. The default value 
is 3000 steps per day.

### Part 3: Restaurant/Garden List
<img src="./doc/img/restaurant.PNG"  width="300" height="540">

Greetings and the real-time weather location are shown on the top half of the page.  Within the table, we selected the top-10 restaurants for 
recommendation based on the ranking algorithm. The walking distance and estimated walking duration from the user's current location to the selected
place are also shown in the list. The user could click on one of the restaurants/gardens to learn more about the selected place.

### Part 4: Detail Information Page
<img src="./doc/img/detail.PNG"  width="300" height="540">

Detailed information of a restaurant or garden is displayed in this page, including the name, address, phone number and website of the selected place. 
The current location of the user and the location of the selected place are shown on the Apple Map.

`See Menus` button: Show the menu of the restaurant.

`Get Directions` button: Redirect to Apple Map app and get the route to the selected place.

`Like` button: The yellow star on the top right of the page. The user can add the current place to his favorite list.

### Part 5: Menu Page
<img src="./doc/img/menu.PNG"  width="300" height="540">

This page shows the menu of the restaurant. 

The core idea of our ranking algorithm: If a menu item contains the 'liked' keyword set by the user, we add 5 points, and we -5 points for
'disliked' keyword set by the user. Also, there are 4 preset ranges of calories, fat, sugar, and carbohydrate for each menu item.
If the value of an item falls out of the range, we -1 point each time. 

### Part 6: Map Page
<img src="./doc/img/map.PNG"  width="300" height="540">

Apple Map UI shows the navigation information to the selected place.

### Part 7: Favorite Places Page
<img src="./doc/img/favorite.PNG"  width="300" height="540">

After the user added some restaurants or gardens to the favorite list, he or she can check the detailed information of the favorite places directly
in this page. 

### Part 8: Settings Page
<img src="./doc/img/settings.PNG"  width="300" height="540">

The user could modify personal information, daily goals, and activity preferences in this page. Customizable field includes:

`Name` : the name of the user

`Height` and `Weight`: the height and weight of the user

`Age` : the age of the user

`Daily Step`: the daily step goal 

`Calories`: the daily calories goal

`Goal Weight`: the target weight

`Like Foods`: the list of keywords that the user likes

`Dislike Foods`: the list of keywords that the user dislikes

`Breakfast`, `Lunch`, and `Dinner`: the notification time of meals

<img src="./doc/img/notification.PNG"  width="300" height="540">

## Database

We use Google Firebase as the real-time database to store restaurant information, menu information, user's favorites and user's settings. You can use the file named `firebaseData.json` under the `Model` folder to initialize an empty Google Firebase database for testing.

Data in Google Firebase's real-time database is stored as JSON. The structure of this app's database can be understood through the below example:

<img src="./doc/img/database_structure.png"  width="600" height="540">

There are 3 main directories: `restaurants`, `favourites` and `settings`.

- `restaurants`

This directory will store all restaurants' complete information. Each restaurant will be identified by its Google Places ID, which is a unique key.
For each restaurant, currently we store its Google Places ID, name, address, phone number and its menu. The menu is an array that contains information of all available foods in the restaurant.

- `favourites`

This directory stores user's favorite restaurants and parks.There are 2 arrays for favorite restaurants and favorite parks respectively.
We store only the Google Places ID in the arrays. To guarantee that users can get up-to-date information of their favorite restaurants and parks, we
send requests to APIs to get complete information with the unique Google Places ID when loading the Favorite tab.

- `settings`

This directory stores all the information on the app's Settings tab. Everytime we launch the app, the app will automatically fetch the latest settings from Firebase to initialize user's settings.

## Appendix
### APIs
**Note: These API keys belong to the development team. For future development or usage, please register and use your own API keys**

Google Place API
- API Key: AIzaSyDzi0HPWH371bh1Y96mRNQQhIgroKkQqk4
- Text Search requests
  - URL: https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants&location=42.3675294,-71.186966&radius=10000&key=AIzaSyDzi0HPWH371bh1Y96mRNQQhIgroKkQqk4
  - Documentation: https://developers.google.com/places/web-service/search#TextSearchRequests

Nutritionix API

- APP id: b108d5e3
- APP key: 00a801040a499040e91dc89b57d9a567

OpenWeatherMap API
- appid/API Key: 80a6764d399620f1658c8e4a660140df
- Search by geographic coordinates
  - URL: https://api.openweathermap.org/data/2.5/weather?lat=36&lon=-78.94&appid=80a6764d399620f1658c8e4a660140df
  - Documentation: https://openweathermap.org/current#geo

Google Distance Matrix API
- API Key: AIzaSyBfk8EDPBPW4xPImEJbs5v19QSopFM-oxg
- Documentation: https://developers.google.com/maps/documentation/distance-matrix/intro

### Update History

12/5/18:
1. Updated the complete README.md
2. Refactored code
3. Updated menu page and restaurant/garden list page
4. Updated ranking algorithm

11/26/18:
1. Added settings functionality
2. Added communication with Firebase
3. Added favorite page
4. UI improvements
5. Fixed miscellaneous bugs

11/25/18:
1. Finished drawing weekly steps counting charts and weekly progress charts
2. Added ranking algorithm

11/17/18:
1. Added weather information using OpenWeatherMap API
2. Added time information 
3. Added step counting functionality

11/16/18:
1. Added maps/navigation functionality
2. Improved charts drawing

11/3/18:
1. Created basic UI storyboards
2. Added geolocation functionality
3. Added communication with Google Place API

## Authors

Haohong Zhao

Yifan Li

Zi Xiong

Wenchao Zhu
