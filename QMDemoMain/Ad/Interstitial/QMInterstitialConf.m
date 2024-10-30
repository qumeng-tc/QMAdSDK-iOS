//
//  QMInterstitialDemoViewController.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QMAdSDK/QMAdSDK-Swift.h>
#import <Masonry.h>

#import "QMInterstitialConf.h"
#import "MBProgressHUD+QMAD.h"
#import "QMBaseConf.h"
#import "ViewController.h"

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
    NSLog(@"【媒体】插屏: 请求成功");
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [interstitialAd showInterstitialViewInRootViewController: keyWindow.rootViewController];
}

- (void)qm_interstitialAdLoadFail:(QMInterstitialAd *)interstitialAd error:(NSError *)error {
    NSLog(@"【媒体】插屏: 请求失败");
    [MBProgressHUD showMessage:@"媒体插屏: 请求失败"];
}

- (void)qm_interstitialAdDidShow:(QMInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 曝光");
}

- (void)qm_interstitialAdDidClick:(QMInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 点击");
    [MBProgressHUD showMessage:@"媒体插屏: 点击"];
}

- (void)qm_interstitialAdDidCloseOtherController:(QMInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 关闭落地页");
}

- (void)qm_interstitialAdDidClose:(QMInterstitialAd *)interstitialAd closeType:(QMInterstitialAdCloseType)type {
    NSLog(@"【媒体】插屏: 关闭广告");
}

/// 插屏广告视频播放开始
- (void)qm_interstitialAdDidStart:(QMInterstitialAd *)rewardedVideoAd {
    NSLog(@"【媒体】插屏: 视频播放开始");
}
/// 插屏广告视频播放暂停
- (void)qm_interstitialAdDidPause:(QMInterstitialAd *)rewardedVideoAd {
    NSLog(@"【媒体】插屏: 视频播放暂停");
}
/// 插屏广告视频播放继续
- (void)qm_interstitialAdDidResume:(QMInterstitialAd *)rewardedVideoAd {
    NSLog(@"【媒体】插屏: 视频播放继续");
}

- (void)qm_interstitialAdVideoDidPlayComplection:(QMInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 视频播放完成");
}

- (void)qm_interstitialAdVideoDidPlayFinished:(QMInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"【媒体】插屏: 视频播放异常");
    [MBProgressHUD showMessage:@"媒体插屏: 视频播放异常"];
}
 

@end
