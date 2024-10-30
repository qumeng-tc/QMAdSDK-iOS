//
//  QMNativeCell.h
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import <UIKit/UIKit.h>
#import <QMAdSDK/QMAdSDK-Swift.h>
//#import <AnyThinkNative/AnyThinkNative.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMNativeCell : UITableViewCell
@property (nonatomic, strong) QMNativeAd *nativeAd;
- (void)refreshWithData:(QMNativeAd *)nativeAd; 

// TopOn 数据展示
//- (void)refreshWithOffer:(ATNativeAdOffer *)offer;

@end

NS_ASSUME_NONNULL_END
