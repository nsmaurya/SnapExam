//
//  Paper.swift
//  SnapExam
//
//  Created by SunilMaurya on 18/09/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import ObjectMapper

class Question: Mappable {
    
    var responseType: String?
    var question: String?
    var questionOptions: [QuestionOption]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
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
