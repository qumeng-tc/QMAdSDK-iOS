//
//  QMSplashWindow.h
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/26.
//

#import <UIKit/UIKit.h>
#import <QMAdSDK/QMAdSDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN


@interface QMSplashNativeView : UIView
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIButton *actionBtn;
- (instancetype)initWithSplashNativeAd:(QMSplashNativeAd *)splashNativeAd;
@end

NS_ASSUME_NONNULL_END
