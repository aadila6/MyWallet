    //
    //  ViewController.swift
    //  WalletApp
    //
    //  Created by Adila on 10/7/19.
    //  Copyright © 2019 Adila. All rights reserved.
    //
    
    import UIKit
    import PhoneNumberKit
    
    class ViewController: UIViewController , UITextFieldDelegate{
        let phoneNumberKit = PhoneNumberKit()
        @IBOutlet weak var inputNumber: PhoneNumberTextField!
        @IBOutlet weak var checkRes: UILabel!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        //var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        override func viewDidLoad() {
            super.viewDidLoad()
            //guard let windowScene = (scene as? UIWindowScene) else { return }
           
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
            view.addGestureRecognizer(tap)
            checkRes.isHidden = true
            activityIndicator.hidesWhenStopped = true
            if Storage.authToken != nil{
                let numberwhole = Storage.phoneNumberInE164
                let num = numberwhole?.dropFirst(2)
                inputNumber.text = String(num ?? "")
            }
        }
        
        @objc func handleTap() {
            inputNumber.resignFirstResponder()
            view.endEditing(true)
        }
        
        @IBAction func clearBtn(_ sender: UIButton) {
            inputNumber.text = ""
            checkRes.isHidden = true
        }
        
        @IBAction func VerifyBtn(_ sender: UIButton) {
            print("Verify pressed")
            do {
                let phoneNumber = try phoneNumberKit.parse(inputNumber.text!)
                let _ = try phoneNumberKit.parse(inputNumber.text!, withRegion: "US", ignoreType: true)
                let phone = phoneNumberKit.format(phoneNumber, toType: .e164)
                print("Valid number, sent message")
                inputNumber.text = phoneNumberKit.format(phoneNumber, toType: .national)
                checkRes.text = "Valid"
                checkRes.textColor = UIColor.green
                checkRes.isHidden = false
                if Storage.authToken != nil, Storage.phoneNumberInE164 == phone {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vs = storyboard.instantiateViewController(identifier: "verifiedViewController")
                    let verified = vs as! verifiedViewController
                    self.present(verified, animated: true, completion: nil)
                }else{
                    Api.sendVerificationCode(phoneNumber: phone) { response, error in
                        
                    }
                    activityIndicator.hidesWhenStopped = true
                    self.activityIndicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    view.addSubview(activityIndicator)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self.view.isUserInteractionEnabled = true
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "VerifyViewController")
                        let verify = vc as! VerifyViewController
                        verify.phonenum = phone
                        self.navigationController?.pushViewController(verify, animated: true)
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
            catch {
                print("Invalid numbers, print error")
                if(inputNumber.text! == ""){
                    checkRes.textColor = UIColor.red
                    checkRes.text = "Empty input"
                    print("Empty input")
                }else{
                    checkRes.textColor = UIColor.red
                    checkRes.text = "Invalid number"
                    print("Invalid number")
                }
                inputNumber.text = ""
                checkRes.isHidden = false
            }
        }
        
        
    }
    
