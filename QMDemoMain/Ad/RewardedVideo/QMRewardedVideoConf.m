//
//  QMRewardedVideoDemoViewController.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QMAdSDK/QMAdSDK.h>
#import <Masonry/Masonry.h>

#import "QMRewardedVideoConf.h"
#import "QMBaseConf.h"
#import "ViewController.h"
#import "Tool.h"

#import "MBProgressHUD+QMAD.h"

@interface QMRewardedVideoConf ()<QMRewardedVideoAdDelegate, QMBaseConf>

@property (nonatomic, strong) QMRewardedVideoAd *rewardedVideoAd;

@end

@implementation QMRewardedVideoConf

- (void)qm_loadAd:(NSDictionary *)item {
    NSString *slotID = item[@"slot"];
    _rewardedVideoAd = [[QMRewardedVideoAd alloc] initWithSlot:slotID];
    _rewardedVideoAd.retentionInfo = self.info;
    _rewardedVideoAd.delegate = self;
    [_rewardedVideoAd loadAdData];
}

// MARK: - QMInterstitialAdDelegate
- (void)qm_rewardedVideoAdLoadSuccess:(QMRewardedVideoAd *)rewardedVideoAd {
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //    当前页面如果是present vc 使用keyWindow.rootViewController会失效
    //    [rewardedVideoAd showRewardedVideoViewInRootViewController:keyWindow.rootViewController];
    
    // 检查广告有效性
    if (checkAdValid()) {
        [rewardedVideoAd isValid];
    }
    
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QMLog(@"【媒体】激励视频:: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (rewardedVideoAd.meta.getECPM >= price.integerValue) {
        QMLog(@"【媒体】激励视频:: 趣盟竞价成功，趣盟价格：%ld", (long)rewardedVideoAd.meta.getECPM);
        [rewardedVideoAd winNotice:price.integerValue];
    } else {
        QMLog(@"【媒体】激励视频:: 趣盟竞价失败，趣盟价格：%ld", (long)rewardedVideoAd.meta.getECPM);
        [rewardedVideoAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        return;
    }
    
    [rewardedVideoAd showRewardedVideoViewInRootViewController:Tool.topViewController];
}

- (void)qm_rewardedVideoAdLoadFail:(QMRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    QMLog(@"【媒体】激励视频: 请求失败");
    [MBProgressHUD showMessage:@"媒体激励视频: 请求失败"];
}

- (void)qm_rewardedVideoAdDidShow:(QMRewardedVideoAd *)rewardedVideoAd {
    QMLog(@"【媒体】激励视频: 曝光");
    [MBProgressHUD showMessage:@"媒体激励视频: 曝光"];
}

- (void)qm_rewardedVideoAdDidClick:(QMRewardedVideoAd *)rewardedVideoAd {
    QMLog(@"【媒体】激励视频: 点击");
    [MBProgressHUD showMessage:@"媒体激励视频: 点击"];
}

- (void)qm_rewardedVideoAdDidRewarded:(QMRewardedVideoAd *)rewardedVideoAd {
    QMLog(@"【媒体】激励视频: 激励成功已获得奖励");
    [MBProgressHUD showMessage:@"激励成功已获得奖励"];
}

- (void)qm_rewardedVideoAdDidCloseOtherController:(QMRewardedVideoAd *)rewardedVideoAd {
    QMLog(@"【媒体】激励视频: 关闭落地页");
}

- (void)qm_rewardedVideoAdDidClose:(QMRewardedVideoAd *)rewardedVideoAd closeType:(QMRewardedVideoAdCloseType)type {
    QMLog(@"【媒体】激励视频: 关闭广告");
    self.rewardedVideoAd = nil;
}

/// 激励视频广告播放开始
- (void)qm_rewardedVideoAdDidStart:(QMRewardedVideoAd *)rewardedVideoAd {
    QMLog(@"【媒体】激励视频: 播放开始");
}

/// 激励视频广告播放暂停
- (void)qm_rewardedVideoAdDidPause:(QMRewardedVideoAd *)rewardedVideoAd {
    QMLog(@"【媒体】激励视频: 播放暂停");
}
/// 激励视频广告播放继续
- (void)qm_rewardedVideoAdDidResume:(QMRewardedVideoAd *)rewardedVideoAd {
    QMLog(@"【媒体】激励视频: 播放继续");
}

- (void)qm_rewardedVideoAdVideoDidPlayComplection:(QMRewardedVideoAd *)rewardedVideoAd rewarded:(BOOL)isRewarded {
    QMLog(@"【媒体】激励视频: 视频播放完成");
}

- (void)qm_rewardedVideoAdVideoDidPlayFinished:(QMRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error rewarded:(BOOL)isRewarded {
    QMLog(@"【媒体】激励视频: 视频播放失败");
    [MBProgressHUD showMessage:@"媒体激励视频: 视频播放失败"];
}

@end
