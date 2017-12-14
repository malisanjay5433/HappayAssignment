//
//  File.swift
//  HappayAssignment
//
//  Created by Sanjay Mali on 14/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import Foundation

struct NewBikerModel:Decodable{
    let network:DICNetwork
}
struct DICNetwork:Decodable {
    let name:String?
    let id:String?
    let href:String?
    let company:[String]?
    let location:Location?
    let stations:[ArrStations]
    /*
     "company":[],
     "href":"/v2/networks/bbbike",
     "id":"bbbike",
     "location":{},
     "name":"BBBike",
     "stations":[]
    */
    
}
struct ArrStations:Decodable {
    let free_bikes:Int
    let name:String
    let timestamp:String
    let latitude:Double
    let longitude:Double
    let empty_slots:Int
    /*
     "empty_slots":12,
     "extra":{},
     "free_bikes":0,
     "id":"34eff3b3b29182f81ba630f51b1a0637",
     "latitude":49.815247,
     "longitude":19.044895,
     "name":"08 Plac Mickiewicza",
     "timestamp":"2017-12-14T16:52:44.703000Z"
     */
}

