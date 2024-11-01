//
//  QMBaseDemoViewController.h
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+QMAD.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMBaseDemoViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *sourceArray;

@end

NS_ASSUME_NONNULL_END
