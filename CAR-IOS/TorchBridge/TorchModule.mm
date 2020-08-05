//
//  TorchModule.m
//  CAR-IOS
//
//  Created by 生广明 on 6/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorchModule.h"
#import <LibTorch/LibTorch.h>

@implementation TorchModule {
 @protected
  torch::jit::script::Module _impl;
}

//前面带有减号(-) 的方法为实例方法，必须使用类的实例才可以调用的。对应的有+号， 代表是类的静态方法，不需要实例化即可调用。


//The initWithFileAtPath method is called from the Swift counterpart method. It passes the location of the model file. Because it was Defined in the TorchModule.h and are applied to marco NS_SWIFT_NAME
- (nullable instancetype)initWithFileAtPath:(NSString*)filePath {
  self = [super init]; //???
  if (self) {
    try {
      _impl = torch::jit::load(filePath.UTF8String);
      _impl.eval(); //???
    } catch (const std::exception& exception) {
      NSLog(@"%s", exception.what());
      return nil;
    }
  }
  return self;
}

//The predictImage gets the CVPixelBuffer of the image and converts it into an input tensor of the required shape. We then iterate through the scores of each label and return the index having the highest score back to Swift as the predicted output.
- (NSArray<NSNumber*>*)predictImage:(void*)imageBuffer {
  try {
      //convert the imageBuffer into a tensor
    at::Tensor tensor = torch::from_blob(imageBuffer, {1, 3, 224, 224}, at::kFloat);
    torch::autograd::AutoGradMode guard(false);
    //Note: Setting AutoGradMode to false indicates we wish to run inference with our model only (no training).
    at::AutoNonVariableTypeMode non_var_type_mode(true);//???
    auto outputTensor = _impl.forward({tensor}).toTensor();
    float* floatBuffer = outputTensor.data_ptr<float>();
    if (!floatBuffer) {
      return nil;
    }
    NSMutableArray* results = [[NSMutableArray alloc] init];//？？？
    for (int i = 0; i < 1000; i++) {
      [results addObject:@(floatBuffer[i])];
    }
    return [results copy];
  } catch (const std::exception& exception) {
    NSLog(@"%s", exception.what());
  }
  return nil;
}

@end

