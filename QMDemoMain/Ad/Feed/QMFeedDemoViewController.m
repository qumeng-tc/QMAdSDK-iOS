//
//  QMFeedDemoViewController.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QMAdSDK/QMAdSDK-Swift.h>
#import <Masonry.h>

#import "QMFeedDemoViewController.h"
#import "QMFeedAdCell.h"

@interface QMFeedDemoViewController ()<QMFeedAdDelegate>

@property (nonatomic, strong) NSArray *feedAds;

@property (nonatomic, strong) dispatch_semaphore_t lock;


@end

@implementation QMFeedDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lock = dispatch_semaphore_create(1);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 16; i ++) {
        [array addObject:[NSString stringWithFormat:@"Test Feed AD: %d", i]];
    }
    self.sourceArray = [array copy];
    
    [self.tableView registerClass:[QMFeedAdCell class] forCellReuseIdentifier:@"QMFeedAdCell"];
    
    NSMutableArray *feedAds = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        QMFeedAd *feedAd = [[QMFeedAd alloc] initWithSlot:self.slot];
        feedAd.customSize = self.feedcCustomSize;
        feedAd.viewController = self;
        feedAd.delegate = self;
        [feedAds addObject:feedAd];
    }
    self.feedAds = [feedAds copy];
    
    for (QMFeedAd *feedAd in self.feedAds) {
        [feedAd loadAdData];
    }
}

// MARK: - QMFeedAdDelegate
- (void)qm_feedAdLoadSuccess:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld: 物料加载成功",(long)idx + 1);
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSMutableArray *array = [self.sourceArray mutableCopy];
    idx = idx * 4 + 1;
    [array insertObject:feedAd atIndex:idx];
    self.sourceArray = [array copy];
    [self.tableView reloadData];
    dispatch_semaphore_signal(_lock);
}

- (void)qm_feedAdLoadFail:(QMFeedAd *)feedAd error:(NSError *)error {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld: 物料加载失败", (long)idx + 1);
}

- (void)qm_feedAdDidShow:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld: 曝光", (long)idx + 1);
}

- (void)qm_feedAdDidClick:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];

    NSLog(@"【媒体】信息流%ld:  点击", (long)idx + 1);
    [MBProgressHUD showMessage:@"信息流: 点击"];
}

- (void)qm_feedAdDidClose:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld:  关闭", (long)idx + 1);
    [MBProgressHUD showMessage:@"信息流: 关闭"];
}

- (void)qm_feedAdDidCloseOtherController:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld:  关闭落地页", (long)idx + 1);
    [MBProgressHUD showMessage:@"信息流: 关闭落地页"];
}

/// 信息流视频播放开始
- (void)qm_feedAdDidStart:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld: 视频播放开始", (long)idx + 1);
}

/// 信息流视频播放暂停
- (void)qm_feedAdDidPause:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld: 视频播放暂停", (long)idx + 1);
}

/// 信息流视频播放继续
- (void)qm_feedAdDidResume:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld: 视频播放继续", (long)idx + 1);
}

/// 信息流视频播放完成
- (void)qm_feedAdVideoDidPlayComplection:(QMFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld: 视频播放完成", (long)idx + 1);
}

/// 信息流视频播放异常
- (void)qm_feedAdVideoDidPlayFinished:(QMFeedAd *)feedAd didFailWithError:(NSError *)error {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    NSLog(@"【媒体】信息流%ld: 视频播放异常", (long)idx + 1);
}


// MARK: - tableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.sourceArray[indexPath.item];
    if ([value isKindOfClass:[QMFeedAd class]]) {
        QMFeedAdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMFeedAdCell" forIndexPath:indexPath];
        [cell configFeedCellWith:value];
        return cell;
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
    if ([value isKindOfClass:[QMFeedAd class]]) {
        QMFeedAd *feedAd = value;
        return [feedAd handleFeedAdHeight];
    }
    return 160;
}

@end
