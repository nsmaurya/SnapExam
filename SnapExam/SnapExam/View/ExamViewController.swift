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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getStartedView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    var rightBarButton: UIBarButtonItem!
    
    //Variables
    var questionList = [Question]()
    lazy var examInteractor = ExamInteractor.sharedInstance
    let tableSectionQuestionFont = UIFont.boldSystemFont(ofSize: 16.0)
    
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
            self.rightBarButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightBarButtonTapped))
            self.navigationItem.rightBarButtonItem = rightBarButton
            
            //setting up table view
            self.tableSetup()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func rightBarButtonTapped() {
        if self.rightBarButton.title == "Done" {
            self.infoLabel.textColor = UIColor.green
            self.infoLabel.text = "Thank You!!!\n You are done"
            self.tableView.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
        } else {
            var isLastPage = true
            (isLastPage, questionList) = examInteractor.getQuestions()
            if isLastPage {
                self.rightBarButton.title = "Done"
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        if let textHeight = self.questionList[section].question?.height(withConstrainedWidth: UIScreen.main.bounds.size.width - 20.0, font: tableSectionQuestionFont) {
            return textHeight + 30.0
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let textHeight = self.questionList[section].question?.height(withConstrainedWidth: UIScreen.main.bounds.size.width - 20.0, font: tableSectionQuestionFont) {
            let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: textHeight + 30.0))
            headerView.backgroundColor = UIColor.white
            let questionLabel = UILabel(frame: CGRect(x: 10.0, y: 15.0, width: UIScreen.main.bounds.size.width - 20.0, height: textHeight))
            questionLabel.numberOfLines = 0
            questionLabel.font = tableSectionQuestionFont
            questionLabel.text = self.questionList[section].question
            headerView.addSubview(questionLabel)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as? QuestionCell else {
            fatalError("QuestionCell not found...")
        }
        
        cell.questionButton.isHidden = false
        cell.questionTextField.isHidden = true
        cell.questionLabel.isHidden = false
        
        let question = self.questionList[indexPath.section]
        let questionOption = question.questionOptions ?? [QuestionOption]()
        if question.responseType == "singleSelect" || question.responseType == "multiSelect" {/*radio/checkbox*/
            cell.questionLabel.text = questionOption[indexPath.row].text
            cell.questionButton.isSelected = questionOption[indexPath.row].isSelected ?? false
            if question.responseType == "singleSelect" {
                cell.questionButton.setImage(#imageLiteral(resourceName: "radio_unselected"), for: .normal)
                cell.questionButton.setImage(#imageLiteral(resourceName: "radio_selected"), for: .selected)
            } else {
                cell.questionButton.setImage(#imageLiteral(resourceName: "checkbox_unselected"), for: .normal)
                cell.questionButton.setImage(#imageLiteral(resourceName: "checkbox_selected"), for: .selected)
            }
        } else {//textfield
            cell.questionButton.isHidden = true
            cell.questionTextField.isHidden = false
            cell.questionLabel.isHidden = true
            cell.questionTextField.text = questionOption[indexPath.row].text
        }
        return cell
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

