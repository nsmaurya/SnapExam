//
//  Extensions.swift
//  SnapExam
//
//  Created by SunilMaurya on 19/09/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import UIKit
extension String {
    func height(withConstrainedWidth width: CGFloat = tableSectionWidth, font: UIFont = tableSectionQuestionFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(boundingBox.width)
    }
}
