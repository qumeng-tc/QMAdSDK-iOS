//
//  QMFeedAdCell.h
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>
#import <QMAdSDK/QMAdSDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMFeedAdCell : UITableViewCell

- (void)configFeedCellWith:(QMFeedAd *)feedAd;

@end

NS_ASSUME_NONNULL_END
