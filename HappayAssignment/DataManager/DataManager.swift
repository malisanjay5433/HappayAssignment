//
//  DataManager.swift
//  HappayAssignment
//
//  Created by Sanjay Mali on 09/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//
import Foundation
public final class DataManager {
    public static func getJSONFromURL(_ api:String, completion:@escaping (_ data:Data?, _ error:Error?) -> Void){
        DispatchQueue.global(qos: .background).async {
            let url = URL(string:api)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                do{
                    if data == nil{
                        print("Data nil")
                        return
                    }
                    completion(data,nil)
                }catch{
                    print(error)
                }
                
             }.resume()
        }
    }
}
