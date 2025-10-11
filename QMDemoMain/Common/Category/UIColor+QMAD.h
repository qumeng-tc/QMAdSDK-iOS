//
//  UIColor+QMAD.h
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (QMAD)

+ (UIColor *)qm_colorWithHex:(nonnull NSString *)hex;
- (NSString *)qm_hexString;

+ (UIImage *)qm_imageWith:(NSString *)hexString size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
