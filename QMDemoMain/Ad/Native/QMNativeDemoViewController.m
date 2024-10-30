//
//  QMNativeDemoViewController.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import "QMNativeDemoViewController.h"
#import "QMNativeSingleImageCell.h"
#import "QMNativeAtlasImgeCell.h"
#import "QMNativeVideoCell.h"
#import <QMAdSDK/QMAdSDK-Swift.h>
@interface QMNativeDemoViewController ()<QMNativeAdDelegate, QMNativeAdRelatedViewDelegate>

@property (nonatomic, strong) NSArray *nativeAds;

@property (nonatomic, strong) dispatch_semaphore_t lock;

@end

@implementation QMNativeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lock = dispatch_semaphore_create(1);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 16; i ++) {
        [array addObject:[NSString stringWithFormat:@"Test Native AD: %d", i]];
    }
    self.sourceArray = [array copy];
    
    [self.tableView registerClass:[QMNativeSingleImageCell class] forCellReuseIdentifier:@"QMNativeSingleImageCell"];
    [self.tableView registerClass:[QMNativeAtlasImgeCell class] forCellReuseIdentifier:@"QMNativeAtlasImgeCell"];
    [self.tableView registerClass:[QMNativeVideoCell class] forCellReuseIdentifier:@"QMNativeVideoCell"];
    
    NSMutableArray *nativeAds = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        QMNativeAd *nativeAd = [[QMNativeAd alloc] initWithSlot:self.slot];
        nativeAd.delegate = self;
        [nativeAds addObject:nativeAd];
    }
    self.nativeAds = [nativeAds copy];
    
    for (QMNativeAd *nativeAd in self.nativeAds) {
        [nativeAd loadAdData];
    }
}

// MARK: - QMNativeAdDelegate
- (void)qm_nativeAdLoadSuccess:(QMNativeAd *)nativeAd {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSMutableArray *array = [self.sourceArray mutableCopy];
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    idx = idx * 4 + 1;
    [array insertObject:nativeAd atIndex:idx];
    self.sourceArray = [array copy];
    [self.tableView reloadData];
    dispatch_semaphore_signal(_lock);
}

- (void)qm_nativeAdLoadFail:(QMNativeAd *)nativeAd error:(NSError *)error {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    NSLog(@"【媒体】自渲染%ld: 请求失败",(long)idx + 1);
}

- (void)qm_nativeAdDidShow:(QMNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    NSLog(@"【媒体】自渲染%ld: 曝光",(long)idx + 1);
}

- (void)qm_nativeAdDidClick:(QMNativeAd *)nativeAd {
    [MBProgressHUD showMessage:@"NativeAd: 点击"];
}

- (void)qm_nativeAdDidCloseOtherController:(QMNativeAd *)nativeAd {
    [MBProgressHUD showMessage:@"NativeAd: 关闭落地页"];
}

// MARK: - tableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.sourceArray[indexPath.item];
    if ([value isKindOfClass:[QMNativeAd class]]) {
        QMNativeAd *nativeAd = value;
        if (nativeAd.meta.getMaterialType == 3) {
            QMNativeAtlasImgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMNativeAtlasImgeCell" forIndexPath:indexPath];
            [cell refreshWithData:nativeAd];
            return cell;
        } else if (nativeAd.meta.getMaterialType == 4) {
            QMNativeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMNativeVideoCell" forIndexPath:indexPath];
            [cell refreshWithData:nativeAd];
            cell.nativeAd.relatedView.delegate = self;
            return cell;
        } else {
            QMNativeSingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMNativeSingleImageCell" forIndexPath:indexPath];
            [cell refreshWithData:nativeAd];
            return cell;
        }
    } else {
        NSString *cellID = NSStringFromClass([UITableViewCell class]);
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = value;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.sourceArray[indexPath.item];
    if ([value isKindOfClass:[QMNativeAd class]]) {
        QMNativeAd *nativeAd = value;
        if (nativeAd.meta.getMaterialType == 3) {
            return 180;
        } else {
            return 230;
        }
    }
    return 160;
}

/// 插屏广告视频播放开始
- (void)qm_nativeAdRelatedViewDidStart:(QMNativeAdRelatedView *)nativeAdRelatedView {
    
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放开始",(long)idx + 1);
}
/// 插屏广告视频播放暂停
- (void)qm_nativeAdRelatedViewDidPause:(QMNativeAdRelatedView *)nativeAdRelatedView {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放暂停",(long)idx + 1);
}
/// 插屏广告视频播放继续
- (void)qm_nativeAdRelatedViewDidResume:(QMNativeAdRelatedView *)nativeAdRelatedView {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放继续",(long)idx + 1);
}
/// 插屏广告视频播放完成
- (void)qm_nativeAdRelatedViewDidPlayComplection:(QMNativeAdRelatedView *)nativeAdRelatedView {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放完成",(long)idx + 1);
}
/// 插屏广告视频播放异常
- (void)qm_nativeAdRelatedViewDidPlayFinished:(QMNativeAdRelatedView *)nativeAdRelatedView didFailWithError:(NSError *)error {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放结束",(long)idx + 1);
}

@end
