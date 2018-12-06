//
//  URLs.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/14/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

struct GoogleAPI {
    static let places = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    static let placeDetail = "https://maps.googleapis.com/maps/api/place/details/json"
    static let image = "https://maps.googleapis.com/maps/api/place/photo"
    static let key = "AIzaSyDzi0HPWH371bh1Y96mRNQQhIgroKkQqk4"
    static let placeId = "https://maps.googleapis.com/maps/api/place/details/json"
}

struct WeatherAPI {
    static let URL = "https://api.openweathermap.org/data/2.5/weather"
    static let APP_ID = "80a6764d399620f1658c8e4a660140df"
}

struct DistanceMatrixAPI {
    static let url = "https://maps.googleapis.com/maps/api/distancematrix/json"
    static let key = "AIzaSyBfk8EDPBPW4xPImEJbs5v19QSopFM-oxg"
}
