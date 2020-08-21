//
//  TorchModule.h
//  CAR-IOS
//
//  Created by 生广明 on 6/8/2020.
//  Copyright © 2020 生广明. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject

//NS_SWIFT_NAME allows us to provide full Swift names for their Objective-C counterparts. So now, we can execute the Objective-C methods using the Swift functions assigned in the macros.

//NS_UNAVAILABLE macro basically tells the compiler not to export that class, function or instance to Swift.

<<<<<<< HEAD
- (nullable instancetype)initWithKgnFile:(NSString*)kgn_path
    NS_SWIFT_NAME(init(kgn_path:))NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)LoadUsnFile:(NSString*)usn_path NS_SWIFT_NAME(LoadUsnFile(usn_path:));
- (nullable instancetype)LoadPad2dFile:(NSString*)pad2d_path NS_SWIFT_NAME(LoadPad2dFile(pad2d_path:));
- (nullable instancetype)LoadScale:(int)scale NS_SWIFT_NAME(LoadScale(scale:));
=======
- (nullable instancetype)initWithFileAtPath:(NSString*)kgn_path usn_path:(NSString*)usn_path scale:(int)scale
NS_SWIFT_NAME(init(kgn_path:, usn_path:, scale:))NS_DESIGNATED_INITIALIZER;
>>>>>>> d5de6b64a61bbbd7053de304009383a893555383
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (nullable NSArray<NSNumber*>*)predictImage:(void*)imageBuffer NS_SWIFT_NAME(predict(image:));

@end

NS_ASSUME_NONNULL_END

