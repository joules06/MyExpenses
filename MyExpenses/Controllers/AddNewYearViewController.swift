//
//  AddNewYearViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import RealmSwift
import PopupDialog
import UIKit


class AddNewYearViewController: UIViewController {
    @IBOutlet weak var textFieldForYear: UITextField!
    @IBOutlet weak var textFieldForMaxExpense: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var buttonForSaveData: UIButton!
    @IBOutlet weak var buttonForCancelSaveData: UIButton!
    @IBOutlet weak var labelForValidateYear: UILabel!
    @IBOutlet weak var constraintForYearValidation: NSLayoutConstraint!
    @IBOutlet weak var labelForValidateAmount: UILabel!
    @IBOutlet weak var constraintForAmountValidation: NSLayoutConstraint!
    @IBOutlet var allTextFields: [UITextField]!
    
    
    let pickerForYears = UIPickerView()
    var pickerYearsData = [Int]()
    let realm = try! Realm()
    var resultForSavingData = true
    var pickerValueSelected: Bool = false
    var formIsValidWithTextFields: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        createDataForPicker()
        textFieldForYear.inputView = pickerForYears
        addToolBarToPickerView()
        setUpTextFileds()
        addDoneButtonOnKeyboard()
        
        self.textFieldForMaxExpense.keyboardType = .decimalPad
        self.pickerForYears.delegate = self
        self.pickerForYears.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)

    }
    
    func hideCurrentView() {
        if resultForSavingData {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK : - Buttons actions
    
    @IBAction func buttonSaveTapped(_ sender: UIButton) {
        guard let yearInString = textFieldForYear.text else {
            return
        }
        
        guard let maxValueString = textFieldForMaxExpense.text else {
            return
        }
        
        if let maxValueAsDouble = Double(maxValueString) {
            let newYear = Years()
            
            newYear.maximumAmountToSpend = maxValueAsDouble
            newYear.year = yearInString
            
            resultForSavingData = saveDataToRealm(newYear: newYear)

            showPopForAction(message: "Guardado")
            
        }
    }
    
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Functions for picker Data
    func createDataForPicker() {
        //get current year
        //add [-10, 10] years
        
        pickerYearsData = [Int]()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        guard let result = Int(formatter.string(from: date)) else {
            return
        }
        
        let min = result - 10
        var actual = result + 1
        
        while actual >= min {
            pickerYearsData.append(actual)
            
            actual -= 1
        }
        
    }
    
    //MARK: - Function for Tool bar
    func addToolBarToPickerView() {
        MyCustomToolBarForPicker.addToolBarToPickerView(textField: textFieldForYear, okAction: #selector(donePicker), cancelAction: #selector(cancelPicker))
        pickerForYears.backgroundColor = UIColor.white
    }
    
    //MARK: - Functions to customize controls
    func setUpTextFileds() {
        GlobalUtils.addIconToTextField(textField: textFieldForMaxExpense, imageName: "dollar", isLeft: true)
        GlobalUtils.addIconToTextField(textField: textFieldForYear, imageName: "calendar", isLeft: true)
        GlobalUtils.addIconToTextField(textField: textFieldForYear, imageName: "right", isLeft: false)
        
        GlobalUtils.changeHeightForTextField(textField: textFieldForMaxExpense, desiredHeight: 40)
        GlobalUtils.changeHeightForTextField(textField: textFieldForYear, desiredHeight: 40)
        
        GlobalUtils.addBottomBorderToTextField(textField: textFieldForYear)
        GlobalUtils.addBottomBorderToTextField(textField: textFieldForMaxExpense)
        
        constraintForYearValidation.constant = 0
        constraintForAmountValidation.constant = 0
        buttonForSaveData.isEnabled = false
        
        
    }
    
    //MARK: - Functions for buttons and validate form
    @objc func donePicker (sender:UIBarButtonItem) {
//        DispatchQueue.main.async {
//            self.textFieldForYear.resignFirstResponder()
//        }
        self.textFieldForYear.resignFirstResponder()
    }
    
    @objc func cancelPicker (sender:UIBarButtonItem) {
//        DispatchQueue.main.async {
//            self.textFieldForYear.text = ""
//            self.textFieldForYear.resignFirstResponder()
//        }
        self.textFieldForYear.text = ""
        self.textFieldForYear.resignFirstResponder()
        
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textFieldForMaxExpense.inputAccessoryView = doneToolbar
    }
    
    
    @objc func doneButtonAction() {
        textFieldForMaxExpense.resignFirstResponder()
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        for textField in allTextFields {
            // Validate Text Field
            let (valid, _) = validate(textField)
            
            formIsValidWithTextFields = valid
            
            if !valid{
                break
            }
        }
        validateSaveButton()
    }
    
    private func validateSaveButton() {
        // Update Save Button
        buttonForSaveData.isEnabled = (formIsValidWithTextFields && pickerValueSelected)
    }
    
    
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        return (text.count > 0, "You must write a value.")
    }
    
    //MARK: - Functions for Realm
    func saveDataToRealm(newYear: Years) -> Bool {
        var savedCompleted = true
        do{
            try realm.write {
                //realm.add(newYear, update: true)
                realm.add(newYear, update: .modified)
            }
        } catch {
            savedCompleted = false
            print("Error saving data to realm \(error)")
        }
       
        return savedCompleted
    }
    
    //MARK: - Popup
    private func showPopForAction(message: String) {
        
        let popup = PopupDialog(title: "New Year Saved", message: message)
        var buttons = [PopupDialogButton]()
        
        
        let okButton = DefaultButton(title: "Ok", dismissOnTap: true) {
            self.hideCurrentView()
            
        }
        
        buttons.append(okButton)
        
        
        popup.addButtons(buttons)
        popup.transitionStyle = .fadeIn
        popup.buttonAlignment = .horizontal
        
        
        self.present(popup, animated: true, completion: nil)
    }
    
}


extension AddNewYearViewController: UIPickerViewDelegate {
    //MARK: - Functions for UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerYearsData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        pickerValueSelected = true
        validateSaveButton()
        textFieldForYear.text = String(pickerYearsData[row])
    }
}

extension AddNewYearViewController: UIPickerViewDataSource {
    //MARK: - Funcionts for UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerYearsData.count
    }
    
}

extension AddNewYearViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            
        case textFieldForMaxExpense:
            // Validate Text Field
            let (valid, message) = validate(textField)
            
            if !valid {
                // Update Password Validation Label
                self.labelForValidateAmount.text = message
                
            }
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.50, animations: {
                if !valid {
                    self.constraintForAmountValidation.constant = 15
                }else {
                    self.constraintForAmountValidation.constant = 0
                }
            })
            
        default:
            print("nothing")
        }
        
        return true
    }
    
}
