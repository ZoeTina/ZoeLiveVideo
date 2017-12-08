//
//  AppConstant.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "Utils.h"
#import "NSObject+LZToast.h"
#import "SCBaseViewController.h"
#import "UIViewController+LZPopupViewController.h"
#import "LZMessagePopupViewController.h"
#import "PVUserGuideView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "PVUserModel.h"
#import "UIView+Toast.h"
#import "TYAttributedLabel.h"
#import "PVAnimHeaderRefresh.h"
#import "PVAnimFooterRefresh.h"
#import "NetWorkAnalysisTool.h"
#import "NSDictionary+PVExtension.h"
#import "PVNoDataView.h"
#import "PVMineConfigModel.h"
#import "PVProgressHUD.h"
#import "YYModel.h"
#import <Masonry/Masonry.h>
#import "PVBaseFooterRefresh.h"

#ifndef AppConstant_h
#define AppConstant_h


#ifdef DEBUG
#define YYLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define YYLog(...)
#endif

#define SafeAreaBottomHeight (kScreenHeight == 812.0 ? 34 : 0)

#define kColorWithRGBA(r, g, b, a)[UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kColorWithRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
// 3.设置随机颜色
#define YYRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define Toast(text) [self.view makeToast:text duration:2 position:CSToastPositionCenter];

#define ToastView(text) [self makeToast:text duration:2 position:CSToastPositionCenter];

#define WindowToast(text) [[UIApplication sharedApplication].keyWindow makeToast:text duration:2 position:CSToastPositionCenter];


/// RGB颜色(16进制)
//#define COLORHEX(hexString) [Utils colorWithHexString:(hexString)]
#define UIColorHexString(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define textColorNormal kColorWithRGB(0, 0, 0)
#define textColorSelected kColorWithRGB(42, 180, 228)
#define lineColor kColorWithRGB(215, 215, 215)

#define font(x) [UIFont fontWithName:@"PingFangSC-Regular" size:x]

#define LZMainWindow  [UIApplication sharedApplication].keyWindow

//G－C－D
#define GLOBAL(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

// 6.弱引用/强引用
#define YYWeakSelf(type)  __weak typeof(type) weak##type = type;
#define YYStrongSelf(type)  __strong typeof(type) type = weak##type;

//获取屏幕 宽度、高度 -- //获取屏幕尺寸
#define YYScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define YYScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define YYScreenBounds ([UIScreen mainScreen].bounds)

#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)

// 依照iPhone6的尺寸设计
#define GETPIXEL (YYScreenWidth / 375)
#define AUTOLAYOUTSIZE(size) (size * GETPIXEL)
//计算比例后的宽度
#define AUTOLAYOUTSIZE_W(w)  (w*(YYScreenWidth/375.0f))
//计算比例后高度
#define AUTOLAYOUTSIZE_H(h)  (h*(YYScreenHeight/667.0f))

// 读取本地图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define kLoadImage(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］
//定义UIImage对象
#define kImage(A) [UIImage imageWithContentsOfFile:［NSBundle mainBundle] pathForResource:A ofType:nil］

//移除iOS7之后，cell默认左侧的分割线边距   Preserve:保存（\：换行）
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#ifndef LZSYNTH_DUMMY_CLASS
#define LZSYNTH_DUMMY_CLASS(_name_) \
@interface LZSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation LZSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif

//一些缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

/** top */
#define lz_kiPhoneX(f) kiPhoneX ? (f + 34) : f
/** Bottom */
#define lz_kiPhoneXB(f) kiPhoneX ? (kScreenHeight-34-f) :  (kScreenHeight-f)

//NSUserDefaults 实例化
#define kUserDefaults [NSUserDefaults standardUserDefaults]

//分页每次个数
#define pageSizeForEvery 20
/**
 取消自动适配 ScrollView 的 Insets 行为
 @param scrollView 滑动视图
 @param vc 所在控制器
 */
#define DisableAutoAdjustScrollViewInsets(scrollView, vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
if (@available(iOS 11.0,*))  {\
scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop")\
} while (0);


#define kUserInfo [PVUserModel shared]

#endif /* AppConstant_h */
