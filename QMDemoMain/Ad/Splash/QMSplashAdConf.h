//
//  QMInterstitialDemoViewController.h
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>
#import "QMBaseConf.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QMSplashAdConfDelegate <NSObject>
@optional
// 关闭开屏
- (void)splashAdDidClose;
@end

@interface QMSplashAdConf : NSObject <QMBaseConf>
@property (nonatomic, weak) id<QMSplashAdConfDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
