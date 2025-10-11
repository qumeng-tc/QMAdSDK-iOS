//
//  QMInterstitialDemoViewController.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QMAdSDK/QMAdSDK.h>
#import <Masonry/Masonry.h>

#import "QMInterstitialConf.h"
#import "QMBaseConf.h"
#import "ViewController.h"
#import "Tool.h"

#import "MBProgressHUD+QMAD.h"

// 插屏
@interface QMInterstitialConf ()<QMInterstitialAdDelegate, QMBaseConf>

@property (nonatomic, strong) QMInterstitialAd *interstitialAd;

@end

@implementation QMInterstitialConf

- (void)qm_loadAd:(NSDictionary *)item {
    NSString *slotID = item[@"slot"];
    _interstitialAd = [[QMInterstitialAd alloc] initWithSlot:slotID];
    
    /// 广告点击自动关闭，不需要可以不传
    _interstitialAd.adClickToCloseAutomatically = adClickToCloseAutomatically();
    _interstitialAd.delegate = self;
    [_interstitialAd loadAdData];
}

// MARK: - QMInterstitialAdDelegate
- (void)qm_interstitialAdLoadSuccess:(QMInterstitialAd *)interstitialAd {
    QMLog(@"【媒体】插屏: 请求成功");
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //    当前页面如果是present vc 使用keyWindow.rootViewController会失效
    //    [interstitialAd showInterstitialViewInRootViewController: keyWindow.rootViewController];
    
    // 检查广告有效性
    if (checkAdValid()) {
        [interstitialAd isValid];
    }
    
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QMLog(@"【媒体】插屏: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (interstitialAd.meta.getECPM >= price.integerValue) {
        QMLog(@"【媒体】插屏: 趣盟竞价成功，趣盟价格：%ld", (long)interstitialAd.meta.getECPM);
        [interstitialAd winNotice:price.integerValue];
    } else {
        QMLog(@"【媒体】插屏: 趣盟竞价失败，趣盟价格：%ld", (long)interstitialAd.meta.getECPM);
        [interstitialAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        return;
    }
    [interstitialAd showInterstitialViewInRootViewController: Tool.topViewController];
}

- (void)qm_interstitialAdLoadFail:(QMInterstitialAd *)interstitialAd error:(NSError *)error {
    QMLog(@"【媒体】插屏: 请求失败");
    self.interstitialAd = nil;
    [MBProgressHUD showMessage:@"媒体插屏: 请求失败"];
}

- (void)qm_interstitialAdDidShow:(QMInterstitialAd *)interstitialAd {
    QMLog(@"【媒体】插屏: 曝光");
    [MBProgressHUD showMessage:@"媒体插屏: 曝光"];
}

- (void)qm_interstitialAdDidClick:(QMInterstitialAd *)interstitialAd {
    QMLog(@"【媒体】插屏: 点击");
    [MBProgressHUD showMessage:@"媒体插屏: 点击"];
}

- (void)qm_interstitialAdDidCloseOtherController:(QMInterstitialAd *)interstitialAd {
    QMLog(@"【媒体】插屏: 关闭落地页");
}

- (void)qm_interstitialAdDidClose:(QMInterstitialAd *)interstitialAd closeType:(QMInterstitialAdCloseType)type {
    self.interstitialAd = nil;
    QMLog(@"【媒体】插屏: 关闭广告");
}

/// 插屏广告视频播放开始
- (void)qm_interstitialAdDidStart:(QMInterstitialAd *)rewardedVideoAd {
    QMLog(@"【媒体】插屏: 视频播放开始");
}
/// 插屏广告视频播放暂停
- (void)qm_interstitialAdDidPause:(QMInterstitialAd *)rewardedVideoAd {
    QMLog(@"【媒体】插屏: 视频播放暂停");
}
/// 插屏广告视频播放继续
- (void)qm_interstitialAdDidResume:(QMInterstitialAd *)rewardedVideoAd {
    QMLog(@"【媒体】插屏: 视频播放继续");
}

- (void)qm_interstitialAdVideoDidPlayComplection:(QMInterstitialAd *)interstitialAd {
    QMLog(@"【媒体】插屏: 视频播放完成");
}

- (void)qm_interstitialAdVideoDidPlayFinished:(QMInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    QMLog(@"【媒体】插屏: 视频播放异常");
    [MBProgressHUD showMessage:@"媒体插屏: 视频播放异常"];
}
 

@end
