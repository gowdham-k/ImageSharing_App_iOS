//
//  ApiClient.swift
//  Numnu
//
//  Created by CZ Ltd on 11/20/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth
import FirebaseStorage



class  ApiClient {
    
//    /*********************Login Api*****************************/
//
//    func userLogin(parameters : Parameters,completion : @escaping (String,UserList?) -> Void) {
//
//        Alamofire.request(Constants.LoginApiUrl, method: .post, parameters: parameters).validate().responseJSON { response in
//
//            switch response.result {
//
//            case .success:
//
//                if let value = response.result.value {
//
//                    let json = JSON(value)
//                    if let userList = UserList(json: json) {
//
//                        completion("success",userList)
//                    }
//
//
//                }
//
//
//            case .failure(let error):
//
//                print(error)
//                completion(error.localizedDescription,nil)
//
//            }
//       }
//
//    }
    
     /*********************Login Api*****************************/
    
    func userLogin(headers : HTTPHeaders,completion : @escaping (String,UserList?) -> Void) {
        
        Alamofire.request(Constants.LoginApiUrl, method: .get, headers: headers).validate().responseJSON { response in
            
            print(response.result.value)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let userList = UserList(json: json) {
                        
                        completion("success",userList)
                    }
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
        }
        
    }
    
    func usernameexists(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,Bool?) -> Void) {
        
        
        
        Alamofire.request(Constants.CheckUserName, method: .get, parameters: parameters,headers : headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let usernameexists = json["usernameexists"].bool {
                        
                        completion("success",usernameexists)
                    }
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
    }
    
    /************************Tags Api**********************************/
    
    func getTagsApi(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,TagList?) -> Void) {
        
        Alamofire.request(Constants.TagApiUrl, method: .get, parameters: parameters,headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let userList = TagList(json: json) {
                        
                        completion("success",userList)
                    }
                  
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
     /************************Events Api**********************************/
    func getEventsApi(headers : HTTPHeaders,completion : @escaping (String,EventModelList?) -> Void) {
        
        Alamofire.request(Constants.EventApiUrl, encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let eventList = EventModelList(json: json) {
                        
                        completion("success",eventList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /************************Event Detail*******************************/
    func getEventsDetailsApi(headers : HTTPHeaders,completion : @escaping (String,EventList?) -> Void) {
        
        Alamofire.request(Constants.EventApiUrl, encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let eventList = EventList(json: json) {
                        
                        completion("success",eventList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /************************Items Api**********************************/
    func getItemsApi(parameters : Parameters,completion : @escaping (String,ItemList?) -> Void) {
        
        Alamofire.request(Constants.ItemsApiUrl, method: .get, parameters: parameters,encoding: JSONEncoding.default).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let itemList = ItemList(json: json) {
                        
                        completion("success",itemList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /*********************Complete Signup Api*****************************/
    
       func completeSignup(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,UserList?) -> Void) {
        
        Alamofire.request(Constants.completeSignup, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
           
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    print(value)
                    
                    let json = JSON(value)
                    
                    if let userList = UserList(json: json) {
                        
                        completion("success",userList)
                    }
                    
                    
                }
                
                
            case .failure(let error):
             
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
        }
    
        
    }
    
    /********************************getBussinessbasedEvent*************************************************/
    
    func getBussinessEvent(id : Int,headers : HTTPHeaders,completion : @escaping (String,[BussinessEventList]?)-> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(id)/businesses", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    var bussinessary : [BussinessEventList]?
                    
                    let json = JSON(value)
                    
                    if let array = json.array {
                        
                        for item in array {
                            
                            if let list = BussinessEventList(json: item) {
                                
                                bussinessary = [BussinessEventList]()
                                bussinessary?.append(list)
                                
                               
                            }
                         
                        }
                        
                        completion("success",bussinessary)
                        
                    } else {
                        
                         completion("success",nil)
                        
                    }
                
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
                }
            
            }
            
     }
        
    /********************************getItemsbasedid*************************************************/
    
    func getItemById(id : Int,headers : HTTPHeaders,completion : @escaping (String,ItemList?)-> Void) {
        
        Alamofire.request("\(Constants.ItemsApiUrl)/\(id)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let itemList = ItemList(json: json) {
                        
                        completion("success",itemList)
                    }
                  
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /************************Events Api**********************************/
    func getEventsTypesApi(parameters : Parameters,completion : @escaping (String,EventTypeList?) -> Void) {
        
        Alamofire.request(Constants.EventTypeApiUrl, method: .get, parameters: parameters,encoding: JSONEncoding.default).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let eventList = EventTypeList(json: json) {
                        
                        completion("success",eventList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    
    
    func getFireBaseToken(completion : @escaping (String) -> Void) {
    
     if let currentUser = Auth.auth().currentUser {
        
         currentUser.getTokenForcingRefresh(true) {idToken, error in
            if let error = error {
              print(error.localizedDescription)
                completion(error.localizedDescription)
              return;
            }
            
            print(idToken ?? "empty")
            completion(idToken ?? "empty")
          
         }
            
            
     } else {
        
        Auth.auth().signInAnonymously() { (user, error) in
            
            if error != nil {
                
                completion("empty")
            }
            
            if let annoymususer = user {
                
                annoymususer.getTokenForcingRefresh(true) {idToken, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(error.localizedDescription)
                        return;
                    }
                    
                    print(idToken ?? "empty")
                    completion(idToken ?? "empty")
                    
                }
                
                
            } else {
                
                completion("empty")
            }
            
            
        }
  	
        }
        
    }
    
    func getFireBaseImageUrl(imagepath : String,completion : @escaping (String) -> Void) {
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to download
        let starsRef = storageRef.child(imagepath)
        
        // Fetch the download URL
        starsRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
                completion("empty")
                
            } else {
                
                completion((url?.absoluteString)!)
                
            }
        }
        
        
        
    }
    
    
    
}
