//
//  TorchModule.m
//  CAR-IOS
//
//  Created by 生广明 on 6/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

#import "TorchModule.h"
#import "Downsampler.h"
//#import <LibTorch/LibTorch.h>

@implementation TorchModule {
 @protected
    torch::jit::script::Module kernel_generation_net;
    torch::jit::script::Module upscale_net;
    int scale;
    int k_size;
    int offset_unit;
    NSString* pad2d_path;
}

//The initWithFileAtPath method is called from the Swift counterpart method. It passes the location of the model file. Because it was Defined in the TorchModule.h and are applied to marco NS_SWIFT_NAME
- (nullable instancetype)initWithKgnFile:(NSString*)kgn_path{
  self = [super init];
  if (self) {
    try {
        kernel_generation_net = torch::jit::load(kgn_path.UTF8String);
        kernel_generation_net.eval();
    } catch (const std::exception& exception) {
      NSLog(@"%s", exception.what());
      return nil;
    }
  }
  return self;
}

- (nullable instancetype)LoadUsnFile:(NSString*)usn_path{
    try{
        upscale_net = torch::jit::load(usn_path.UTF8String);
        upscale_net.eval();
    } catch (const std::exception& exception) {
        NSLog(@"%s", exception.what());
        return nil;
    }
    return self;
}

- (nullable instancetype)LoadPad2dFile:(NSString*)pad2d_path{
    try {
        self->pad2d_path = pad2d_path;
    } catch (const std::exception& exception) {
      NSLog(@"%s", exception.what());
      return nil;
    }
  return self;
}

- (nullable instancetype)LoadScale:(int)scale{
    try {
        self->scale = scale;
        self->k_size = scale * 3 + 1;
        self->offset_unit = scale;
    } catch (const std::exception& exception) {
      NSLog(@"%s", exception.what());
      return nil;
    }
    return self;
}

//The predictImage gets the CVPixelBuffer of the image and converts it into an input tensor of the required shape. We then iterate through the scores of each label and return the index having the highest score back to Swift as the predicted output.
- (NSArray<NSNumber*>*)predictImage:(void*)imageBuffer {
  try {
      //convert the imageBuffer into a tensor
      //at::Tensor img = torch::from_blob(imageBuffer, {1, 3, 64, 64}, at::kFloat);
      at::Tensor img = torch::rand({1,3,64,64});
      //std::cout<<img;
      //std::cout<<img;
      
      img = img.to(torch::kFloat); // 255.0;
      //img = img.unsqueeze(0);   // 增加一维，如果上方生成的img已经有4个维度，就注释掉这句
      
      torch::autograd::AutoGradMode guard(false);
      //Note: Setting AutoGradMode to false indicates we wish to run inference with our model only (no training).
      at::AutoNonVariableTypeMode non_var_type_mode(true);
      
      auto all_kernels = kernel_generation_net.forward({ img }).toTensor();
      auto downscaled_img = Downsampler::forward(img, all_kernels, scale, k_size, offset_unit, self->pad2d_path.UTF8String);
      
      downscaled_img = downscaled_img.clamp(0, 1);
      downscaled_img = torch::round(downscaled_img * 255);
      
      auto reconstructed_img = upscale_net.forward({ downscaled_img / 255.0 }).toTensor();
      
      reconstructed_img = reconstructed_img.clamp(0, 1) * 255;  // 缩放至0-255之间
      reconstructed_img = reconstructed_img.round();    // 取整

      std::cout<<reconstructed_img;
      reconstructed_img = reconstructed_img.to(torch::kFloat);
      reconstructed_img = reconstructed_img.squeeze();  // 清除第一个通道
      
      downscaled_img = downscaled_img.to(torch::kFloat);
      downscaled_img = downscaled_img.squeeze();
      
      // 此处生成的reconstructed和downscaled img都为3个维度，分别是channel, height, width
      // 如果需要为了满足imagebuffer的需要进行更改，请调用transpose更改各维度的顺序
      
      float* reconstructed_img_buffer = reconstructed_img.data_ptr<float>();
      float* downscaled_img_buffer = downscaled_img.data_ptr<float>();
      
      if (!reconstructed_img_buffer || !downscaled_img_buffer) {
          return nil;
      }
      
      NSMutableArray* results = [[NSMutableArray alloc] init];  // array 初始化
      for (int i = 0; i < reconstructed_img.size(0) * reconstructed_img.size(1) * reconstructed_img.size(2); i++) {
          [results addObject:@(reconstructed_img_buffer[i])];
      }
      
      for (int i = 0; i < downscaled_img.size(0) * downscaled_img.size(1) * downscaled_img.size(2); i++){
          [results addObject:@(downscaled_img_buffer[i])];
      }
      
      // 这里将reconstructed_img和downscale_img直接进行拼接，作为一个一维Float32数组返回
      // 将buffer转为UImage时注意，reconstructed_img在前，downscale_img在后
      return [results copy];
    } catch (const std::exception& exception) {
        NSLog(@"%s", exception.what());
    }
    return nil;
}

@end
