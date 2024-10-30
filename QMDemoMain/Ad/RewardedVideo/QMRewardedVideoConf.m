//
//  QMRewardedVideoDemoViewController.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QMAdSDK/QMAdSDK-Swift.h>
#import <Masonry.h>

#import "QMRewardedVideoConf.h"
#import "MBProgressHUD+QMAD.h"
#import "QMBaseConf.h"
#import "ViewController.h"

@interface QMRewardedVideoConf ()<QMRewardedVideoAdDelegate, QMBaseConf>

@property (nonatomic, strong) QMRewardedVideoAd *rewardedVideoAd;

@end

@implementation QMRewardedVideoConf

- (void)qm_loadAd:(NSDictionary *)item {
    NSString *slotID = item[@"slot"];
    _rewardedVideoAd = [[QMRewardedVideoAd alloc] initWithSlot:slotID];
    _rewardedVideoAd.retentionInfo = self.info;
    /// 广告点击自动关闭，不需要可以不传
    _rewardedVideoAd.adClickToCloseAutomatically = adClickToCloseAutomatically();
    _rewardedVideoAd.delegate = self;
    [_rewardedVideoAd loadAdData];
}

// MARK: - QMInterstitialAdDelegate
- (void)qm_rewardedVideoAdLoadSuccess:(QMRewardedVideoAd *)rewardedVideoAd {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [rewardedVideoAd showRewardedVideoViewInRootViewController:keyWindow.rootViewController];
}

- (void)qm_rewardedVideoAdLoadFail:(QMRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    NSLog(@"【媒体】激励视频: 请求失败");
    [MBProgressHUD showMessage:@"媒体激励视频: 请求失败"];
}

- (void)qm_rewardedVideoAdDidShow:(QMRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 曝光");
}

- (void)qm_rewardedVideoAdDidClick:(QMRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 点击");
}

- (void)qm_rewardedVideoAdDidRewarded:(QMRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 激励成功已获得奖励");
}

- (void)qm_rewardedVideoAdDidCloseOtherController:(QMRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 关闭落地页");
}

- (void)qm_rewardedVideoAdDidClose:(QMRewardedVideoAd *)rewardedVideoAd closeType:(QMRewardedVideoAdCloseType)type {
    NSLog(@"【媒体】激励视频: 关闭广告");
}

/// 激励视频广告播放开始
- (void)qm_rewardedVideoAdDidStart:(QMRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 播放开始");
}

/// 激励视频广告播放暂停
- (void)qm_rewardedVideoAdDidPause:(QMRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 播放暂停");
}
/// 激励视频广告播放继续
- (void)qm_rewardedVideoAdDidResume:(QMRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 播放继续");
}

- (void)qm_rewardedVideoAdVideoDidPlayComplection:(QMRewardedVideoAd *)rewardedVideoAd rewarded:(BOOL)isRewarded {
    NSLog(@"【媒体】激励视频: 视频播放完成");
}

- (void)qm_rewardedVideoAdVideoDidPlayFinished:(QMRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error rewarded:(BOOL)isRewarded {
    NSLog(@"【媒体】激励视频: 视频播放失败");
    [MBProgressHUD showMessage:@"媒体激励视频: 视频播放失败"];
}

@end
