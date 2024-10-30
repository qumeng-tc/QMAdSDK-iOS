//
//  QMFeedAdCell.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import "QMFeedAdCell.h"

@interface QMFeedAdCell ()

@property (nonatomic, strong) QMFeedAd *feedAd;

@end

@implementation QMFeedAdCell

- (void)configFeedCellWith:(QMFeedAd *)feedAd {
    _feedAd = feedAd;
    
    UIView *adView = [self.contentView viewWithTag:1000];
    [adView removeFromSuperview];
    feedAd.feedView.tag = 1000;
    
    feedAd.feedView.frame = self.contentView.bounds;
    [self.contentView addSubview:feedAd.feedView];
}

@end
