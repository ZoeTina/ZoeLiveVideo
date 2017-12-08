//
//  PVUgcHtmlViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/16.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUgcHtmlViewController.h"
#import <WebKit/WebKit.h>
#import "SCImageManager.h"
#import "PVUGCVideoViewController.h"
#import "PVUGCModel.h"
#import "PVLoginViewController.h"
#import "UIAlertController+SCExtension.h"

@interface PVUgcHtmlViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) PVUGCModel *ugcModel;
@end

@implementation PVUgcHtmlViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.UIDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.reminderBtn.hidden = true;
    [self initView];
    [self loadData];
    self.reloadButton.layer.zPosition = 2;
}

- (void)initView {
    [self.view addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(kNavBarHeight);
        make.bottom.mas_offset(-SafeAreaBottomHeight - 40);
    }];
}

- (IBAction)reloadWebView:(id)sender {
    self.wkWebView.hidden = NO;
    self.reloadButton.hidden = YES;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}


/**
 加载数据
 */
- (void)loadData {
    [PVNetTool getDataWithUrl:getUgcInfo success:^(id result) {
        if (result) {
            self.ugcModel = [PVUGCModel yy_modelWithDictionary:result];
            [self loadWebViewWithUgcModel];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadWebViewWithUgcModel {
    self.scNavigationItem.title = self.ugcModel.name;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.ugcModel.guideHtml]]];
}


- (IBAction)startEditVideo:(id)sender {
    
    if ([PVUserModel shared].token.length == 0 || [PVUserModel shared].userId.length == 0) {

        PVLoginViewController *loginCon = [[PVLoginViewController alloc] init];
        [self.navigationController pushViewController:loginCon animated:YES];
    }else {
        [[PVProgressHUD shared] showHudInView:self.view];
        
        NSDictionary *dict = @{@"token":huangToken,@"ugcId":@(self.ugcModel.id),@"userId":huangUserId};
        [PVNetTool postDataHaveTokenWithParams:dict url:getUploadFileNum success:^(id responseObject) {
            if (responseObject) {
                [[PVProgressHUD shared] hideHudInView:self.view];
                if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                    NSInteger fileNum = [[[responseObject pv_objectForKey:@"data"] pv_objectForKey:@"fileNum"] integerValue];
                    if (fileNum > 0) {
                        [self callCamera];
                    }else {
                        Toast(@"今日上传视频数量已达到上限，请明天再上传");
                    }
                }else {
                    if ([[responseObject pv_objectForKey:@"errorMsg"] length] > 0) {
                        Toast([responseObject pv_objectForKey:@"errorMsg"]);
                    }
                }
            }
        } failure:^(NSError *error) {
            if (error) {
                [[PVProgressHUD shared] hideHudInView:self.view];
                Toast(@"数据获取失败，暂不能上传视频");
            }
        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
            [[PVProgressHUD shared] hideHudInView:self.view];
            Toast(@"数据获取失败，暂不能上传视频");
        }];
    }
    
}

///页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.reloadButton.hidden = YES;
    self.wkWebView.hidden = NO;
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.reloadButton.hidden = NO;
    self.wkWebView.hidden = YES;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        //        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.scrollView.backgroundColor = [UIColor whiteColor];
        _wkWebView.scrollView.showsVerticalScrollIndicator = false;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = false;
        
        DisableAutoAdjustScrollViewInsets(_wkWebView.scrollView, self);
    }
    return _wkWebView;
}


- (void)callCamera{
    PV(weakSelf);
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
//        // 无相机权限
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
//    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
//        // 防止用户首次拍照拒绝授权时相机页黑屏
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//            if (granted) {
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [self callCamera];
//                });
//            }
//        }];
//    } else
        if ([SCImageManager authorizationStatus] == 2) {
        // 相册访问被拒绝
        UIAlertController *alerController = [UIAlertController addAlertReminderText:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册"  cancelTitle:@"取消" doTitle:@"设置" preferredStyle:UIAlertControllerStyleAlert cancelBlock:nil doBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [self presentViewController:alerController animated:YES completion:nil];
    } else if ([SCImageManager authorizationStatus] == 0) {
        // 未请求过相册权限
        [[SCImageManager manager] requestAuthorizationWithCompletion:^{
            [self callCamera];
        }];
    } else {
        [[SCImageManager manager] getAllVideoWithCompletion:^(NSArray *array) {
            PVUGCVideoViewController * vc = [[PVUGCVideoViewController alloc] init];
            vc.videoUgcModel = self.ugcModel;
            vc.videoArray = [self getTimeArray:array];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    
}

//根据时间排序
- (NSMutableArray *)getTimeArray:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray array];
    
    NSMutableArray * assetsArray = [NSMutableArray arrayWithArray:array];
    [assetsArray sortUsingComparator:^NSComparisonResult(id  obj1, id  obj2) {
        SCAssetModel * model1 = ( SCAssetModel *)obj1;
        SCAssetModel * model2 = ( SCAssetModel *)obj2;
        NSDate *date1=model1.asset.creationDate;
        NSDate *date2=model2.asset.creationDate;
        return [date2 compare: date1];
    }];
    //获取到所有时间
    NSMutableArray * timeArray = [NSMutableArray array];
    for ( SCAssetModel *model in assetsArray) {
        NSString * dateString = [NSDate PVDateToStringTime:model.asset.creationDate format:@"yyyyMMdd"];
        if (![timeArray containsObject:dateString]) {
            [timeArray addObject:dateString];
        }
    }
    //时间进行排序
    [timeArray sortUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    //根据时间进行匹配
    for (int i = 0; i< timeArray.count; i++) {
        SCAssetListModel * model = [[SCAssetListModel alloc] init];
        model.createDate = [timeArray sc_safeObjectAtIndex:i];
        NSMutableArray * tempArray = [NSMutableArray array];
        for (SCAssetModel *tempModel in assetsArray) {
            NSString * dateString = [NSDate PVDateToStringTime:tempModel.asset.creationDate format:@"yyyyMMdd"];
            if ([dateString isEqualToString:model.createDate]) {
                [tempArray addObject:tempModel];
            }
        }
        model.modelArray = [NSArray arrayWithArray:tempArray];
        [newArray addObject:model];
    }
    
    return newArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
