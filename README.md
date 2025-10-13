<img src="http://cdn.aiclk.com/nsdk/res/imgstatic/qumeng_logo.png" alt="1" width = 200px />

# 趣盟 iOS-SDK 接入文档

## 使用说明：

>  建议优先使用 QuMengAdSDK
>  QuMengAdSDK API 前缀使用 "qumeng\_"
>  QMAdSDK API 前缀使用 "qm\_"

## SDK 工程配置及初始化说明

### 运行环境

	支持系统 iOS 11.0 及以上

### 自动部署

> 注意⚠️：我们建议您使用 `CocoaPods` 更轻松地管理 Xcode 项目的库依赖项，而不是直接下载并安装 SDK。SDK 的依赖项都在提供的文件中，请注意查收。

	# 推荐使用（避免缩写冲突）
	pod "QuMengAdSDK", "1.3.7"
	
	# 或者使用
	pod "QMAdSDK", "1.3.7"


​		

> 提醒 如果您获取的SDK版本号和推荐版本号不一致，可尝试按照以下骤执行 

	1. 在 podfile 文件中注释 pod "QMAdSDK", "1.3.7"
		
	2. 终端执行 pod install
	
	3. 终端执行 pod cache clean QMAdSDK
	
	4. 在podfile文件中打开 pod "QMAdSDK", "1.3.7"
	
	5. 终端执行 pod install QMAdSDK


​	

### 手动部署

> 下载压缩包，将 QuMengAdSDK.xcframework 或者 QMAdSDK.xcframework 添加项目工程中即可完成手动部署。


### Xcode 配置

Info.plist 中 添加 `Privacy - Tracking Usage Description` 权限

	<key>NSUserTrackingUsageDescription</key>
	<string>该ID将用于向您推送个性化广告</string>

Info.plist 中加入 

	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>meituanwaimai</string>
	  	<string>openapp.jdmobile</string>
	  	<string>jdmobile</string>
	  	<string>bilibili</string>
	  	<string>pddopen</string>
	  	<string>pinduoduo</string>
	  	<string>iosamap</string>
	  	<string>freereader</string>
	  	<string>iqiyi</string>
	  	<string>tmall</string>
	  	<string>vipshop</string>
	  	<string>alipays</string>
	  	<string>OneTravel</string>
	  	<string>eleme</string>
	  	<string>sinaweibo</string>
	  	<string>youku</string>
	  	<string>imeituan</string>
	  	<string>amapuri</string>
	  	<string>baiduboxlite</string> 
	  	<string>bdboxiosqrcode</string> 
	  	<string>baidumobads</string> 
	  	<string>kwai</string>
	  	<string>snssdk1128</string>
	  	<string>weixinULAPI</string>
	  	<string>weixinulapi</string>
	  	<string>weixinURLParamsAPI</string>
	  	<string>weixin</string>
	  	<string>ctrip</string>
	  	<string>taobaotravel</string>
	  	<string>mqq</string>
	  	<string>mqqapi</string>
	  	<string>bytedance</string>
	  	<string>taobao</string>
	  	<string>tbopen</string>
	  	<string>xhsdiscover</string>
	  	<string>ksnebula</string>
	  	<string>fleamarket</string>
	  	<string>tantanapp</string>
	  	<string>txvideo</string>
	  	<string>dianping</string>
	  	<string>mdsopen</string>
	  	<string>yanxuan</string>
	  	<string>mdopen</string>
	  	<string>openanjuke</string>
	  	<string>lianjia</string>
	  	<string>soul</string>
	</array>

### SDK 初始化

#### 注意事项 

- `QuMengAdSDKConfiguration` 是 SDK 配置中心，可以中途修改配置
- `QuMengAdSDKManager` 是 SDK 的入口和接口中心
- 任意广告类型均不支持中途更改代理，中途更改代理会导致接收不到广告相关回调，如若存在中途更改代理场景，需自行处理相关逻辑，确保广告相关回调正常执行。

#### 接入代码

	QuMengAdSDKConfiguration *config = [QuMengAdSDKConfiguration shareConfiguration];
	config.appId = @"应用ID";
	config.customIdfa = @"自定义IDFA";
	config.qmcds = @[
		@{@"qmcd": @"", @"version": @""},
		@{@"qmcd": @"", @"version": @""}
	];
	config.longitude = @"经度";
	config.latitude = @"纬度";
	// 注意⚠️：是否开启个性化推荐，开启则会获取 IDFA 默认：YES
	// 如果开启需要在 Info.plist 中 添加 `Privacy - Tracking Usage Description` 权限
	config.isEnablePersonalAds = YES;
	// 是否开启 SDK 的播放器配置，版本要求大于等于 1.3.3
	// 在播放音频时是否使用 SDK 内部对 AVAudioSession 设置的 category 及 options，默认（YES）使用，若不使用，SDK 内部不做任何处理，由调用方在展示广告时自行设置；
	// SDK 默认设置的 category 为 AVAudioSessionCategoryAmbient，options 为 AVAudioSessionCategoryOptionDuckOthers
	config.enableDefaultAudioSessionSetting = YES;
	
	// 初始化 SDK
	[QuMengAdSDKManager setupSDKWith:config];
	// 或：初始化 SDK 并返回状态
	[QuMengAdSDKManager setupSDKWith:config completion:^(BOOL success, NSError * _Nonnull error) {
	    
	}]; 
	
	// 是否允许摇一摇/扭一扭（单设备纬度）默认：YES 允许（1.3.7及以上版本支持）
	[QMAdSDKManager setTwistSwitch:YES];

## 开屏广告

### 简介

> 开屏广告使用 `QuMengSplashAd` 对象管理开屏广告所有业务。开屏广告所有视图的展示和移除将由 SDK 统一管理，开发者无需关心。
> 接入方式上，使用 QuMengSplashAd 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengSplashAdDelegate` 代理，获取广告加载、渲染、点击、关闭、跳转等回调。

### 接入代码

广告位对象创建时必须传入广告位ID

	_splashAd = [[QuMengSplashAd alloc] initWithSlot:slotID];
	// 广告点击强制关闭
	// _splashAd.adClickToCloseAutomatically = YES
	_splashAd.delegate = self;
	[_splashAd loadAdData];

广告物料加载成功后，会回调 `qumeng_splashAdLoadSuccess` 方法，在此处展示开屏广告

	- (void)qumeng_splashAdLoadSuccess:(QuMengSplashAd *)splashAd {
		// controller window 二选一
		
		// 检查广告有效性（1.3.7及以上版本支持）
		[splashAd isValid];
	
		// 非自定义bottom view
		[splashAd showSplashViewController:controller];
		
		// 自定义bottom view
		// UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(160, 35, 200, 30)];
		// view.text = @"欢迎接入趣盟";
		// [splashAd showSplashViewController:controller winthBottomView:view];
	
		// window 层级弹窗
	  	// [splashAd showSplashWindow:keyWindow withBottomView:view];
	  	// window 层级弹窗 自定义bottom view
	  	// [splashAd showSplashWindow:keyWindow withBottomView:view];		
	}

### 开屏回调说明

| 方法                                                         | 说明                           |
| ------------------------------------------------------------ | ------------------------------ |
| - (void)qumeng_splashAdLoadSuccess:(QuMengSplashAd *)splashAd | 开屏广告加载成功               |
| - (void)qumeng_splashAdLoadFail:(QuMengSplashAd *)splashAd error:(NSError * _Nullable)error | 开屏广告加载失败               |
| - (void)qumeng_splashAdRenderSuccess:(QMSplashAd *)splashAd  | 开屏广告渲染成功（1.3.7 新增） |
| - (void)qumeng_splashAdRenderFail:(QMSplashAd *)splashAd error:(NSError *)error | 开屏广告渲染失败（1.3.7 新增） |
| - (void)qumeng_splashAdDidShow:(QuMengSplashAd *)splashAd    | 开屏广告曝光                   |
| - (void)qumeng_splashAdDidClick:(QuMengSplashAd *)splashAd   | 开屏广告点击                   |
| - (void)qumeng_splashAdDidClose:(QuMengSplashAd *)splashAd closeType:(enum QuMengSplashAdCloseType)type | 开屏广告关闭                   |
| - (void)qumeng_splashAdVideoDidPlayFinished:(QuMengSplashAd *)splashAd didFailWithError:(NSError *)error | 开屏广告视频播放结束回调       |

## 插屏广告

### 简介

> 插屏广告使用 `QuMengInterstitialAd` 对象管理插屏广告所有业务。插屏广告所有视图的展示和移除将由 SDK 统一管理，开发者无需关心。
> 接入方式上，使用 `QuMengInterstitialAd` 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengInterstitialAdDelegate` 代理，获取广告加载、渲染、点击、关闭、跳转等回调。

### 接入代码

广告位对象创建时必须传入广告位ID

	_intertitialAd = [[QuMengInterstitialAd alloc] initWithSlot:slotID];
	_intertitialAd.adClickToCloseAutomatically = YES
	_intertitialAd.delegate = self;
	[_intertitialAd loadAdData];

广告物料加载成功后，会回调 `qumeng_interstitialAdLoadSuccess` 方法，在此处展示开屏广告

	- (void)qumeng_interstitialAdLoadSuccess:(QuMengInterstitialAd *)interstitialAd {
		// 检查广告有效性（1.3.7及以上版本支持）
		[interstitialAd isValid];
		[intertitialAd showInterstitialViewInRootViewController:controller];
	}

### 插屏回调说明

| 方法                                                         | 说明                 |
| ------------------------------------------------------------ | -------------------- |
| - (void)qumeng_interstitialAdLoadSuccess:(QuMengInterstitialAd *)interstitialAd | 插屏广告加载成功     |
| - (void)qumeng_interstitialAdLoadFail:(QuMengInterstitialAd *)interstitialAd error:(NSError *)error | 插屏广告加载失败     |
| - (void)qumeng_interstitialAdDidShow:(QuMengInterstitialAd *)interstitialAd | 插屏广告曝光         |
| - (void)qumeng_interstitialAdDidClick:(QuMengInterstitialAd *)interstitialAd | 插屏广告点击         |
| - (void)qumeng_interstitialAdDidClose:(QuMengInterstitialAd *)interstitialAd closeType:(enum QuMengInterstitialAdCloseType)type | 插屏广告关闭         |
| - (void)qumeng_interstitialAdDidCloseOtherController:(QuMengInterstitialAd *)interstitialAd | 插屏广告落地页关闭   |
| - (void)qumeng_interstitialAdDidStart:(QuMengInterstitialAd *)rewardedVideoAd | 插屏广告视频播放开始 |
| - (void)qumeng_interstitialAdDidPause:(QuMengInterstitialAd *)rewardedVideoAd | 插屏广告视频播放暂停 |
| - (void)qumeng_interstitialAdDidResume:(QuMengInterstitialAd *)rewardedVideoAd | 插屏广告视频播放继续 |
| - (void)qumeng_interstitialAdVideoDidPlayComplection:(QuMengInterstitialAd *)interstitialAd | 插屏广告视频播放完成 |
| - (void)qumeng_interstitialAdVideoDidPlayFinished:(QuMengInterstitialAd *)interstitialAd didFailWithError:(NSError *)error | 插屏广告视频播放异常 |

## 激励视频广告

### 简介

> 激励视频广告使用 `QuMengRewardedVideoAd` 对象管理激励视频广告所有业务。激励视频广告所有视图的展示和移除将由 SDK 统一管理，开发者无需关心。
> 接入方式上，使用 `QuMengRewardedVideoAd` 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengRewardedVideoAdDelegate` 代理，获取广告加载、渲染、点击、关闭、跳转等回调。

### 接入代码

广告位对象创建时必须传入广告位ID

	_rewardedVideoAd = [[QuMengRewardedVideoAd alloc] initWithSlot:slotID];
	_rewardedVideoAd.delegate = self;
	[_rewardedVideoAd loadAdData];

广告物料加载成功后，会回调 `qumeng_rewardedVideoAdLoadSuccess` 方法，在此处展示开屏广告

	- (void)qumeng_rewardedVideoAdLoadSuccess:(QuMengRewardedVideoAd *)rewardedVideoAd {
		// 检查广告有效性（1.3.7及以上版本支持）
		[rewardedVideoAd isValid];
		[rewardedVideoAd showRewardedVideoViewInRootViewController:controller];
	}

### 激励视频回调说明

| 方法                                                         | 说明                     |
| ------------------------------------------------------------ | ------------------------ |
| - (void)qumeng_rewardedVideoAdLoadSuccess:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告加载成功     |
| - (void)qumeng_rewardedVideoAdLoadFail:(QuMengRewardedVideoAd *)rewardedVideoAd error:(NSError *)error | 激励视频广告加载失败     |
| - (void)qumeng_rewardedVideoAdDidShow:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告曝光         |
| - (void)qumeng_rewardedVideoAdDidClick:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告点击         |
| - (void)qumeng_rewardedVideoAdDidClose:(QuMengRewardedVideoAd *)rewardedVideoAd closeType:(enum QuMengRewardedVideoAdCloseType)type | 激励视频广告关闭         |
| - (void)qumeng_rewardedVideoAdDidCloseOtherController:(QuMengRewardedVideoAd *)rewardedVideoAd | 落地页关闭               |
| - (void)qumeng_rewardedVideoAdDidRewarded:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告激励完成     |
| - (void)qumeng_rewardedVideoAdDidStart:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告播放开始     |
| - (void)qumeng_rewardedVideoAdDidPause:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告播放暂停     |
| - (void)qumeng_rewardedVideoAdDidResume:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告播放继续     |
| - (void)qumeng_rewardedVideoAdVideoDidPlayComplection:(QuMengRewardedVideoAd *)rewardedVideoAd rewarded:(BOOL)isRewarded | 激励视频广告视频播放完成 |
| - (void)qumeng_rewardedVideoAdVideoDidPlayFinished:(QuMengRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error rewarded:(BOOL)isRewarded | 激励视频广告视频播放异常 |

## 信息流广告

### 简介

> 信息流广告使用 `QuMengFeedAd` 对象管理信息流广告所有业务。 接入方式上，使用 `QuMengFeedAd` 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengFeedAdDelegate` 代理，获取广告加载、渲染、点击、关闭、跳转等回调。

### 接入代码

广告位对象创建时必须传入广告位ID

    @interface QuMengFeedSingleViewController () <QuMengFeedAdDelegate>
    @property (nonatomic, strong) QuMengFeedAd *feedAd;
    @end
    
    @implementation QuMengFeedSingleViewController
    
    - (void)viewDidLoad {
        [super viewDidLoad];
        self.feedAd = [[QuMengFeedAd alloc] initWithSlot:self.slot];
        ///  固定宽度高度自适应
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        self.feedAd.customSize = CGSizeMake(width - 40, 0);
        [self.feedAd loadAdData];
        // Do any additional setup after loading the view.
    }
    
    - (void)setLayoutSubview {
    //    self.feedAd.feedView.frame = CGRectMake(0, 200, self.view.frame.size.width, 400);
          [self.view addSubview:self.feedAd.feedView];
    //    [self.feedAd.feedView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.mas_equalTo(self.view);
    //        make.size.mas_equalTo(self.feedAd.feedView.frame.size);
    //    }];
        
        CGFloat scr =  self.feedAd.feedView.frame.size.height / self.feedAd.feedView.frame.size.width;
        [self.feedAd.feedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(self.feedAd.feedView.mas_width).multipliedBy(scr);
        }];        
    }
    
    // MARK: - QuMengFeedAdDelegate
    - (void)qumeng_feedAdLoadSuccess:(QuMengFeedAd *)feedAd {
        NSLog(@"【媒体】信息流: 物料加载成功");
        // 检查广告有效性（1.3.7及以上版本支持）
    		[feedAd isValid];
        [self setLayoutSubview];
    }

### 信息流回调说明

| 方法                                                         | 说明               |
| ------------------------------------------------------------ | ------------------ |
| - (void)qumeng_feedAdLoadSuccess:(QuMengFeedAd *)feedAd      | 信息流广告加载成功 |
| - (void)qumeng_feedAdLoadFail:(QuMengFeedAd *)feedAd error:(NSError *)error | 信息流广告加载失败 |
| - (void)qumeng_feedAdDidShow:(QuMengFeedAd *)feedAd          | 信息流广告曝光     |
| - (void)qumeng_feedAdDidClick:(QuMengFeedAd *)feedAd         | 信息流广告点击     |
| - (void)qumeng_feedAdDidClose:(QuMengFeedAd *)feedAd         | 信息流广告关闭     |
| - (void)qumeng_feedAdDidCloseOtherController:(QuMengFeedAd *)feedAd | 信息流落地页关闭   |
| - (void)qumeng_feedAdDidStart:(QuMengFeedAd *)feedAd         | 信息流视频播放开始 |
| - (void)qumeng_feedAdDidPause:(QuMengFeedAd *)feedAd         | 信息流视频播放暂停 |
| - (void)qumeng_feedAdDidResume:(QuMengFeedAd *)feedAd        | 信息流视频播放继续 |
| - (void)qumeng_feedAdVideoDidPlayComplection:(QuMengFeedAd *)feedAd | 信息流视频播放完成 |
| - (void)qumeng_feedAdVideoDidPlayFinished:(QuMengFeedAd *)feedAd didFailWithError:(NSError *)error | 信息流视频播放异常 |

## 媒体自渲染广告

### 简介

> 媒体自渲染广告使用 `QuMengNativeAd` 对象管理信息流广告所有业务。
> 接入方式上，使用 `QuMengNativeAd` 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengNativeAdDelegate` 代理，获取广告加载、渲染、点击、跳转等回调。
> 自渲染广告需要调用 `registerContainer:withClickableViews:` 方法，否则回调无法触发

### 接入代码示例

广告位对象创建时必须传入广告位ID
	

	@interface QuMengNativeAdSingleViewController () <QuMengNativeAdAdDelegate>
	@property (nonatomic, strong) QuMengNativeAdAd *nativeAd;
	@property (nonatomic, strong) UIImageView *imageView;
	
	@property (nonatomic, strong) UILabel *jumpLabel;
	
	@end
	
	@implementation QuMengNativeAdSingleViewController
	
	-(UIImageView *)imageView {
	    if (!_imageView) {
	        _imageView = UIImageView.new;
	    }
	    return _imageView;
	}
	
	- (UILabel *)jumpLabel {
	    if (!_jumpLabel) {
	        _jumpLabel = [[UILabel alloc] init];
	        _jumpLabel.text = @"点击跳转";
	    }
	    return _jumpLabel;
	}
	
	- (void)viewDidLoad {
	    [super viewDidLoad];
	    self.nativeAd = [[QuMengNativeAdAd alloc] initWithSlot:self.slot];
	    self.nativeAd.delegate = self;
	    [self.nativeAd loadAdData];
	    //    nativeAd load
	    // Do any additional setup after loading the view.
	}
	
	- (void)setLayoutSubview {
	    BOOL isVideo = self.nativeAd.meta.getMaterialType == 4 || self.nativeAd.meta.getMaterialType == 12;
	    UIView *materialView = isVideo ? self.nativeAd.videoView: self.imageView;
	    [self.view addSubview:materialView];
	    
	    [self.view addSubview:self.jumpLabel];
	    [materialView mas_makeConstraints:^(MASConstraintMaker *make) {
	        make.left.mas_equalTo(20);
	        make.center.mas_equalTo(0);
	        make.height.mas_equalTo(200);
	    }];
	    
	    [self.jumpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
	        make.centerX.mas_equalTo(0);
	        make.top.mas_equalTo(materialView.mas_bottom).offset(10);
	    }];
	}
	
	// MARK: QuMengNativeAdAdDelegate
	- (void)qumeng_nativeAdLoadSuccess:(QuMengNativeAdAd *)nativeAd {
	    NSLog(@"【媒体】自渲染: 请求成功");
	    // 检查广告有效性（1.3.7及以上版本支持）
			[nativeAd isValid];
	    /// 视频
	    if (nativeAd.meta.getMaterialType == 4 || nativeAd.meta.getMaterialType == 12) {
	        [nativeAd registerContainer:self.view withClickableViews:@[self.jumpLabel]];
	    } else {
	    		/// 图片
					[self.imageView yy_setImageWithURL:[NSURL URLWithString:nativeAd.meta.getMediaUrl] placeholder:nil];
					[nativeAd registerContainer:self.view withClickableViews:@[self.jumpLabel]];
	    }
	    [self setLayoutSubview];
	}


​	

### 媒体自渲染回调说明

| 方法                                                         | 说明                   |
| ------------------------------------------------------------ | ---------------------- |
| - (void)qumeng_nativeAdLoadSuccess:(QuMengNativeAd *)nativeAd | 自渲染广告素材加载成功 |
| - (void)qumeng_nativeAdLoadFail:(QuMengNativeAd *)nativeAd error:(NSError *)error | 自渲染广告素材加载失败 |
| - (void)qumeng_nativeAdDidShow:(QuMengNativeAd *)nativeAd    | 自渲染广告展示         |
| - (void)qumeng_nativeAdDidClick:(QuMengNativeAd *)nativeAd   | 自渲染广告点击         |
| - (void)qumeng_nativeAdDidCloseOtherController:(QuMengNativeAd *)nativeAd | 自渲染广告落地页关闭   |
| - (void)qumeng_nativeAdDidStart:(QuMengNativeAdAd *)nativeAd | 自渲染视频播放开始     |
| - (void)qumeng_nativeAdDidPause:(QuMengNativeAdAd *)nativeAd | 自渲染视频播放暂停     |
| - (void)qumeng_nativeAdDidResume:(QuMengNativeAdAd *)nativeAd | 自渲染视频播放继续     |
| - (void)qumeng_nativeAdVideoDidPlayComplection:(QuMengNativeAdAd *)nativeAd | 自渲染视频播放完成     |
| - (void)qumeng_nativeAdVideoDidPlayFinished:(QuMengNativeAdAd *)nativeAd didFailWithError:(NSError *)error | 自渲染视频播放异常     |

### ~~自渲染摇一摇组件~~

#### 使用说明

> 版本要求大于等于 1.3.1，可参考 Demo 中 QMNativeCell 类
>
> <font color=#ff0000>1.3.7 及之后版本不再支持</font>

	// 声明成员变量
	@property (nonatomic, strong) QMNativeAdShakeView *shakeView;
	
	// 初始化 QMNativeAdShakeView
	- (QMNativeAdShakeView *)shakeView {
		if (!_shakeView) {
			QMNativeAdShakeView *shakeView = [[QMNativeAdShakeView alloc] init];
		}
		return _shakeView;
	}
	
	// 绑定自渲染广告对象
	self.shakeView.nativeAd = nativeAd;
	
	// 开启摇一摇
	[self.shakeView startShake];
	
	// 停止摇一摇
	[self.shakeView stopShake];

### 自渲染滑一滑组件

#### 使用说明

> 版本要求大于等于 1.3.2，可参考 Demo 中 QMNativeCell 类

	// 声明成员变量
	@property (nonatomic, strong) QMNativeAdSlideView *slideView;
	
	// 初始化 QMNativeAdSlideView
	- (QMNativeAdSlideView *)slideView {
	    if (!_slideView) {
	        _slideView = [[QMNativeAdSlideView alloc] init];
	    }
	    return _slideView;
	}
	
	// 绑定自渲染广告对象
	self.slideView.nativeAd = nativeAd;

## 竞价结果通知

提供竞价成功和失败的通知功能，便于广告业务处理。

---

### 成功通知

```objective-c
- (void)winNotice:(NSInteger)auctionSecondPrice;
```

#### 参数说明

| 参数名称             | 类型        | 描述                       |
| -------------------- | ----------- | -------------------------- |
| `auctionSecondPrice` | `NSInteger` | 竞价第二名的价格，单位为分 |

#### 描述

当竞价成功时调用此方法，告知竞价第二名的出价金额。

---

### 失败通知

```objective-c
- (void)lossNotice:(NSInteger)auctionPrice 
         lossReason:(QuMengLossReason* _Nullable)lossReason 
          winBidder:(QuMengWinBidder* _Nullable)winBidder;
```

#### 参数说明

| 参数名称       | 类型               | 描述                                                         |
| -------------- | ------------------ | ------------------------------------------------------------ |
| `auctionPrice` | `NSInteger`        | 胜出者的价格，单位为分                                       |
| `winBidder`    | `QuMengWinBidder`  | 胜出者对应广告商（可选）<br>预定义值包括：<br> - `QuMengWinBidderCSJ`：穿山甲<br> - `QuMengWinBidderGDT`：优量汇<br> - `QuMengWinBidderKuaishou`：快手<br> - `QuMengWinBidderBaidu`：百度<br> - `QuMengWinBidderQumeng`：趣盟<br> - `QuMengWinBidderOther`：其他家 <br>如果需要扩展，可以直接传入自定义的字符串 |
| `lossReason`   | `QuMengLossReason` | 失败原因（可选）<br>预定义值包括：<br> - `QuMengLossReasonBaseFilter`：底价过滤<br> - `QuMengLossReasonLowBid`QuMengLossReason：bid 价格低于最高价<br> - `QuMengLossReasonBlacklist`：素材黑名单过滤<br> - `QuMengLossReasonCompetitor`：竞品过滤<br> - `QuMengLossReasonNoResponse`：在有效时间内未返回广告<br> - `QuMengLossReasonOther`：其他 <br>如果需要扩展，可以直接传入自定义的字符串（建议字符串为 > 1000 的数字） |

#### 描述

当竞价失败时调用此方法，告知失败原因及胜出者信息

## 广告有效性

广告有效性接口

```
// 是否有效 YES: 有效 NO: 无效
- (BOOL)isValid;
```

## 微信小程序/小游戏跳转接入方案

### 步骤 1：创建移动应用

进入 [微信开放平台](https://open.weixin.qq.com/) 创建移动应用，并获取相应的微信 `AppID`。

---

### 步骤 2：嵌入最新版 OpenSDK

在移动端嵌入最新版 `OpenSDK`（仅嵌入即可，无需额外开发工作），并确保版本为 **1.8.6** 及以上。

---

### 步骤 3：关联微信 AppID

在 [趣盟平台](https://qm.qttunion.com/login/) 将微信开放平台填写的 `AppID` 与当前应用进行关联。

- **注意**：
  - 对于 **iOS 应用**，需额外填写 `universal_link`。

---

### 步骤 4：更新趣盟 SDK

嵌入并更新趣盟 `SDK` 至 **1.3.1** 或以上版本。

---

### 注意事项

- 确保所有相关 SDK 均为最新版本以避免兼容性问题。
- 确保微信开放平台中的配置与趣盟平台的关联信息完全一致。
- 对于 iOS 设备，务必正确填写 `universal_link`，以保证正常跳转。

## TopOn聚合平台自定义广告接入文档

### 简介

> Topon自定义广告接入地址：[https://help.takuad.com](https://help.takuad.com)

### 接入方式

将 QMTopOnSDK.xcframework 集成到项目中

或者使用 `CocoaPods` 集成

	pod "QMTopOnSDK", path: "../QMTopOnSDK"

### 广告类型及服务器配置参数

| 广告类型 | 广告类名称                | 服务器配置参数                                               |
| -------- | ------------------------- | ------------------------------------------------------------ |
| 激励视频 | QMRewardVideoAdapter      | "slot\_id" // 广告栏位                                       |
| 插屏     | QuMengInterstitialAdapter | "slot\_id" // 广告栏位                                       |
| 原生     | QuMengNativeAdapter       | "slot\_id" // 广告栏位<br>"draw\_feed": "1" // 渲染方式 - 模板渲染<br>"draw\_feed": "0" // 渲染方式 - 自渲染 |
| 开屏     | QuMengSplashAdapter       | "slot\_id" // 广告栏位                                       |

## 接口说明

| 方法名             | 说明                   | 备注                                                         |
| ------------------ | ---------------------- | ------------------------------------------------------------ |
| getRequestId       | 广告唯一 ID            |                                                              |
| getIdeaId          | 创意 ID                |                                                              |
| getECPM            | 广告价格               | 单位：分                                                     |
| getTitle           | 广告标题               |                                                              |
| getDesc            | 广告副标题             |                                                              |
| getLandingPageUrl  | 落地页地址             |                                                              |
| getInteractionType | 广告交互类型           | 1：落地页类型<br>2：下载类型（包含拉新和拉活）<br>3：小程序<br>4：快应用 |
| getImageUrls       | 广告图片链接           | 物料地址                                                     |
| getAppLogoUrl      | 广告创意 Logo          |                                                              |
| getAppName         | 广告创意应用名称       |                                                              |
| getAppPackageName  | 广告创意包名           |                                                              |
| getAppInformation  | 广告六要素信息         | 用于下载合规外显，包括应用版本、开发者信息、隐私协议链接、应用权限链接、应用功能链接 |
| getMediaSize       | 素材宽高               | 图片或视频的宽高                                             |
| getMaterialType    | 广告物料的类型         | 1：小图<br>2：大图<br>3：组图<br>4：视频<br>6：开屏<br>12：激励视频 |
| getVideoDuration   | 视频播放时长           |                                                              |
| qmLogoUrl          | 趣盟广告标识（无文字） |                                                              |
| qmTextLogoUrl      | 趣盟广告标识（有文字） |                                                              |
| logoUrl            | 广告封面               | 仅视频物料存在该字段                                         |
| getExtraInfo       | 扩展信息               |                                                              |

## 错误码

| 错误码 | 说明                                           | 备注                                                         |
| ------ | ---------------------------------------------- | ------------------------------------------------------------ |
| 100001 | 无填充，没有合适广告返回导致，偶现属于正常情况 | - **reason: 100** 出价未过底价（固价未过栏位底价）<br> - **reason: 101** 请求频率过高，建议避免同一时间内高频拉取广告<br> - **reason: 102** 无合适广告返回，检查流量提高用户质量。开发测试阶段可添加设备或更换设备，仍无填充可联系运营<br> - **reason: 103** 命中平台策略导致无填充，开发测试阶段可联系运营反馈<br> - **reason: 104** 命中检索 204 策略导致无填充，开发测试阶段可联系运营反馈<br> - **reason: -1** 其它异常 |
| 100002 | 服务器错误                                     | - **reason: 201** 检索服务器异常                             |
| 100003 | 请求失败                                       | - **reason: 301** 请求体解析失败                             |
| 100004 | 代码位不合法                                   | - **reason: 401** 检查代码位 ID 是否为空字符串或特殊字符。注：新建的代码位需约 10 分钟生效 |
| 100005 | 请求包名与媒体包名不一致                       | - **reason: 501** 实际发起的包名和媒体的包名是否一致。注：若媒体通过趣盟运营创建，可联系趣盟运营协同排查 |
| 100006 | 广告请求代码位类型不匹配                       | - **reason: 601** 例如开屏代码位使用了激励视频方法           |
| 200001 | 代码位不能为空                                 | 检查设置代码位 ID 是否为空                                   |
| 200002 | 无填充                                         | 命中平台策略导致无填充，开发测试阶段可联系运营反馈           |
| 200003 | 网络错误                                       | 网络连接异常                                                 |

## SDK版本发布记录

| 版本号 | 日期       | 备注                                                         |
| ------ | ---------- | ------------------------------------------------------------ |
| 1.3.7  | 2025-10-11 | **新增**：激励视频新样式<br/>**新增**：支持gromore平台适配<br/>**合规：<font color=#ff0000>删除摇一摇组件接口</font>**<br/>**修复**：已知问题 |
| 1.3.6  | 2025-07-21 | **新增**：广告有效性判断：isValid()方法<br/>**合规**：交互优化<br/>**修复**：已知问题 |
| 1.3.5  | 2025-06-20 | **优化**：开屏广告样式<br/>**修复**：已知问题                |
| 1.3.4  | 2025-04-21 | **新增**：信息流模版样式<br/>**新增**：iOS-CAID脱敏接口<br/>**新增**：适配新预算链路<br/>**优化**：开屏广告UI样式<br/>**修复**：已知问题 |
| 1.3.3  | 2025-03-07 | **优化**：SDK稳定性优化<br>**修复**：已知问题                |
| 1.3.2  | 2025-02-18 | **新增**：信息流自渲染滑一滑组件<br>**修复**：已知问题       |
| 1.3.1  | 2025-01-23 | **新增**：开屏增加新样式<br>**新增**：竞价成功&失败回传<br>**新增**：支持小程序预算<br>**修复**：已知问题 |
| 1.3.0  | 2025-01-02 | **重要**：调整SDK代码架构，更新为纯OC<br>**新增**：开屏支持滑一滑交互<br>**新增**：信息流自渲染&模版渲染支持摇一摇<br>**新增**：信息流模版渲染支持滑一滑<br>**优化**：激励视频广告交互，支持摇一摇<br>**优化**：信息流自渲染视频物料接入方式<br>**修复**：已知问题 |
| 1.2.0  | 2024-10-30 | **新增**：信息流模板渲染支持自定义尺寸<br>**新增**：视频类物料支持事件回调<br>**新增**：支持 POD 远程化<br>**优化**：广告链路适配新预算<br>**修复**：已知问题 |
| 1.1.0  | 2024-10-12 | **修复**：已知问题<br>**优化**：SDK 性能优化                 |
| 1.0.9  | 2024-09-20 | **修复**：已知问题                                           |
| 1.0.7  | 2024-09-04 | **新增**：TopOn 适配器<br>**优化**：广告交互链路<br>**修复**：已知问题 |
| 1.0.6  | 2024-08-23 | **修复**：已知问题                                           |
| 1.0.5  | 2024-08-13 | **优化**：适配电商预算<br>**修复**：链路上报异常问题         |
| 1.0.4  | 2024-07-29 | **优化**：广告交互链路<br>**修复**：已知问题导致的崩溃       |
| 1.0.3  | 2024-05-29 | **新增**：支持横版应用广告<br>**修复**：已知问题导致的崩溃   |
| 1.0.0  | 2024-02-21 | **新增**：开屏、激励视频、插屏、信息流、自渲染               |
