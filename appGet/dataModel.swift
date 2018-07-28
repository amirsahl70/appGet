//
//  dataModel.swift
//  appGet
//
//  Created by Amir on 7/7/18.
//  Copyright © 2018 uni. All rights reserved.
//

import Foundation

class userData {
    
    let firstName : String
    let lastName : String
    let message : String
    let year : String
    let month : String
    let day : String
    
    init(firstName : String, lastName : String, message : String, year : String, month:String, day:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.message = message
        self.year = year
        self.month = month
        self.day = day
        
    }

}
