//
//  LoginViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import Alamofire
import PopupDialog
import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var buttonForLogin: UIButton!
    @IBOutlet weak var buttonForSingUp: UIButton!
    @IBOutlet weak var textFieldForEmail: UITextField!
    @IBOutlet weak var textFieldForPassword: UITextField!
    @IBOutlet var allTextFields: [UITextField]!
    
    var formIsValidWithTextFields: Bool = false
    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFieldForEmail.delegate = self
        textFieldForPassword.delegate = self
        textFieldForEmail.keyboardType = .emailAddress
        textFieldForPassword.isSecureTextEntry = true
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
        updateAppTheme()
        setUpTextFileds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - Functions for appearance
    fileprivate func setUpTextFileds() {
        GlobalUtils.addIconToTextField(textField: textFieldForEmail, imageName: "email", isLeft: false)
        GlobalUtils.addIconToTextField(textField: textFieldForPassword, imageName: "password", isLeft: false)
        
        GlobalUtils.changeHeightForTextField(textField: textFieldForPassword, desiredHeight: 40)
        GlobalUtils.changeHeightForTextField(textField: textFieldForEmail, desiredHeight: 40)
       
        GlobalUtils.addBottomBorderToTextField(textField: textFieldForPassword)
        GlobalUtils.addBottomBorderToTextField(textField: textFieldForEmail)
        
    }
    
    fileprivate func updateAppTheme() {
        let primaryColor = UIColor(hexString: GlobalVariables.hexForPrimaryColor)
        let selectedColor = primaryColor
        
        navigationController?.navigationBar.barTintColor = selectedColor
        guard let contrastingColor = UIColor(contrastingBlackOrWhiteColorOn:selectedColor, isFlat: true) else{
            return
        }
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : contrastingColor]
        buttonForLogin.backgroundColor = selectedColor
        buttonForSingUp.backgroundColor = selectedColor
        
        buttonForLogin.tintColor = UIColor.white
        buttonForSingUp.tintColor = UIColor.white
    }
    
    //MARK: - Textfield validations
    @objc private func textDidChange(_ notification: Notification) {
        for textField in allTextFields {
            let valid = validate(textField)
            
            formIsValidWithTextFields = valid
            
            if !valid {
                break
            }
        }
        validateSaveButton()
    }
    
    fileprivate func validate(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        
        return text.count > 0
    }
    
    fileprivate func validateSaveButton() {
        // Update Save Button
        buttonForLogin.isEnabled = formIsValidWithTextFields
    }
    
    //MARK: - Subscriptions
    func suscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Popup alert
    private func showPopForAction(message: String) {
        let popup = PopupDialog(title: "Add new Expense", message: message)
        var buttons = [PopupDialogButton]()
        
        
        let okButton = DefaultButton(title: "Ok", dismissOnTap: true) {
           
        }
        
        buttons.append(okButton)
        
        
        popup.addButtons(buttons)
        popup.transitionStyle = .fadeIn
        popup.buttonAlignment = .horizontal
        
        
        self.present(popup, animated: true, completion: nil)
    }
    
    //MARK: - Functions for Alamofire
    func getTokenFromLogin() {
        guard let email = textFieldForEmail.text else {
            return
        }
        
        guard let password = textFieldForPassword.text else {
            return
        }
        SVProgressHUD.show()
        
        let login = SessionRequest(email: email, password: password)
        let encodedObjectRequest = try? JSONEncoder().encode(login)
        do {
            if let safeDecodedObject = encodedObjectRequest {
                //serialize
                let decoded = try JSONSerialization.jsonObject(with: safeDecodedObject, options: [])
                
                //convert to dictionary
                if let dictFromJSON = decoded as? [String:Any] {
                    do {
                        Alamofire.request(GlobalVariables.sessionURL, method: .post, parameters: dictFromJSON, encoding: JSONEncoding.default).responseJSON { (response) in
                            switch response.result {
                            case .success:
                                var responseObject = SessionResponse(token: "", responseCode: "", responseStatus: "")
                                responseObject = try JSONDecoder().decode(SessionResponse.self, from: data)
                                
                            case .failure:
                                print("error")
                            }
                            SVProgressHUD.dismiss()
                        }
                    } catch {
                        print("error compareTicksFromService \(error)")
                    }
                    
                    
                }
            }
        } catch {
            print("error compareTicksFromService \(error)")
        }
        
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        
        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var textToShow = ""
        switch textField {
            
        case textFieldForEmail:
            // Validate Text Field
            let valid = validate(textField)
            
            if !valid {
                // Update Password Validation Label
                textToShow = "You must provide and email"
                
            }
            // Show/Hide Password Validation Label
            if !valid {
                showPopForAction(message: textToShow)
            }
            
        case textFieldForPassword:
            let valid = validate(textField)
            
            if !valid {
                // Update Password Validation Label
                textToShow = "You must provide a password"
                
            }
            // Show/Hide Password Validation Label
            if !valid {
                showPopForAction(message: textToShow)
            }
            
        default:
            break
        }
        
        activeField?.resignFirstResponder()
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = GlobalUtils.getKeyboardHeight(notification)
        let distanceToBottom = self.view.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
        let collapseSpace = keyboardHeight - distanceToBottom
        
        if collapseSpace < 0 {
            // no collapse
            return
        }
        
        view.frame.origin.y = -(keyboardHeight + 500)
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
}
