//
//  ExamInteractor.swift
//  SnapExam
//
//  Created by SunilMaurya on 18/09/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import ObjectMapper

enum QuestionType: String {
    case text = "text"
    case integer = "integer"
    case date = "date"
    case singleSelect = "singleSelect"
    case multiSelect = "multiSelect"
}

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
                    if maxRecordToBeFetched <= 0 {
                        return (true, [Question]())
                    }
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
                
                let isLastObjectFetched = totalQuestionsFetched >= questionList.count ? true : false
                return (isLastObjectFetched, questionsToBeDisplayed)
            } else {
                return (true, questionList)
            }
        }
        return (true, questions ?? [Question]())
    }
    
    //MARK:- Update Answer of questions
    @discardableResult func updateAnswerOption(questionList: inout [Question], indexPath:IndexPath, questionType:QuestionType, text:String? = nil) -> Bool {
        var isTableReloadRequired = true
        let question = questionList[indexPath.section]
        switch questionType {
        case .singleSelect:
            if let questionOptions = question.questionOptions {
                var index = 0
                while index < questionOptions.count {
                    questionList[indexPath.section].questionOptions?[index].isSelected = false
                    index = index + 1
                }
                questionList[indexPath.section].questionOptions?[indexPath.row].isSelected = true
            }
        case .multiSelect:
            if let questionOptions = question.questionOptions {
                if let isSelected = questionOptions[indexPath.row].isSelected {
                    questionList[indexPath.section].questionOptions?[indexPath.row].isSelected = !isSelected
                } else {
                    questionList[indexPath.section].questionOptions?[indexPath.row].isSelected = true
                }
            }
        default:
            questionList[indexPath.section].questionOptions?[indexPath.row].text = text
            isTableReloadRequired = true
        }
        return isTableReloadRequired
    }
    
    //MARK:- Reset All
    func resetAll(isQuestionsResetTo:Bool = false) {
        if isQuestionsResetTo {
            self.questions = nil
            self.initiatePaperInfo()
        }
        self.totalQuestionsFetched = 0
        self.currentPage = -1
    }
    
    //MARK:- Get QuestionHeader Height
    func getQuestionHeaderHeight(text:String?) -> CGFloat {
        if let textHeight = text?.height() {
            return textHeight + 30.0
        } else {
            return 0.0
        }
    }
}
