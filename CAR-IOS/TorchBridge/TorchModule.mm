//
//  TorchModule.m
//  CAR-IOS
//
//  Created by 生广明 on 6/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorchModule.h"


@implementation TorchModule {
 @protected
    torch::jit::script::Module kernel_generation_net;
    torch::jit::script::Module upscale_net;
    Downsampler downsample_net;
    int scale;
    int k_size;
    int offset_unit;
}

//The initWithFileAtPath method is called from the Swift counterpart method. It passes the location of the model file. Because it was Defined in the TorchModule.h and are applied to marco NS_SWIFT_NAME
- (nullable instancetype)initWithFileAtPath:(NSString*)kgn_path usn_path:(NSString*)usn_path scale:(int)scale{
  self = [super init];
  if (self) {
    try {
        self->scale = scale;
        self->k_size = scale * 3 + 1;
        self->offset_unit = scale;
        
        kernel_generation_net = torch::jit::load(kgn_path.UTF8String);
        kernel_generation_net.eval();
        
        downsample_net = Downsampler(self->scale,self->k_size,self->offset_unit);
        
        upscale_net = torch::jit::load(usn_path.UTF8String);
        upscale_net.eval();
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
    //at::Tensor img = torch::from_blob(imageBuffer, {1, 3, 64, 64}, at::kFloat);
      at::Tensor img = torch::rand({1,3,64,64});
      
      torch::autograd::AutoGradMode guard(false);
      //Note: Setting AutoGradMode to false indicates we wish to run inference with our model only (no training).
      at::AutoNonVariableTypeMode non_var_type_mode(true);
      
      auto all_kernels = kernel_generation_net.forward({img}).toTensor();
      auto downscaled_img = downsample_net.forward(img, all_kernels);
      downscaled_img = downscaled_img.clamp(0, 1);
      downscaled_img = downscaled_img.round();
      
      auto reconstructed_img = upscale_net.forward({downscaled_img / 255.0}).toTensor();
      
      float* floatBuffer = reconstructed_img.data_ptr<float>();
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
