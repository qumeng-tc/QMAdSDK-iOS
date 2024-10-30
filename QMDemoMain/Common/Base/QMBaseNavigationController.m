//
//  QMBaseNavigationController.m
//  QMAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import "QMBaseNavigationController.h"
#import "UIColor+QMAD.h"

@interface QMBaseNavigationController ()

@end

@implementation QMBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor colorWithHex:@"#FFFFFF"];
    self.navigationBar.tintColor = [UIColor colorWithHex:@"#333333"];
    [self.navigationBar setShadowImage:[UIColor imageWith:@"#CCCCCC" size:CGSizeMake(CGRectGetWidth(self.view.frame), 0.5)]];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
