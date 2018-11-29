# MoveIt!



Google Place API

- API Key: AIzaSyDzi0HPWH371bh1Y96mRNQQhIgroKkQqk4

- Text Search requests
  - URL: https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants&location=42.3675294,-71.186966&radius=10000&key=AIzaSyDzi0HPWH371bh1Y96mRNQQhIgroKkQqk4
  - Documentation: https://developers.google.com/places/web-service/search#TextSearchRequests

Nutritionix API

- APP id: b108d5e3
- APP key: 00a801040a499040e91dc89b57d9a567

Zomato API

- APP Key: f9a758119642e9dbab7ac45162909191
- 1000 calls/day

OpenWeatherMap API
- appid/API Key: 80a6764d399620f1658c8e4a660140df
- Search by geographic coordinates
  - URL: https://api.openweathermap.org/data/2.5/weather?lat=36&lon=-78.94&appid=80a6764d399620f1658c8e4a660140df
  - Documentation: https://openweathermap.org/current#geo
##
# Update History

11/26/18:
1. Add the breakfast, lunch and dinner notifications in the settings viewcontroller.

11/25/18:
1. Finished drawing weekly steps counting charts and weekly progress charts
2. Fixed minor bugs when the access to health app is denied

11/17/18:
1. Added weather information
2. Added time information
3. Added step counting functionality

11/16/18:
1. Added maps/navigation functionality
2. Improved charts drawing

11/3/18:
1. Created basic UI storyboards
2. Added geolocation functionality
3. Added communication with Google Place API

##
# Meeting Notes:

11/9/18:
1. write slides about the cost of the APIs and call times
2. Add weather API, localtime API
3. Add push notification feature in the app, for example: send the notification 11am everyday to remind the user to get lunch
4. push notification should be the Alert
5. Ranking algorithm:
	a. can just use the key words to increase or decrease the score of the resturant
	b. can rank based on the nutrition information, like the sugar, calories and so on
	c. if the menu is just the pdf/jepg, we can just say "cannot log into the menu" and suggest the standard salad

11/12/18 with Ric and Niral:
1. work assignment: Haohong -- UI, Zi -- Nutritionix, Wenchao -- push notification and Nutritionix, Yifan -- database
2. perhaps save the local restaurant's data in the local storage
3. should be easy to fetch steps count from health app
4. do not spend too much time working on one thing. get a viable working app for demo.
5. OpenMenu should be easily be used.

11/19/18 with Ric and Niral:
1. Create hardcode UI for future APIs.
2. Hardcode the surrounding restaurants' menus in memory.
3. Ask Ric to upload the class videos.
4. Send the local notifications.
