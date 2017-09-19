//
//  ExamInteractor.swift
//  SnapExam
//
//  Created by SunilMaurya on 18/09/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import ObjectMapper

private let _sharedInstance = ExamInteractor()
class ExamInteractor {
    //Variables
    fileprivate var questions:[Question]?
    fileprivate var currentPage = -1
    fileprivate let resultFetcher = [2,2,1,2]
    fileprivate var totalQuestionsFetched = 0
    
    //shared instance
    class var sharedInstance:ExamInteractor {
        return _sharedInstance
    }

    //MARK:- Initiate Papers
    func initiatePaperInfo() {
        if let jsonQuestions = JSonManager.getQuestions() {
            questions = Mapper<Question>().mapArray(JSONArray: jsonQuestions)
        }
    }
    
    //MARK:- Get Questions
    func getQuestions()-> (isLastPage:Bool, questionList:[Question]) {
        if let questionList = questions {
            currentPage = currentPage + 1
            if !resultFetcher.isEmpty {
                var maxRecordToBeFetched = questionList.count
                if currentPage < resultFetcher.count {
                    maxRecordToBeFetched = resultFetcher[currentPage]
                }
                let lastQuestionIndex = (totalQuestionsFetched + maxRecordToBeFetched)
                var questionsToBeDisplayed = [Question]()
                while(totalQuestionsFetched < lastQuestionIndex) {
                    if totalQuestionsFetched < questionList.count {
                        questionsToBeDisplayed.append(questionList[totalQuestionsFetched])
                        totalQuestionsFetched = totalQuestionsFetched + 1
                    } else {
                        break
                    }
                }
                let isLastObjectFetched = (totalQuestionsFetched + 1) >= questionList.count ? true : false
                return (isLastObjectFetched, questionsToBeDisplayed)
            } else {
                return (true, questionList)
            }
        }
        return (true, questions ?? [Question]())
    }
}
