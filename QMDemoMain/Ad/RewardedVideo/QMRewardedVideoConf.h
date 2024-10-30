//
//  QMRewardedVideoDemoViewController.h
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMRewardedVideoConf : NSObject

@property (nonatomic, copy) NSString *slot;
@property (nonatomic, strong) QMRetentionAlertInfo *info;

@end

NS_ASSUME_NONNULL_END
