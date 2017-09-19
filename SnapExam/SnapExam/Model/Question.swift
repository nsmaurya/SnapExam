//
//  Paper.swift
//  SnapExam
//
//  Created by SunilMaurya on 18/09/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import ObjectMapper


/*{
    "responseType": "multiSelect",
    "question": "Now, lets talk about something else. Why you want to be a Snapster?",
    "options": [
    {
    "text": "Be a part of something great!",
    "isSelected": false
    },
    {
    "text": "Get to work on some challenging problems!",
    "isSelected": false
    },
}
*/

struct Question: Mappable {
    
    var responseType: String?
    var question: String?
    var questionOptions: [QuestionOption]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        responseType <- map["responseType"]
        question <- map["question"]
        questionOptions <- map["options"]
    }
}

struct QuestionOption: Mappable {
    
    var text:String?
    var isSelected:Bool?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        text <- map["text"]
        isSelected <- map["isSelected"]
    }
}
