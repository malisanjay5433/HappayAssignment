//
//  BikerModel.swift
//  HappayAssignment
//
//  Created by Sanjay Mali on 07/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit
struct BikerModel:Decodable{
    let networks:[Networks]
}
struct Networks:Decodable {
    let name:String
    let id:String
    let href:String
    let location:Location
//    let stations:[Stations]
}
struct Location:Decodable {
    let latitude:Double
    let longitude:Double
    let country:String
    let city:String
}
struct Stations:Decodable {
    let free_bikes:String?
    let name:String?
    let timestamp:String?
    let latitude:Double?
    let longitude:Double?
}


//
