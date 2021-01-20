//
//  AccountViewController.swift
//  WalletApp
//
//  Created by Adila on 11/2/19.
//  Copyright © 2019 Adila. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var accountNumber : Int = 0
    var user:Wallet?
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var transferPopup: UIView!
    var accountTotalCount: Int = 0
    var selectANum: Int = 0
    var transferAmount: Double = 0.0
    var depositAmount : Double = 0.0
    var withdrawAmount : Double = 0.0
    @IBOutlet weak var transferTextfield: UITextField!
    @IBOutlet weak var selectPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        transferPopup.isHidden = true
        //Retrieve Data from API
        retrieveData()
    }
    func retrieveData(){
        Api.user() { response, error in
            if let err = error {
                print("Error: \(err)")
            } else {
            self.user = Wallet.init(data: response ?? ["name": "dila"], ifGenerateAccounts: false)
            self.accountName.text = (self.user?.accounts[self.accountNumber].name)
            self.amount.text = String(format:"%0.02f", self.user?.accounts[self.accountNumber].amount ?? 0)
            self.accountTotalCount = self.user?.accounts.count ?? 0
            }
        }
    }
    
    func backToHomeView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = storyboard.instantiateViewController(identifier: "verifiedViewController")
        let verified = vs as! verifiedViewController
        verified.modalPresentationStyle = .fullScreen
        self.present(verified, animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        backToHomeView()
        
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        transferPopup.isHidden = true
        transferTextfield.text = ""
    }
    @IBAction func transferInit(_ sender: UIButton) {
        let toAccoountNum = self.selectANum
        let fromAccount = self.accountNumber
        guard let wallet = user else {
            return
        }
        guard let amountText = transferTextfield.text else{
            print("fail to get input amount!!!")
            return
        }
        self.transferAmount = Double(amountText) ?? 0.0
        print("Transfer amount: ", self.transferAmount)
        let curAmount = wallet.accounts[self.accountNumber].amount
        if self.transferAmount > curAmount{
            self.transferAmount = curAmount
        }
        Api.transfer(wallet: wallet, fromAccountAt: fromAccount, toAccountAt: toAccoountNum, amount: self.transferAmount) { response, error in
            if let err = error {
                print("Error: \(err)")
            } else {
            self.retrieveData()
            }
        }
        transferPopup.isHidden = true
        view.endEditing(true)
        transferTextfield.text = ""
    }
    
    @IBAction func depositBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Deposit", message: "Please Enter The Amount ", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.keyboardType = UIKeyboardType.decimalPad
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak alertController] _ in
                guard let amountText = textField.text else{
                    print("fail to get input amount!!!")
                    return
                }
                self.depositAmount = Double(amountText) ?? 1314.520
                guard let wallet = self.user else {
                    return
                }
                Api.deposit(wallet: wallet, toAccountAt: self.accountNumber, amount: self.depositAmount) { response, error in
                    if let err = error {
                        print("Error: \(err)")
                    } else {
                    self.retrieveData()
                    print("Deposit amount here:  ", self.depositAmount)
                    }
                }
            }
            alertController.addAction(confirmAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func WithdrawBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Withdraw", message: "Please Enter The Amount ", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.keyboardType = UIKeyboardType.decimalPad
            //MARK: Keyboard popup
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak alertController] _ in
                guard let amountText = textField.text else{
                    print("fail to get input amount!!!")
                    return
                }
                self.withdrawAmount = Double(amountText) ?? 1314.520
                guard let wallet = self.user else {
                    return
                }
                let curAmount = wallet.accounts[self.accountNumber].amount
                if self.withdrawAmount > curAmount{
                    self.withdrawAmount = curAmount
                }
                Api.withdraw(wallet: wallet, fromAccountAt: self.accountNumber, amount: self.withdrawAmount){ response, error in
                    if let err = error {
                        print("Error: \(err)")
                    } else {
                    self.retrieveData()
                    print("Withdraw amount here:  ", self.withdrawAmount)
                    }
                }
            }
            alertController.addAction(confirmAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func transferBtn(_ sender: UIButton) {
        transferPopup.isHidden = false
        selectPicker.dataSource = self
        selectPicker.delegate = self
        transferTextfield.keyboardType = UIKeyboardType.decimalPad
        selectPicker.reloadAllComponents()
        
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        guard let wallet = user else {
            return
        }
        print("Before remove: ", wallet.accounts.count)
        Api.removeAccount(wallet: wallet, removeAccountat: accountNumber){ response, error in
            //print("Printing error writing new account back to API:",error)
            if let err = error {
                print("Error: \(err)")
            } else {
                self.backToHomeView()
            }
        }
        print("After remove: ", wallet.accounts.count)
        //self.backToHomeView()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //let count =  self.user?.accounts.count
        //print("number of the count: ",count)
        return accountTotalCount
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let name = self.user?.accounts[row].name ?? "Account"
        let row = pickerView.selectedRow(inComponent: 0)
        self.selectANum = row
        return "\(String(describing: name))"
    }
    
}
