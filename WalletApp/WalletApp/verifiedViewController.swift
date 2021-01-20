//
//  verifiedViewController.swift
//  WalletApp
//
//  Created by Adila on 10/20/19.
//  Copyright © 2019 Adila. All rights reserved.
//

import UIKit

class verifiedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var nameTxt: UITextField!
    var user:Wallet?
    @IBOutlet weak var addNewPopup: UIView!
    //var tapGesture = UITapGestureRecognizer()
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newName: UITextField!
    var nametext:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewPopup.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.nameTxt.delegate = self
        self.nameTxt.text = Storage.phoneNumberInE164 ?? ""
        self.retrieveAPI()
        self.tableView.allowsSelection = true
    }
    
    func retrieveAPI(){
        Api.user() { response, error in
            if let err = error {
                print("Error: \(err)")
            } else {
            self.user = Wallet.init(data: response ?? ["name": "dila"], ifGenerateAccounts: false)
            Api.setAccounts(accounts: self.user?.accounts ?? []){ response, error in
            }
            self.user?.phoneNumber = Storage.phoneNumberInE164 ?? ""
            let jObject = response?["user"]  as! [String : Any]
            let getName = jObject["name"] ?? ""
            let strName = "\(getName)"
            let filter = String(strName.filter { !" \n\t\r".contains($0) })
            if (filter == "" || filter.isEqual("<null>")) {
                self.nameTxt.text = Storage.phoneNumberInE164
            } else {
                self.nameTxt.text = strName
            }
            self.user?.phoneNumber = Storage.phoneNumberInE164 ?? ""
            self.amount.text = String(format:"%0.02f", self.user?.totalAmount ?? 0.0)
            self.amount.isUserInteractionEnabled = false
            self.tableView.reloadData()
            }
        }
    }
    @IBAction func touchNameField(_ sender: Any) {
        nameTxt.becomeFirstResponder()
        
    }
    
    @IBAction func cancelPopup(_ sender: UIButton) {
        newName.text = ""
        addNewPopup.isHidden = true;
        view.endEditing(true)
    }
    @IBAction func confirmAddNew(_ sender: UIButton) {
        let nname = newName.text
        var newAccountName: String
        if nname == "" {
            let defName = "Account " + String((user?.accounts.count ?? 0)+1)
            newAccountName = defName
        }else{
            newAccountName = nname ?? "NIL NAME"
        }
        guard let wallet = user else {
            return
        }
        Api.addNewAccount(wallet: wallet, newAccountName: newAccountName){ response, error in
            if let err = error {
                print("Error: \(err)")
            } else {
            self.retrieveAPI()
            }
        }
        
        newName.resignFirstResponder()
        newName.text = ""
        addNewPopup.isHidden = true
    }
    //popup view setting
    @IBAction func addAccountBtn(_ sender: UIBarButtonItem) {
        addNewPopup.isHidden=false
        newName.becomeFirstResponder()
    }
    
    @objc func handleTap() {
        nameTxt.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTap()
        changeName()
        view.endEditing(true)
        return true
    }
    
    func changeName() {
        let temp = nameTxt.text ?? ""
        let filteredText = String(temp.filter { !" \n\t\r".contains($0) })
        if filteredText != "" {
            nameTxt.text = filteredText
            Api.setName(name: filteredText){ response, error in
                if let err = error {
                    print("Error: \(err)")
                } else {
                self.retrieveAPI()
                }
            }
        } else {
            nameTxt.text = "Enter Username"
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = storyboard.instantiateViewController(identifier: "ViewNavigate")
        let verified = vs as! UINavigationController
        verified.modalPresentationStyle = .fullScreen
        self.present(verified, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.accounts.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Generating Account ROW: ", indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") ?? UITableViewCell(style: .default, reuseIdentifier: "accountCell")
        let moneyAmout = String(format:"%0.02f", user?.accounts[indexPath.row].amount ?? 999.999)
        let name = self.user?.accounts[indexPath.row].name ?? "lala"
        cell.textLabel?.text = "\(String(describing: name))             \(moneyAmout)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Selected Account ROW: ", indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AccountViewController")
        let account = vc as! AccountViewController
        account.modalPresentationStyle = .fullScreen
        account.accountNumber = indexPath.row
        present(account, animated: true, completion: nil)
    }
}



