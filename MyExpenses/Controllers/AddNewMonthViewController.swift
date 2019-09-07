//
//  AddNewMonthViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import ChameleonFramework
import PopupDialog
import RealmSwift
import UIKit

class AddNewMonthViewController: UIViewController {
    @IBOutlet weak var textFieldForExpense: UITextField!
    @IBOutlet weak var textFieldForCategory: UITextField!
    @IBOutlet weak var textFieldForDescription: UITextField!
    @IBOutlet weak var textFieldForDate: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var buttonForSaveData: UIButton!
    @IBOutlet weak var buttonForCancelSaveData: UIButton!
    @IBOutlet weak var dateLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var allTextFields: [UITextField]!
    @IBOutlet weak var labelForDateValidation: UILabel!
    @IBOutlet weak var labelForAmountValidation: UILabel!

    let realm = try! Realm()
    
    var categories: Results<CategoryForExpense>?
    let pickerForCategory = UIPickerView()
    
    var selectedYear: Years?
    var monthItems : Results<Months>?
    
    var resultForSavingData = true
    let outsideMonthColor = UIColor(hexString: "ffffff")
    let monthColor = UIColor(hexString: GlobalVariables.hexForSecondColor)
    let selectedMonthColor = UIColor(hexString: GlobalVariables.hexForThirdColor)
    
    var selectedDateFromCalendar = Date()
    var pickerValueSelected: Bool = false
    var formIsValidWithTextFields: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldForDate.delegate = self
        textFieldForDate.inputView = UIView()
        textFieldForExpense.keyboardType = .decimalPad
        
        addToolBarToPickerView()
        
        setUpTextFileds()
        
        getMonthDetailsForYear()
        prePoluateCategoriesController()
        setupDataForCategoriesPickerView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldForCategory.inputView = pickerForCategory
        self.pickerForCategory.delegate = self
        self.pickerForCategory.dataSource = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func savedTapped(_ sender: UIButton) {
        guard let amountSpent = textFieldForExpense.text else {
            return
        }
        
        guard let amountSpentInDobule = Double(amountSpent) else {
            return
        }
        
        guard let description = textFieldForDescription.text else {
            return
        }
        
        guard let category = textFieldForCategory.text else {
            return
        }
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedDateFromCalendar)
        let day = calendar.component(.day, from: selectedDateFromCalendar)
        
        let newMonth = Months()
        
        newMonth.day = day
        newMonth.month = month
        newMonth.amountSpent = amountSpentInDobule
        newMonth.monthForDisplay = convertMonthInIntToSting(month: month)
        newMonth.amountSpent = amountSpentInDobule
        newMonth.creditCardType = ""
        newMonth.commets = description
        
        let predicate = NSPredicate(format: "name = %@", category)
        if let category = realm.objects(CategoryForExpense.self).filter(predicate).first{
            newMonth.categoryOfExpense = category
        }
        
        resultForSavingData = saveDataToRealm(newMonth: newMonth)
        
        showPopForAction(message: "Guardado")
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Data for UIKit elements
    fileprivate func getMonthDetailsForYear() {
        monthItems = selectedYear?.months.sorted(byKeyPath: "month", ascending: true)
    }
    
    fileprivate func prePoluateCategoriesController() {
        //try to know if pre populate is already done
        let realm = try! Realm()
        
        let results = MyRealmUtils.getConfigurationVariable(with: realm, id: 1)
        
        if results.count == 0 {
            //preopulate and create variable
            GlobalUtils.prepopulateCategoriesForExpense(with: realm)
            
            MyRealmUtils.addOrUpdateVariableForConfiguration(with: 1, value: "pre-categories", realm: realm)
        }
    }
    
    fileprivate func setupDataForCategoriesPickerView() {
        categories = realm.objects(CategoryForExpense.self)
    }
    
    
    //MARK: - Functions for setup textfields
    fileprivate func setUpTextFileds() {
        GlobalUtils.addIconToTextField(textField: textFieldForExpense, imageName: "dollar", isLeft: true)
        GlobalUtils.addIconToTextField(textField: textFieldForDescription, imageName: "comments", isLeft: true)
        GlobalUtils.addIconToTextField(textField: textFieldForCategory, imageName: "check-list", isLeft: true)
        GlobalUtils.addIconToTextField(textField: textFieldForCategory, imageName: "right", isLeft: false)
        GlobalUtils.addIconToTextField(textField: textFieldForDate, imageName: "calendar", isLeft: true)
        
        GlobalUtils.changeHeightForTextField(textField: textFieldForExpense, desiredHeight: 40)
        GlobalUtils.changeHeightForTextField(textField: textFieldForDescription, desiredHeight: 40)
        GlobalUtils.changeHeightForTextField(textField: textFieldForCategory, desiredHeight: 40)
        
        GlobalUtils.addBottomBorderToTextField(textField: textFieldForExpense)
        GlobalUtils.addBottomBorderToTextField(textField: textFieldForDescription)
        GlobalUtils.addBottomBorderToTextField(textField: textFieldForCategory)
        GlobalUtils.addBottomBorderToTextField(textField: textFieldForDate)
        
        dateLabelHeightConstraint.constant = 0
        amountLabelHeightConstraint.constant = 0
        buttonForSaveData.isEnabled = false
        
        addDoneButtonOnKeyboard()
    }
    
    fileprivate func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textFieldForExpense.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        textFieldForExpense.resignFirstResponder()
    }
    
    
    //MARK: - Functions for Pickerview
    func addToolBarToPickerView() {
        MyCustomToolBarForPicker.addToolBarToPickerView(textField: textFieldForCategory, okAction: #selector(donePickerForCategory), cancelAction: #selector(cancelPickerForCategory))
        
        pickerForCategory.backgroundColor = UIColor.white
    }
    
    
    @objc func donePickerForCategory (sender:UIBarButtonItem) {
        self.textFieldForCategory.resignFirstResponder()
    }
    
    
    @objc func cancelPickerForCategory (sender:UIBarButtonItem) {
        self.textFieldForCategory.text = ""
        self.textFieldForCategory.resignFirstResponder()
    }
    
    //MARK: - Textfield validations
    @objc private func textDidChange(_ notification: Notification) {
        for textField in allTextFields {
            let (valid, _) = validate(textField)
            
            formIsValidWithTextFields = valid
            
            if !valid {
                break
            }
        }
        validateSaveButton()
    }
    
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        return (text.count > 0, "Debes agregar un valor.")
    }
    
    fileprivate func validateSaveButton() {
        // Update Save Button
        buttonForSaveData.isEnabled = (formIsValidWithTextFields && pickerValueSelected)
    }
    
    //MARK: - General funtcions
    fileprivate func convertMonthInIntToSting(month: Int) -> String {
        var monthInString = ""
        
        switch month {
        case 1:
            monthInString = "January"
        case 2:
            monthInString = "February"
        case 3:
            monthInString = "March"
        case 4:
            monthInString = "April"
        case 5:
            monthInString = "May"
        case 6:
            monthInString = "June"
        case 7:
            monthInString = "July"
        case 8:
            monthInString = "August"
        case 9:
            monthInString = "September"
        case 10:
            monthInString = "October"
        case 11:
            monthInString = "November"
        case 12:
            monthInString = "December"
        default:
            break
        }
        
        return monthInString
    }
    
    private func showPopForAction(message: String) {
        let popup = PopupDialog(title: "Agregar nuevo mes", message: message)
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
    
    
    func hideCurrentView() {
        if resultForSavingData {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Functions for Realm
    fileprivate func saveDataToRealm(newMonth: Months) -> Bool {
        var savedCompleted = true
        if let currentYear = selectedYear {
            do {
                try realm.write {
                    currentYear.months.append(newMonth)
                }
            } catch {
                savedCompleted = false
                print("Error saving data to realm \(error)")
            }
        } else {
            savedCompleted = false
        }
        
       
        return savedCompleted
    }
}

extension AddNewMonthViewController: UIPickerViewDelegate {
    //MARK: - Functions for UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories?[row].name ?? "Category"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let value = categories?[row].name {
            textFieldForCategory.text = value
        }
        
        pickerValueSelected = true
        validateSaveButton()
    }
}

extension AddNewMonthViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return categories?.count ?? 1
    }
}

extension AddNewMonthViewController: getDateDelegate {
    func selectedDate(date: String, selected: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        selectedDateFromCalendar = selected
        textFieldForDate.text = formatter.string(from: selected)
    }
}

extension AddNewMonthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            
        case textFieldForDate:
            // Validate Text Field
            let (valid, message) = validate(textField)
            
            if !valid {
                // Update Password Validation Label
                self.labelForDateValidation.text = message
                
            }
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.50, animations: {
                if !valid {
                    self.dateLabelHeightConstraint.constant = 15
                }else {
                    self.dateLabelHeightConstraint.constant = 0
                }
            })
            
        default:
            print("nothing")
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            
        case textFieldForDate:
            // Validate Text Field
            let popUpController = storyboard?.instantiateViewController(withIdentifier: "PopUpCalendarViewController") as! PopUpCalendarViewController
            popUpController.selectedYear = selectedYear
            popUpController.modalTransitionStyle = .crossDissolve
            popUpController.modalPresentationStyle = .overFullScreen
            popUpController.delegate = self
            
            self.present(popUpController, animated: true, completion: nil)
            
        default:
            print("nothing")
        }
        
        return true
    }
    
}

