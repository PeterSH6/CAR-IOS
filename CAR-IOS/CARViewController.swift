//
//  CARViewController.swift
//  CAR-IOS
//
//  Created by 生广明 on 6/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

import UIKit

class CARViewController: UIViewController {

    //MARK: - View
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnHolderView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var loaderWithContrains: NSLayoutConstraint!
    @IBOutlet weak var btnDownScale: UIButton!
    @IBOutlet weak var btnShow: UIButton!

    //MARK: - ModelProvider
    var DownscaledImage: UIImage!
    var ReconstructedImage: UIImage!

    let KGN_Path: String = Bundle.main.path(forResource: "kgn", ofType: "pt")!
    let USN_Path: String = Bundle.main.path(forResource: "usn", ofType: "pt")!
    let PAD_Path: String = Bundle.main.path(forResource: "pad2d", ofType: "pt")!
    let Scale: Int = 4
    private lazy var modelProvider = ModelProvider(kgn_path: KGN_Path, usn_path: USN_Path, pad2d_path: PAD_Path, scale: Int32(Scale))

    var imagePicker = UIImagePickerController() //系统函数
    var isProcessing: Bool = false {
        didSet { //didSet属性观察
            self.btnDownScale.isEnabled = !isProcessing
            self.btnShow.isEnabled = !isProcessing
            self.isProcessing ? self.loader.startAnimating() : self.loader.stopAnimating()
            self.loaderWithContrains.constant = self.isProcessing ? 20.0 : 0.0
            UIView.animate(withDuration: 0.3) {
                self.isProcessing ? self.btnDownScale.setTitle("Processing...", for: .normal) : self.btnDownScale.setTitle("Down Scale", for: .normal)
                self.view.layoutIfNeeded()//???
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isProcessing = false
        self.btnDownScale.titleLabel?.textAlignment = .center
        self.btnDownScale.superview!.layer.cornerRadius = 4
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
        guard let image = self.imageView.image else {
            print("Select an image")
            return
        }

        self.isProcessing = true
        do {
            let result = try modelProvider.predict(inputImage: image)

            var reconstructedPixelBuffer: [UInt8] = []
            var downscaledPixelBuffer: [UInt8] = []

            var outputIndex = 0
            let reconstructedPixelCount: Int = Int(result.reconstructedHeight * result.reconstructedWidth) * 3
            let downscaledPixelCount: Int = reconstructedPixelCount / (Scale << 2)

            for _ in 0..<reconstructedPixelCount {
                let value: UInt8? = result.pixelBuffer![outputIndex] as? UInt8
                reconstructedPixelBuffer.append(value!)
                outputIndex += 1
            }

            for _ in 0..<downscaledPixelCount {
                let value: UInt8? = result.pixelBuffer![outputIndex] as? UInt8
                downscaledPixelBuffer.append(value!)
                outputIndex += 1
            }

            let downscaledImage = UIImage(pixelBuffer: downscaledPixelBuffer, width: result.reconstructedWidth / Scale, height: result.reconstructedHeight / Scale)
            let reconstructedImage = UIImage(pixelBuffer: reconstructedPixelBuffer, width: result.reconstructedWidth, height: result.reconstructedHeight)

            self.DownscaledImage = downscaledImage
            self.ReconstructedImage = reconstructedImage
        }
        catch {
            print(error)
        }
        self.isProcessing = false
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller
        guard let UI = segue.destination as? OutputViewController else {return}
        do {
            UI.DownscaledImage = self.DownscaledImage
            UI.ReconstructedImage = self.ReconstructedImage
        } catch {
            print("show error!")
        }
//        if let outputView = storyboard?.instantiateViewController(withIdentifier: "Output") as? OutputViewController {
//            outputView.DownScaleImageView.image = self.DownscaledImage
//        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CARViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = pickedImage
            self.imageView.backgroundColor = .clear
        }
        self.dismiss(animated: true)
    }
}
