//
//  ErrorType.swift
//  CAR-IOS
//
//  Created by 生广明 on 7/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

import Foundation

public enum ErrorType : Error{
    case unknown
    case assetPathError
    case modelError
    case resizeError
    case kernelGenerationError
    case pixelBufferError
    case downScalingError
}

extension ErrorType: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .assetPathError:
            return "Model file not found"
        case .modelError:
            return "Model error"
        case .resizeError:
            return "Resizing failed"
        case .pixelBufferError:
            return "Pixel Buffer conversion failed"
        case .kernelGenerationError:
            return "kernel Generation failed"
        case .downScalingError:
            return "Down Scaling - (Kernel Process) failed"
        }
    }
}
