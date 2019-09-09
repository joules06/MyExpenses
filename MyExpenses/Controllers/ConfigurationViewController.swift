//
//  ConfigurationViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import Alamofire
import ChameleonFramework
import RealmSwift
import PopupDialog
import UIKit
import SVProgressHUD

class ConfigurationViewController: UIViewController {
    
    @IBOutlet weak var labelForVersion: UILabel!
    @IBOutlet weak var labelForLastDateOfUpdate: UILabel!
    @IBOutlet weak var buttonForDownloadContent: UIButton!
    @IBOutlet weak var buttonForUploadContent: UIButton!
    @IBOutlet weak var buttonForCategories: UIButton!

    let realm = try! Realm()
    var resultOfCompare: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultStyle(.dark)
        updateAppTheme()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDataForLabels()
        checkCurrentVersion()
        updateAppTheme()
    }
    
    @IBAction func updloadDataTapped(_ sender: UIButton) {
        if resultOfCompare > 0 {
            showPopUpForSync(message: "Synced data is not updated. You will probably loose some data. Do you want to continue?", typeOfAction: .UploadData)
        } else {
            uploadDataToServer()
        }
    }
    
    
    @IBAction func downloadDataTapped(_ sender: UIButton) {
        if resultOfCompare < 0 {
            showPopUpForSync(message: "Data from server is not updated. Do you want to continue?", typeOfAction: .DonwloadData)
        } else {
            donwloadDataFromServer()
        }
    }
    
    //MARK: - Setup view and conrolls
    func updateAppTheme() {
        let primaryColor = UIColor(hexString: GlobalVariables.hexForPrimaryColor)
        let selectedColor = primaryColor
        
        guard let contrastingColor = UIColor(contrastingBlackOrWhiteColorOn:selectedColor, isFlat: true) else {
            return
        }
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : contrastingColor]
        buttonForDownloadContent.backgroundColor = selectedColor
        buttonForUploadContent.backgroundColor = selectedColor
        buttonForCategories.backgroundColor = selectedColor
        
        buttonForDownloadContent.tintColor = UIColor.white
        buttonForUploadContent.tintColor = UIColor.white
        buttonForCategories.tintColor = UIColor.white
    }
    
    //MARK: - Functions to retrive data for configuration and last version
    func getDataForLabels() {
        labelForVersion.text = GlobalUtils.getBundleVersion() ?? ""
        labelForLastDateOfUpdate.text = MyRealmUtils.getLasStringForUpdateInRealm(realm: realm) ?? ""
    }
    
    //MARK: - Functions for Alamofire
    func checkCurrentVersion() {
        SVProgressHUD.show()
        
        var versionCode: Int = 0
        
        if let safeVersionCode = MyRealmUtils.getVersionCodeFromRealm(realm: realm) {
            versionCode = safeVersionCode
        }
        
        let actualTicksRequest = CompareVersionCodeRequest(versionCode: versionCode)
        let encodedObjectRequest = try? JSONEncoder().encode(actualTicksRequest)
        
        do {
            if let safeDecodedObject = encodedObjectRequest {
                //serialize
                let decoded = try JSONSerialization.jsonObject(with: safeDecodedObject, options: [])
                
                //convert to dictionary
                if let dictFromJSON = decoded as? [String:Any] {
                    Alamofire.request(GlobalVariables.urlToSave + (MyRealmUtils.getUserSession(with: realm) ?? ""), method: .post, parameters: dictFromJSON, encoding: JSONEncoding.default).responseJSON {
                        (response) in
                        var message: String = ""
                        var difference = 0
                        switch response.result {
                        case .success:
                            (message, difference) = GlobalUtils.compareVersionCode(realm: self.realm, dataFromRequest: response.data)
                            self.resultOfCompare = difference
                            print(self.resultOfCompare)
                        case .failure:
                            print("error")
                        }
                        SVProgressHUD.dismiss()
                        
                        if !message.isEmpty {
                            self.showPopUp(message: message)
                        }
                        if difference == 0 {
                            self.buttonForUploadContent.isEnabled = false
                            self.buttonForDownloadContent.isEnabled = false
                        } else {
                            self.buttonForUploadContent.isEnabled = true
                            self.buttonForDownloadContent.isEnabled = true
                        }
                        
                    }
                }
            }
        }catch {
            print("error compareTicksFromService \(error)")
        }
    }
    
    func uploadDataToServer() {
        var resultCode: String = ""
        var messageForPoup: String = ""
        
        guard let dictonary = GlobalUtils.convertFromRealmToJson(realm: realm) else {
            return
        }
        
        Alamofire.request(GlobalVariables.urlToSave + (MyRealmUtils.getUserSession(with: realm) ?? ""), method: .put, parameters: dictonary, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    
                    do {
                        var responseObject = UpdateVersionCodeResponse(versionCode: 0, responseCode: "200", responseStatus: "OK")
                        responseObject = try JSONDecoder().decode(UpdateVersionCodeResponse.self, from: data)
                        
                        resultCode = responseObject.responseCode
                        
                        if responseObject.responseCode == "200" {
                            let realmUtils = MyRealmUtils()
                            realmUtils.updateVersionCodeToRealm(newVersionCode: responseObject.versionCode, realm: self.realm)
                        }
                    }catch {
                        print("error unserializing")
                    }
                    
                    print("Data success: \(utf8Text)") // original server data as UTF8 string
                    
                }
            case .failure:
                print("error")
            }
            
            if resultCode == "200" {
                messageForPoup = "Sincronización finalizada con éxito"
            }else {
                messageForPoup = "Hubo un error al sincronizar los datos"
            }
            
            SVProgressHUD.dismiss()
            
            self.showPopUp(message: messageForPoup)
            self.getDataForLabels()
            
            
        }
        
        
    }
    
    func donwloadDataFromServer() {
        
        SVProgressHUD.show()
        
        Alamofire.request(GlobalVariables.urlToSave + (MyRealmUtils.getUserSession(with: realm) ?? ""), method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in
            
            switch response.result {
            case .success:
                //TODO: update version code from server
                GlobalUtils.convertFromJsonToReam(realm: self.realm, data: response.data)
            case .failure:
                print("error")
            }
            
            SVProgressHUD.dismiss()
        }
        getDataForLabels()
    }
    
    //MARK: - Popups
    
    func showPopUp(message: String) {
        let popup = PopupDialog(title: "Comprobar datos", message: message)
        var buttons = [PopupDialogButton]()
        
        
        let okButton = DefaultButton(title: "Ok", dismissOnTap: true) {
            print("okButton")
        }
        
        buttons.append(okButton)
        
        popup.addButtons(buttons)
        popup.transitionStyle = .fadeIn
        popup.buttonAlignment = .horizontal
        
        self.present(popup, animated: true, completion: nil)
    }
    
    
    func showPopUpForSync(message: String, typeOfAction: DownloadUploadData) {
        
        let popup = PopupDialog(title: "Sincronizar datos", message: message)
        var buttons = [PopupDialogButton]()
        
        
        let okButton = DefaultButton(title: "Ok", dismissOnTap: true) {
            print("okButton")
            if typeOfAction == .UploadData {
                self.uploadDataToServer()
            }else {
                self.donwloadDataFromServer()
            }
            
        }
        
        let cancelButton = CancelButton(title: "Cancelar") {
            print("cancel")
        }
        
        buttons.append(okButton)
        buttons.append(cancelButton)
        
        popup.addButtons(buttons)
        popup.transitionStyle = .fadeIn
        popup.buttonAlignment = .horizontal
        
        
        self.present(popup, animated: true, completion: nil)
    }

}
