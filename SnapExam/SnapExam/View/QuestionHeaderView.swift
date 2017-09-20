//
//  QuestionHeaderView.swift
//  SnapExam
//
//  Created by SunilMaurya on 19/09/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import UIKit

let tableSectionQuestionFont = UIFont.boldSystemFont(ofSize: 16.0)
let tableSectionWidth = UIScreen.main.bounds.size.width - 20.0

class QuestionHeaderView: UIView {
    func headerView(text:String?) -> UIView? {
        if let textHeight = text?.height(withConstrainedWidth: tableSectionWidth, font: tableSectionQuestionFont) {
            self.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: textHeight + 30.0)
            self.backgroundColor = UIColor.white
            let questionLabel = UILabel(frame: CGRect(x: 10.0, y: 15.0, width: UIScreen.main.bounds.size.width - 20.0, height: textHeight))
            questionLabel.numberOfLines = 0
            questionLabel.font = tableSectionQuestionFont
            questionLabel.text = text
            self.addSubview(questionLabel)
            return self
        }
        return nil
    }
}
