//
//  JSonManager.swift
//  SnapExam
//
//  Created by SunilMaurya on 18/09/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSonManager {
    class func getQuestions() -> [[String:Any]]? {
        do {
            if let file = Bundle.main.url(forResource: "problemJson", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let jsonValues = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = jsonValues as? [[String:Any]] {
                    return object
                } else {
                    print("JSON is not appropriate")
                }
            } else {
                print("Json file not found")
            }
            return nil
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
