//
//  UIImage+Helper.swift
//  CAR-IOS
//
//  Created by 生广明 on 7/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    //TODO and UIGraphicsImagRendererFormat what the hell is that
    func resize(to newSize: CGSize, scale: CGFloat = 1) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        let image = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        return image
    }

    //TODO
    //May be another way to normalize
    func normalized() -> [Float32]? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        let w = cgImage.width
        let h = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * w
        let bitsPerComponent = 8
        //将rawBytes初始化为0 长度为image展开后的Bytes
        var rawBytes: [UInt8] = [UInt8](repeating: 0, count: w * h * 4)
        rawBytes.withUnsafeMutableBytes { ptr in
            if let cgImage = self.cgImage,
                let context = CGContext(data: ptr.baseAddress,
                    width: w,
                    height: h,
                    bitsPerComponent: bitsPerComponent,
                    bytesPerRow: bytesPerRow,
                    space: CGColorSpaceCreateDeviceRGB(),
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
                let rect = CGRect(x: 0, y: 0, width: w, height: h)
                context.draw(cgImage, in: rect)
            }
        }
        var normalizedBuffer: [Float32] = [Float32](repeating: 0, count: w * h * 3)
        // normalize the pixel buffer
        // see https://pytorch.org/hub/pytorch_vision_resnet/ for more detail
        for i in 0 ..< w * h {
            normalizedBuffer[i] = Float32(rawBytes[i * 4 + 0])
            normalizedBuffer[w * h + i] = Float32(rawBytes[i * 4 + 1])
            normalizedBuffer[w * h * 2 + i] = Float32(rawBytes[i * 4 + 2])
        }
        return normalizedBuffer
    }

    convenience init?(pixelBuffer: [UInt8], width: Int, height: Int) {
        guard width > 0 && height > 0 else { return nil }
        
        var pixels: [PixelData] = .init(repeating: .init(a: 0, r: 0, g: 0, b: 0), count: width * height)
        for index in pixels.indices {
            pixels[index].a = 255
            pixels[index].r = pixelBuffer[pixels.count * 0 + index]
            pixels[index].g = pixelBuffer[pixels.count * 1 + index]
            pixels[index].b = pixelBuffer[pixels.count * 2 + index]
        }
        
        var data = pixels
        guard let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout<PixelData>.size) as CFData)
            else { return nil }
        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * MemoryLayout<PixelData>.size,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent)
            else { return nil }
        self.init(cgImage: cgim)
    }
}
