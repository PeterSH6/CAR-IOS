//
//  ModelProvider.swift
//  CAR-IOS
//
//  Created by 生广明 on 7/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

import Foundation
import UIKit

class ModelProvider {

    var CARModel: TorchModule

    init(kgn_path: String, usn_path: String, pad2d_path: String, scale: Int32) {
//        guard let fileAtPath : String = Bundle.main.path(forResource: modelName, ofType: "pt"),let model = TorchModule(kgn_path: fileAtPath) else{
        guard let model = TorchModule.init(kgn_path: kgn_path) else {
            fatalError("Cannot find the model")
        }
        
        model.LoadUsnFile(usn_path: usn_path)
        model.LoadPad2dFile(pad2d_path: pad2d_path)
        model.LoadScale(scale: scale)
        self.CARModel = model
    }

// Provide a more abstracted prediction method
// Allowing for an UIImage input of any size
// and returning the result as an UIImage of same size
    func predict(inputImage: UIImage) throws -> UIImage
    {
        //0. resize the UIImage so that all the Image can be put into the model

        //1. Transfer the UIImage to the PixelBuffer(CVPixelBuffer or just []

        //2. Feed the PixelBuffer into the model and get the Kernel

        //3. Use the Kernel to process the Image and get the pixelBuffer

        //4. Transfer the pixelBuffer back to the UIImage and return

        //只是为了防止报错
        let image = UIImage()
        return image

    }
}

//class ModelProvider{
//    
//    var model : TorchModule
//    
////    init(modelName : String) {
////        guard let fileAtPath : String = Bundle.main.path(forResource: modelName, ofType: "pt"),let model = TorchModule(fileAtPath: fileAtPath) else{
////            fatalError("Cannot find the model")
////        }
////        self.model = model
////    }
//    
//    // Provide a more abstracted prediction method
//    // Allowing for an UIImage input of any size
//    // and returning the result as an UIImage of same size
//    func predict(inputImage : UIImage) throws -> UIImage
//    {
//        //0. resize the UIImage so that all the Image can be put into the model
//        
//        //1. Transfer the UIImage to the PixelBuffer(CVPixelBuffer or just []
//        
//        //2. Feed the PixelBuffer into the model and get the Kernel
//        
//        //3. Use the Kernel to process the Image and get the pixelBuffer
//        
//        //4. Transfer the pixelBuffer back to the UIImage and return
//        
//        //只是为了防止报错
//        let image = UIImage()
//        return image
//        
//    }
//}
