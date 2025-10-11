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
#import "ViewController.h"

#import <QMAdSDK/QMAdSDK.h>

@interface QMNativeDemoViewController ()<QMNativeAdDelegate>

@property (nonatomic, strong) NSMutableArray *nativeAds;
@property (nonatomic, strong) dispatch_group_t completionGroup;


@end

@implementation QMNativeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[QMNativeSingleImageCell class] forCellReuseIdentifier:@"QMNativeSingleImageCell"];
    [self.tableView registerClass:[QMNativeAtlasImgeCell class] forCellReuseIdentifier:@"QMNativeAtlasImgeCell"];
    [self.tableView registerClass:[QMNativeVideoCell class] forCellReuseIdentifier:@"QMNativeVideoCell"];
    [self loadData:self.slot];
}

- (void)loadData:(NSString *)slotID  {
    self.nativeAds = @[
        [[QMNativeAd alloc] initWithSlot:slotID],
        [[QMNativeAd alloc] initWithSlot:slotID],
        [[QMNativeAd alloc] initWithSlot:slotID],
        [[QMNativeAd alloc] initWithSlot:slotID]
    ].mutableCopy;
    
    _completionGroup = dispatch_group_create();
    for (QMNativeAd *nativeAd in self.nativeAds) {
        dispatch_group_enter(_completionGroup);
        nativeAd.delegate = self;
        [nativeAd loadAdData];
    }
    
    __block NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 16; i ++) {
        [array addObject:[NSString stringWithFormat:@"Test Native AD: %d", i]];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(_completionGroup, dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        for (QMNativeAd *nativeAd in self.nativeAds) {
            nativeAd.delegate = strongSelf;
            NSInteger idx = [strongSelf.nativeAds indexOfObject:nativeAd];
            idx = idx * 4 + 1;
            [array insertObject:nativeAd atIndex:idx];
        }
        strongSelf.sourceArray = array;
        [strongSelf.tableView reloadData];
    });
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// MARK: - QMNativeAdDelegate
/// 自渲染广告加载成功
- (void)qm_nativeAdLoadSuccess:(QMNativeAd *)nativeAd {
    // 检查广告有效性
    if (checkAdValid()) {
        [nativeAd isValid];
    }
    
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 请求成功",(long)idx + 1);
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QMLog(@"【媒体】自渲染: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (nativeAd.meta.getECPM >= price.integerValue) {
        QMLog(@"【媒体】自渲染: 趣盟竞价成功，趣盟价格：%ld", (long)nativeAd.meta.getECPM);
        [nativeAd winNotice:price.integerValue];
    } else {
        QMLog(@"【媒体】自渲染: 趣盟竞价失败，趣盟价格：%ld", (long)nativeAd.meta.getECPM);
        [nativeAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        [self.nativeAds removeObject: nativeAd];
    }    
    
    dispatch_group_leave(_completionGroup);
}

/// 自渲染广告加载失败
- (void)qm_nativeAdLoadFail:(QMNativeAd *)nativeAd error:(NSError *)error {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 请求失败",(long)idx + 1);
    [self.nativeAds removeObject:nativeAd];
    dispatch_group_leave(_completionGroup);
}


- (void)qm_nativeAdDidShow:(QMNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 曝光",(long)idx + 1);
    [MBProgressHUD showMessage:@"NativeAd: 曝光"];
}

- (void)qm_nativeAdDidClick:(QMNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 点击",(long)idx + 1);
    [MBProgressHUD showMessage:@"NativeAd: 点击"];
}

- (void)qm_nativeAdDidCloseOtherController:(QMNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 关闭落地页",(long)idx + 1);
    [MBProgressHUD showMessage:@"NativeAd: 关闭落地页"];
}

/// 自渲染视频播放开始
- (void)qm_nativeAdDidStart:(QMNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 视频播放开始",(long)idx + 1);
}

/// 自渲染视频播放暂停
- (void)qm_nativeAdDidPause:(QMNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 视频播放暂停",(long)idx + 1);
}

/// 自渲染视频播放继续
- (void)qm_nativeAdDidResume:(QMNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 视频播放继续",(long)idx + 1);
}

/// 自渲染视频播放完成
- (void)qm_nativeAdVideoDidPlayComplection:(QMNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 视频播放完成",(long)idx + 1);

}

/// 自渲染视频播放异常
- (void)qm_nativeAdVideoDidPlayFinished:(QMNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QMLog(@"【媒体】自渲染%ld: 视频播放结束",(long)idx + 1);
}

@end
