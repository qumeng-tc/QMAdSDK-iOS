//
//  QMNativeVideCell.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import "QMNativeVideoCell.h"

@implementation QMNativeVideoCell

- (void)refreshWithData:(QMNativeAd *)nativeAd {
    UIView *adView = [self.contentView viewWithTag:1000];
    [adView removeFromSuperview];
    if (!nativeAd.relatedView) {
        nativeAd.relatedView = [QMNativeAdRelatedView new];
        nativeAd.relatedView.videoAdView.tag = 1000;
        nativeAd.relatedView.videoAdView.frame = CGRectMake(0, 30, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - 60);
    }
    [self.contentView addSubview:nativeAd.relatedView.videoAdView];
    [super refreshWithData:nativeAd];

}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

@end
