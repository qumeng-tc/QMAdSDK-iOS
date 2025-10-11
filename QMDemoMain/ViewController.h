//
//  ViewController.h
//  QMAdSDKDemo
//
//  Created by qusy on 2023/12/29.
//

#import "QMBaseDemoViewController.h"

bool adClickToCloseAutomatically(void);
bool customBottomViewIsOpen(void);
bool adSplashWindow(void);
BOOL nativeAdShowShake(void);
BOOL nativeAdShowSlide(void);
BOOL donotSetupSDK(void);
BOOL twistDisabled(void);
BOOL checkAdValid(void);
BOOL checkEnablePersonalAds(void);

void PMP(NSObject *object, SEL selector, NSDictionary *param);

@interface ViewController : QMBaseDemoViewController

@end

