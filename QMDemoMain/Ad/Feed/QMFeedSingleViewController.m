//
//  QMFeedSingleViewController.m
//  QMAdSDK
//
//  Created by xusheng on 2024/11/21.
//

#import "QMFeedSingleViewController.h"

#import <QMAdSDK/QMAdSDK.h>
#import <Masonry/Masonry.h>

#import "ViewController.h"

#import "MBProgressHUD+QMAD.h"

@interface QMFeedSingleViewController () <QMFeedAdDelegate>

@property (nonatomic, strong) QMFeedAd *feedAd;

@end

@implementation QMFeedSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedAd = [[QMFeedAd alloc] initWithSlot:self.slot];
    ///  固定宽度高度自适应
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.feedAd.customSize = CGSizeMake(width - 40, 0);
    self.feedAd.delegate = self;
    [self.feedAd loadAdData];
    
        
    // Do any additional setup after loading the view.
}

- (void)setLayoutSubview {
//    self.feedAd.feedView.frame = CGRectMake(0, 200, self.view.frame.size.width, 400);
    [self.view addSubview:self.feedAd.feedView];
    [self.feedAd.feedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(self.feedAd.feedView.frame.size);
    }];
    
//    [self.feedAd.feedView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(-20);
//        make.height.mas_equalTo(200);
//    }];
}

// MARK: - QMFeedAdDelegate
- (void)qm_feedAdLoadSuccess:(QMFeedAd *)feedAd {
    
    // 检查广告有效性
    if (checkAdValid()) {
        [feedAd isValid];
    }
    
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QMLog(@"【媒体】信息流:: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (feedAd.meta.getECPM >= price.integerValue) {
        QMLog(@"【媒体】信息流: 趣盟竞价成功，趣盟价格：%ld", (long)feedAd.meta.getECPM);
        [feedAd winNotice:price.floatValue];
    } else {
        QMLog(@"【媒体】信息流: 趣盟竞价失败，趣盟价格：%ld", (long)feedAd.meta.getECPM);
        [feedAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        return;
    }
    
    
    NSInteger getECPM = feedAd.meta.getECPM;
    QMLog(@"【媒体】信息流: 物料加载成功 viewSize: %@", @(feedAd.feedView.frame.size));
    [self setLayoutSubview];
}

- (void)qm_feedAdLoadFail:(QMFeedAd *)feedAd error:(NSError *)error {
    QMLog(@"【媒体】信息流: 物料加载失败");
}

- (void)qm_feedAdDidShow:(QMFeedAd *)feedAd {
    QMLog(@"【媒体】信息流: 曝光");
    [MBProgressHUD showMessage:@"信息流: 曝光"];
}

- (void)qm_feedAdDidClick:(QMFeedAd *)feedAd {        
    QMLog(@"【媒体】信息流:  点击");
    [MBProgressHUD showMessage:@"信息流: 点击"];
}

- (void)qm_feedAdDidClose:(QMFeedAd *)feedAd {
    QMLog(@"【媒体】信息流:  关闭");
    [MBProgressHUD showMessage:@"信息流: 关闭"];
}

- (void)qm_feedAdDidCloseOtherController:(QMFeedAd *)feedAd {
    QMLog(@"【媒体】信息流:  关闭落地页");
    [MBProgressHUD showMessage:@"信息流: 关闭落地页"];
}

/// 信息流视频播放开始
- (void)qm_feedAdDidStart:(QMFeedAd *)feedAd {
    QMLog(@"【媒体】信息流: 视频播放开始");
}

/// 信息流视频播放暂停
- (void)qm_feedAdDidPause:(QMFeedAd *)feedAd {
    QMLog(@"【媒体】信息流: 视频播放暂停");
}

/// 信息流视频播放继续
- (void)qm_feedAdDidResume:(QMFeedAd *)feedAd {
    QMLog(@"【媒体】信息流: 视频播放继续");
}

/// 信息流视频播放完成
- (void)qm_feedAdVideoDidPlayComplection:(QMFeedAd *)feedAd {
    QMLog(@"【媒体】信息流: 视频播放完成");
}

/// 信息流视频播放异常
- (void)qm_feedAdVideoDidPlayFinished:(QMFeedAd *)feedAd didFailWithError:(NSError *)error {
    QMLog(@"【媒体】信息流: 视频播放异常");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
