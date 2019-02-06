//
//  ViewController.swift
//  MemeApp
//
//  Created by Nourah on 16/11/2018.
//  Copyright © 2018 Nourah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate {
//UITableViewDataSource,UITableViewDelegate
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
   // @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    //@IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBarBottom: UIToolbar!
    //@IBOutlet weak var toolBarTop: UIToolbar!
    var imagePicker = UIImagePickerController()
//    let sharebuttonn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
//
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    
    
    
    
//    @IBAction func cancelAction(_ sender: Any) {
//        imagePickerView.image = UIImage()
//        topTextField.text = "Top"
//        bottomTextField.text = "Bottom"
//    }
    let memeTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeColor.rawValue: UIColor.black,NSAttributedString.Key.strokeWidth.rawValue : -3.0,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        ] as! [NSAttributedString.Key : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sharebuttonn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        self.navigationItem.rightBarButtonItem = sharebuttonn
        
        bottomTextField.text="Bottom"
        sharebuttonn.isEnabled = false
        topTextField.text="Top"
        
        textFiledsFunction (textField: bottomTextField)
        textFiledsFunction (textField: topTextField)
        
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    func textFiledsFunction (textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
  
    public func textFieldDidBeginEditing(_ textField: UITextField){
        if textField.tag == 1{
            if (textField.text ==  "Top" || textField.text == "Bottom" ){
                topTextField.text = ""
            }
        }
    }
    func textFieldDidEndEditing (_ textField: UITextField) {
        let sharebuttonn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
      self.navigationItem.rightBarButtonItem = sharebuttonn
        if imagePickerView.image != nil{
            if bottomTextField.text != ""{
                if topTextField.text != "" {
                     sharebuttonn.isEnabled = true
                }
            }
            
        }
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = generateMemedImage()
        let activityControl = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        present(activityControl, animated: true, completion: nil)
        
        activityControl.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            self.save(img: memeImage)
        }
    }
    
    
    @IBAction func PickAnImage(_ sender: Any) {
  
        presentImagePickerWith(sourceType: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
   
       
        presentImagePickerWith(sourceType: UIImagePickerController.SourceType.camera)
        
     
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated:true, completion:nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification) }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        
       // toolBarTop.isHidden = true
        toolBarBottom.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
      //  toolBarTop.isHidden = false
        toolBarBottom.isHidden = false
        return memedImage
    }
    
    func save(img: UIImage) {
        let meme = Meme(topTextField.text!, bottomTextField.text!, imagePickerView.image!, img)
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
}
