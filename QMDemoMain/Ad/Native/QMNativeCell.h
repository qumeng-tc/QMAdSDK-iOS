//
//  QMNativeCell.h
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import <UIKit/UIKit.h>

#import <QMAdSDK/QMAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMNativeCell : UITableViewCell

@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) QMNativeAd *nativeAd;

@property (nonatomic, strong) QMNativeAdSlideView *slideView;

- (void)refreshWithData:(QMNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
