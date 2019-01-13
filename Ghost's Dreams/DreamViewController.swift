//
//  DreamViewController.swift
//  Ghost's Dreams
//
//  Created by Smsma Mac on 12/10/18.
//  Copyright © 2018 Samar Khaled. All rights reserved.
//

import UIKit
import os.log

class DreamViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: PlaceHolderTextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    
    let textViewMinHeight : CGFloat = 180
    
    var dream: Dream?
    
    //MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        
        if let dream = dream {
            titleTextField.text = dream.dreamTitle
            if !(dream.dreamDescription)!.isEmpty {
                descriptionTextView.text = dream.dreamDescription
            }
        }
        
        changeSaveButtonStatus()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeSaveButtonStatus()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBarButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: -  UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame = textView.frame
        
        let newHeight = newSize.height > textViewMinHeight ? newSize.height : textViewMinHeight
        newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newHeight)
        self.descriptionTextViewHeightConstraint.constant = newHeight
    }

    //MARK: - Navigation
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
         let isPresentedViewMode = presentingViewController is UINavigationController
        if isPresentedViewMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            os_log("Unsupported navigation type", log: OSLog.default, type: OSLogType.debug)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem , button == saveBarButton  else {
            os_log("Unsupported action", log: OSLog.default, type: OSLogType.debug)
            return
        }
        
        let title = titleTextField.text
        let desc = descriptionTextView.text
        
        dream = Dream(title: title!, description: desc!)
        
    }
    
    //MARK: - Private methods
    
    fileprivate func assignDelegates() {
        
        titleTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    func changeSaveButtonStatus () {
        saveBarButton.isEnabled = !(titleTextField.text ?? "").isEmpty
    }
}

