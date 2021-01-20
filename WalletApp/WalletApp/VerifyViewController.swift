//
//  VerifyViewController.swift
//  WalletApp
//
//  Created by Adila on 10/19/19.
//  Copyright © 2019 Adila. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController , PinTexFieldDelegate {
    func didPressBackspace(textField: PinTextField) {
        switch textField {
        case textTwo:
            textTwo.resignFirstResponder()
            textOne.text = ""
            textOne.isUserInteractionEnabled = true
            textOne.becomeFirstResponder()
            break
        case textThree:
            textTwo.text = ""
            textTwo.isUserInteractionEnabled = true
            textTwo.becomeFirstResponder()
            break
        case textFour:
            textThree.isUserInteractionEnabled = true
            textThree.becomeFirstResponder()
            textThree.text = ""
            break
        case textFive:
            textFour.isUserInteractionEnabled = true
            textFour.becomeFirstResponder()
            textFour.text = ""
            break
        case textSix:
            textFive.isUserInteractionEnabled = true
            textFive.becomeFirstResponder()
            textFive.text = ""
            break
        default:
            break
        }
    }
    
    @IBOutlet weak var textOne: PinTextField!
    @IBOutlet weak var textTwo: PinTextField!
    @IBOutlet weak var textThree: PinTextField!
    @IBOutlet weak var textFour: PinTextField!
    @IBOutlet weak var textFive: PinTextField!
    @IBOutlet weak var textSix: PinTextField!
    @IBOutlet weak var errMsg: UILabel!
    var phonenum : String = ""
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textOne.becomeFirstResponder()
        textTwo.isUserInteractionEnabled = false
        textThree.isUserInteractionEnabled = false
        textFour.isUserInteractionEnabled = false
        textFive.isUserInteractionEnabled = false
        textSix.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
        errMsg.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
        initTyping()
        initBackspaceDelegate()
    }
    @objc func handleTap() {
        textOne.resignFirstResponder()
        view.endEditing(true)
    }
    func initBackspaceDelegate() {
        print("Listener for textfild backspace delegate!")
        textOne.becomeFirstResponder()
        self.textTwo.delegate = self
        self.textThree.delegate = self
        self.textOne.delegate = self
        self.textFour.delegate = self
        self.textFive.delegate = self
        self.textSix.delegate = self
    }
    
    func initTyping() {
        textOne.becomeFirstResponder();
        textOne.addTarget(self, action: #selector(inputChanges),
                          for: UIControl.Event.editingChanged)
        textTwo.addTarget(self, action: #selector(inputChanges),
                          for: UIControl.Event.editingChanged)
        textThree.addTarget(self, action: #selector(inputChanges),
                            for: UIControl.Event.editingChanged)
        textFour.addTarget(self, action: #selector(inputChanges),
                           for:UIControl.Event.editingChanged)
        textFive.addTarget(self, action: #selector(inputChanges),
                           for:UIControl.Event.editingChanged)
        textSix.addTarget(self, action: #selector(inputChanges),
                          for:UIControl.Event.editingChanged)
    }
    @IBAction func resend(_ sender: UIButton) {
        Api.sendVerificationCode(phoneNumber: phonenum) { response, error in
            //          // .. what you want to do with response or error
            //          // .. both response and error can be nil
            self.errMsg.isHidden = true;
        }
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    @objc func inputChanges(textField: UITextField) {
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField{
            case textOne:
                textTwo.isUserInteractionEnabled = true
                textTwo.becomeFirstResponder()
                textOne.isUserInteractionEnabled = false
                //didPressBackspace(textField: pinField)
                break
            case textTwo:
                textThree.isUserInteractionEnabled = true
                textThree.becomeFirstResponder()
                textOne.isUserInteractionEnabled = false
                textTwo.isUserInteractionEnabled = false
                break
                
            case textThree:
                textFour.isUserInteractionEnabled = true
                textFour.becomeFirstResponder()
                textTwo.isUserInteractionEnabled = false
                textOne.isUserInteractionEnabled = false
                textThree.isUserInteractionEnabled = false
                break
                
            case textFour:
                textFive.isUserInteractionEnabled = true
                textFive.becomeFirstResponder()
                textOne.isUserInteractionEnabled = false
                textTwo.isUserInteractionEnabled = false
                textThree.isUserInteractionEnabled = false
                textFour.isUserInteractionEnabled = false
                break
                
            case textFive:
                textSix.isUserInteractionEnabled = true
                textSix.becomeFirstResponder()
                textOne.isUserInteractionEnabled = false
                textTwo.isUserInteractionEnabled = false
                textThree.isUserInteractionEnabled = false
                textFour.isUserInteractionEnabled = false
                textFive.isUserInteractionEnabled = false
                break
            case textSix:
                textSix.isUserInteractionEnabled = true
                textFive.isUserInteractionEnabled = false
                verifyCode()
            default:
                break
            }
        }else if(text?.utf16.count == 0){
            switch textField{
            case textOne:
                textOne.isUserInteractionEnabled = true
                textOne.becomeFirstResponder()
                textTwo.isUserInteractionEnabled = false
                textThree.isUserInteractionEnabled = false
                textFour.isUserInteractionEnabled = false
                textFive.isUserInteractionEnabled = false
                textSix.isUserInteractionEnabled = false
                
            case textTwo:
                textTwo.isUserInteractionEnabled = true
                textOne.becomeFirstResponder()
                textThree.isUserInteractionEnabled = false
                textFour.isUserInteractionEnabled = false
                textFive.isUserInteractionEnabled = false
                textSix.isUserInteractionEnabled = false
                
            case textThree:
                textThree.isUserInteractionEnabled = true
                textTwo.becomeFirstResponder()
                textFour.isUserInteractionEnabled = false
                textFive.isUserInteractionEnabled = false
                textSix.isUserInteractionEnabled = false
                
            case textFour:
                textFour.isUserInteractionEnabled = true
                textThree.becomeFirstResponder()
                textFive.isUserInteractionEnabled = false
                textSix.isUserInteractionEnabled = false
                
                
            case textFive:
                textFive.isUserInteractionEnabled = true
                textFour.becomeFirstResponder()
                textSix.isUserInteractionEnabled = false
                
            case textSix:
                textSix.isUserInteractionEnabled = true
                textFive.isUserInteractionEnabled = true
                textFive.becomeFirstResponder()
            default:
                break;
            }
        }else{
            switch textField{
            case textOne:
                textOne.isUserInteractionEnabled = false
                textTwo.isUserInteractionEnabled = true
                textTwo.becomeFirstResponder()
                break
            case textTwo:
                textTwo.isUserInteractionEnabled = false
                textThree.isUserInteractionEnabled = true
                textThree.becomeFirstResponder()
                break
            case textThree:
                textThree.isUserInteractionEnabled = false
                textFour.isUserInteractionEnabled = true
                textFour.becomeFirstResponder()
                break
                
            case textFour:
                textFour.isUserInteractionEnabled = false
                textFive.isUserInteractionEnabled = true
                textFive.becomeFirstResponder()
                
                break
            case textFive:
                textFive.isUserInteractionEnabled = false
                textSix.isUserInteractionEnabled = true
                textSix.becomeFirstResponder()
                break
            case textSix:
                textSix.isUserInteractionEnabled = false
                if(textSix.text?.count == 1){
                    verifyCode()
                }
                break
            default:
                break;
            }
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 1
    }
    func verifyCode(){
        let codeone = textOne.text ?? ""
        let codetwo = textTwo.text ?? ""
        let codethree = textThree.text ?? ""
        let codefour = textFour.text ?? ""
        let codefive = textFive.text ?? ""
        let codesix = textSix.text ?? ""
        let code = codeone+codetwo+codethree+codefour+codefive+codesix
        Api.verifyCode(phoneNumber: phonenum, code: code) { response, error in
            if(response != nil){
                self.errMsg.isHidden = false
                self.errMsg.text = "Success!"
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.startAnimating()
                self.view.addSubview(self.activityIndicator)
                self.view.isUserInteractionEnabled = false
                Storage.phoneNumberInE164 = self.phonenum
                let authToken = response?["auth_token"] as? String
                Storage.authToken = authToken
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vs = storyboard.instantiateViewController(identifier: "verifiedViewController")
                    let verified = vs as! verifiedViewController
                    //verified.phonenum = self.phonenum
                    self.present(verified, animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }else{
                if(error?.code == "code_expired" ){
                    self.errMsg.isHidden = false;
                    self.errMsg.text = "Your code expired"
                    
                }else if(error?.code == "incorrect_code" ){
                    self.errMsg.isHidden = false;
                    self.errMsg.text = "Incorrect verification code"
                }else{
                    self.errMsg.isHidden = false;
                    self.errMsg.text = "Incorrect verification code"
                }
            }
        }
    }
}

