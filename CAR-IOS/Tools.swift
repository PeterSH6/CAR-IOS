////
////  Tools.swift
////  CAR-IOS
////
////  Created by 钟源 on 2020/8/22.
////  Copyright © 2020 生广明. All rights reserved.
////
//
//// 这里只是把源码搬下来了，由于对swift和UIImage不太熟悉，有些bug还没改，可以在该网站中查询调用方法
//// 源码来源：https://gist.github.com/palmerc/a626b447c62f472dbae6
//
//
//import Foundation
//import UIKit
//import CoreGraphics
//
//func imageFromPixelValues(pixelValues: [UInt8]?, width: Int, height: Int) -> CGImage?
//{
//    var imageRef: CGImage?
//    if pixelValues != nil {
//        let imageDataPointer = UnsafeMutablePointer<UInt8>(mutating: pixelValues!)
//
//        let colorSpaceRef = CGColorSpaceCreateDeviceRGB() //CGColorSpaceCreateDeviceGray()
//
//        let bitsPerComponent = 8
//        let bytesPerPixel = 4
//        let bitsPerPixel = bytesPerPixel * bitsPerComponent
//        let bytesPerRow = bytesPerPixel * width
//        let totalBytes = height * bytesPerRow
//
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
//            .union(.ByteOrderDefault)
//        let providerRef = CGDataProviderCreateWithData(nil, imageDataPointer, totalBytes, nil)
//        imageRef = CGImageCreate(width,
//            height,
//            bitsPerComponent,
//            bitsPerPixel,
//            bytesPerRow,
//            colorSpaceRef,
//            bitmapInfo,
//            providerRef,
//            nil,
//            false,
//            CGColorRenderingIntent.RenderingIntentDefault)
//    }
//
//    return imageRef
//}
