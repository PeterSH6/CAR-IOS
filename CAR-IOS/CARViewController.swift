//
//  CARViewController.swift
//  CAR-IOS
//
//  Created by 生广明 on 6/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

import UIKit

class CARViewController: UIViewController{

   //MARK: - View
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnHolderView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var loaderWithContrains: NSLayoutConstraint!
    @IBOutlet weak var btnDownScale: UIButton!
    
    @IBOutlet weak var btnShow: UIButton!
    //MARK: - ModelProvider
    //private lazy var modelProvider = ModelProvider(modelName: "kgn")
    
    var DownScaleImage : UIImage!
    var UpScaleImage : UIImage!
    
    var imagePicker = UIImagePickerController() //系统函数
    
    var isProcessing : Bool = false {
        didSet{ //didSet属性观察
            self.btnDownScale.isEnabled = !isProcessing
            self.btnShow.isEnabled = !isProcessing
            self.isProcessing ? self.loader.startAnimating() : self.loader.stopAnimating()
            self.loaderWithContrains.constant = self.isProcessing ? 20.0 : 0.0
            UIView.animate(withDuration: 0.3) {
                self.isProcessing ? self.btnDownScale.setTitle("Processing...", for: .normal) : self.btnDownScale.setTitle("Down Scale",for: .normal)
                self.view.layoutIfNeeded()//???
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isProcessing = false
        
        self.btnDownScale.titleLabel?.textAlignment = .center
        self.btnDownScale.superview!.layer.cornerRadius = 4
        
        /*
         Value of optional type 'UIView?' must be unwrapped to refer to member 'layer' of wrapped base type 'UIView'
         
         Chain the optional using '?' to access member 'layer' only for non-'nil' base values
         
         Force-unwrap using '!' to abort execution if the optional value contains 'nil'
         */
    }
    
    //MARK: - Action
    
    @IBAction func importPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true)
        } else {
            print("Photo Library not available")
        }
    }
    
    
    @IBAction func applyDownScale(_ sender: Any) {
        guard let image = self.imageView.image else{
            print("Select an image")
            return
        }
        
        self.isProcessing = true
        
//        do{
//            let DownScaleImage : UIImage = try self.modelProvider.predict(inputImage: image)
//            //maybe use another view to contain the output image
//            self.imageView.image = DownScaleImage
//            self.isProcessing = false
//        }
//        catch{
//            self.isProcessing = false
//        }

        
        
    
            
        /*
         self.isProcessing = true
         self.process(input: image) { filteredImage, error in
             self.isProcessing = false
             if let filteredImage = filteredImage {
                 self.imageView.image = filteredImage
             } else if let error = error {
                 self.showError(error)
             } else {
                 self.showError(NSTError.unknown)
             }
         }
         
         **/
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller
        let UI = segue.destination as! OutputViewController;
        UI.DownScaleImageView.image = self.DownScaleImage
        UI.UpScaleImageView.image = self.UpScaleImage
    }
    
}


    // MARK: - UIImagePickerControllerDelegate
    extension CARViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.dismiss(animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                self.imageView.image = pickedImage
                self.imageView.backgroundColor = .clear
            }
            self.dismiss(animated: true)
        }
        
    }
