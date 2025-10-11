//
//  QMSplashContainerViewController.m
//  QMAdSDK
//
//  Created by xusheng on 2024/11/11.
//

#import "QMSplashContainerViewController.h"
#import <QMAdSDK/QMAdSDK.h>


@interface QMSplashContainerViewController ()<QMSplashAdDelegate>
@property (nonatomic, strong) QMSplashAd *splashAd;

@end

@implementation QMSplashContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadSplashAd {
    _splashAd = [[QMSplashAd alloc] initWithSlot:self.slot];
    _splashAd.delegate = self;
    [_splashAd loadAdData];
}

- (void)dismiss {
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

// MARK: - QMSplashAdDelegate
- (void)qm_splashAdLoadSuccess:(QMSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 物料加载成功\n");
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [splashAd showSplashViewController:keyWindow.rootViewController];
}

- (void)qm_splashAdLoadFail:(QMSplashAd *)splashAd error:(NSError *)error {
    NSLog(@"【媒体】开屏: 物料加载失败");
}

- (void)qm_splashAdDidShow:(QMSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 曝光");
    // 渲染成功再展示视图控制器
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow.rootViewController addChildViewController:self];
    [keyWindow.rootViewController.view addSubview:self.view];
}

- (void)qm_splashAdDidClick:(QMSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 点击");
}

- (void)qm_splashAdDidClose:(QMSplashAd *)splashAd closeType:(QMSplashAdCloseType)type {
    NSLog(@"【媒体】开屏: 关闭");
    [self dismiss];
}

/// 开屏广告落地页关闭
- (void)qm_splashAdDidCloseOtherController:(QMSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 落地页关闭");
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


