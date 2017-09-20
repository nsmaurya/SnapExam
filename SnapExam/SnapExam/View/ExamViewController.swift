//
//  ViewController.swift
//  SnapExam
//
//  Created by SunilMaurya on 18/09/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import UIKit

class ExamViewController: UIViewController {
    
    //IBOutlet
    @IBOutlet weak var startTestButton: UIButton!
    @IBOutlet weak var checkYourAnswersButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getStartedView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var rightBarButton: UIBarButtonItem!
    
    //Variables
    var questionList = [Question]()
    lazy var examInteractor = ExamInteractor.sharedInstance
    var isAnswerCheckerInitiated = false
    var activeTextField:UITextField?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        //initializing question paper
        examInteractor.initiatePaperInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Helper method
    fileprivate func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func initialSetup() {
        self.startTestButton.layer.borderColor = UIColor(red: 20.0/255.0, green: 130.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
        self.startTestButton.layer.borderWidth = 1.0
        self.startTestButton.layer.cornerRadius = 4.0
    }
    
    fileprivate func tableSetup() {
        self.tableView.isHidden = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 54.0
        self.tableView.tableFooterView = UIView()
    }
    
    fileprivate func reloadTable() {
        self.tableView.reloadData()
    }
    
    fileprivate func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    fileprivate func showNoQuestionAvailableScreen() {
        self.infoLabel.textColor = UIColor.red
        self.infoLabel.text = "Question not available\n Please contact to admin"
        self.tableView.isHidden = true
        self.navigationItem.rightBarButtonItem = nil
        self.bottomView.isHidden = false
        self.checkYourAnswersButton.isEnabled = false
    }
    
    // MARK: Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    
    // MARK: Keyboard Notification Method
    func keyboardDidShow(_ notification:Foundation.Notification) {
        if let dict = (notification as NSNotification).userInfo {
            if let keyboardHeight = (dict[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                self.tableView.contentInset = contentInset
                self.tableView.scrollIndicatorInsets = contentInset
                
                var aRect : CGRect = self.view.frame
                aRect.size.height -= keyboardHeight
                if let activeField = self.activeTextField {
                    if (!aRect.contains(activeField.frame.origin)){
                        self.tableView.scrollRectToVisible(activeField.frame, animated: true)
                    }
                }
            }
        }
    }
    
    func keyboardDidHide(_ notification:Foundation.Notification) {
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInset
        self.tableView.scrollIndicatorInsets = contentInset
    }
    
    //MARK:- Action method
    @IBAction func startTestButtonTapped(_ sender: UIButton){
        var isLastPage = true
       (isLastPage, questionList) = examInteractor.getQuestions()
        self.getStartedView.isHidden = true
        if !questionList.isEmpty {
            var title = "Next"
            if isLastPage {
                title = "Done"
            }
            //adding right bar button
            if self.rightBarButton == nil {
                self.rightBarButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightBarButtonTapped))
                //adding keyboard observer
                self.addKeyboardObserver()
                //setting up table view
                self.tableSetup()
            } else {
                self.rightBarButton.title = title
                self.tableView.isHidden = false
            }
            self.navigationItem.rightBarButtonItem = rightBarButton
            self.reloadTable()
        } else {
            self.showNoQuestionAvailableScreen()
        }
    }
    
    @IBAction func rightBarButtonTapped() {
        self.hideKeyboard()
        if self.rightBarButton.title == "Done" {
            self.infoLabel.textColor = UIColor.blue
            if self.isAnswerCheckerInitiated {
                self.infoLabel.text = "Result checking done!!!\n You are passed😊"
            } else {
                self.infoLabel.text = "Congratulations!!!\n You are passed😊"
            }
            self.tableView.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
            self.bottomView.isHidden = false
            self.checkYourAnswersButton.isEnabled = true
        } else {
            var isLastPage = true
            (isLastPage, questionList) = examInteractor.getQuestions()
            if isLastPage {//checking for last page
                self.rightBarButton.title = "Done"
            }
            if questionList.count > 0 {
                self.reloadTable()
                //if keyboard is open, then while reload, first cell is not shown, for showing that
                for section in 0..<self.tableView.numberOfSections{
                    if self.tableView.numberOfRows(inSection: section) > 0 {
                        self.tableView.scrollToRow(at: IndexPath(row:0,section:section), at: .top, animated: false)
                        break
                    }
                }
            } else {//if no question available
                self.showNoQuestionAvailableScreen()
            }
        }
    }
    
    @IBAction func gotoHomeButtonTapped(_ sender: UIButton) {
        self.bottomView.isHidden = true
        self.questionList = [Question]()
        self.reloadTable()
        self.examInteractor.resetAll(isQuestionsResetTo: true)
        self.getStartedView.isHidden = false
        self.isAnswerCheckerInitiated = false
    }
    
    @IBAction func checkYourAnswersButtonTapped(_ sender: UIButton) {
        self.isAnswerCheckerInitiated = true
        self.bottomView.isHidden = true
        self.questionList = [Question]()
        self.reloadTable()
        self.examInteractor.resetAll()
        self.startTestButtonTapped(startTestButton)
    }
}

//MARK:- TableView DataSource
extension ExamViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.questionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let options = self.questionList[section].questionOptions {
            return options.count
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return examInteractor.getQuestionHeaderHeight(text: self.questionList[section].question)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return QuestionHeaderView().headerView(text: self.questionList[section].question)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as? QuestionCell else {
            fatalError("QuestionCell not found...")
        }
        cell.questionButton.isHidden = false
        cell.questionTextField.isHidden = true
        cell.questionLabel.isHidden = false
        
        if self.isAnswerCheckerInitiated {
            cell.questionTextField.isEnabled = false
        } else {
            cell.questionTextField.isEnabled = true
        }
        
        let question = self.questionList[indexPath.section]
        let questionOption = question.questionOptions ?? [QuestionOption]()
        if let responseType = question.responseType {
            if let resType = QuestionType(rawValue: responseType) {
                switch  resType {
                case .singleSelect, .multiSelect://for radio, checkbox
                    cell.questionLabel.text = questionOption[indexPath.row].text
                    cell.questionButton.isSelected = questionOption[indexPath.row].isSelected ?? false
                    if resType == .singleSelect {
                        cell.questionButton.setImage(#imageLiteral(resourceName: "radio_unselected"), for: .normal)
                        cell.questionButton.setImage(#imageLiteral(resourceName: "radio_selected"), for: .selected)
                    } else {
                        cell.questionButton.setImage(#imageLiteral(resourceName: "checkbox_unselected"), for: .normal)
                        cell.questionButton.setImage(#imageLiteral(resourceName: "checkbox_selected"), for: .selected)
                    }
                default://for text, integer, date
                    cell.questionButton.isHidden = true
                    cell.questionTextField.isHidden = false
                    cell.questionLabel.isHidden = true
                    cell.questionTextField.text = questionOption[indexPath.row].text
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isAnswerCheckerInitiated {//if no answer check running, then action
            self.hideKeyboard()
            let question = questionList[indexPath.section]
            if let responseType = question.responseType {
                if let questionType = QuestionType(rawValue: responseType) {
                    switch questionType {
                    case .singleSelect, .multiSelect:
                        if examInteractor.updateAnswerOption(questionList:&self.questionList, indexPath: indexPath, questionType: questionType) {
                            self.reloadTable()
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
}

//MARK:- UITextfield Delegate
extension ExamViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var cellView = textField.superview?.superview
        if let v = cellView {
            if !(v.isKind(of: QuestionCell.self)) {
                cellView = textField.superview
            }
        }
        if let cell = cellView as? QuestionCell {
            if let indexPath = self.tableView.indexPath(for: cell) {
                examInteractor.updateAnswerOption(questionList:&self.questionList,indexPath: indexPath, questionType: .text, text: textField.text)
            }
        }
        activeTextField = nil
    }
}

//MARK:- TableViewCell
class QuestionCell: UITableViewCell {
    
    //IBOutlet
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
