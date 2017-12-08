//
//  PVWebViewController.m
//  PandaVideo
//
//  Created by cara on 17/9/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVWebViewController.h"
#import <WebKit/WebKit.h>
#import "LZActionSheet.h"
#import "PVVideoShareView.h"
#import "PVWebShareView.h"
#import "PVShareViewController.h"



@interface PVWebViewController ()<WKNavigationDelegate, WKUIDelegate>

///跳转的链接
@property(nonatomic, copy)NSString* webUrl;
///显示的标题
@property(nonatomic, copy)NSString* webTitle;
///显示网页的view
@property(nonatomic, strong)WKWebView* webView;

@property (nonatomic, strong) UIProgressView *progress;

@end

@implementation PVWebViewController


-(instancetype)initWebViewControllerWithWebUrl:(NSString *)webUrl webTitle:(NSString *)webTitle{
    self = [super init];
    if (self) {
        self.webUrl = webUrl;
        if ([webUrl containsString:@".json"]) {
            [self loadData];
        }else{
            self.webTitle = webTitle;
            [self loadH5Data];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@""];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (void)setupUI {
    [self setRightItem];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(kNavBarHeight);
        
    }];
    [self.view addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(kNavBarHeight);
        make.height.mas_equalTo(3);
    }];
}



- (void)setRightItem {
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]  initWithCustomView:rightBtn];
    self.scNavigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnClicked:(UIButton *)button {
    
        LZActionSheet *actionSheet = [[LZActionSheet alloc] initWithTitle:nil
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@[@"分享",@"刷新"]
                                                         actionSheetBlock:^(NSInteger buttonIndex) {
                                                             [self alertActionWithIndex:buttonIndex];
                                                         }];
        [actionSheet show];
    
}

- (void)alertActionWithIndex:(NSInteger)index {
    if (index == 0) {
        PVShareViewController *shareController = [[PVShareViewController alloc] init];
        PVShareModel *shareModel = [[PVShareModel alloc] init];
        shareModel.sharetitle = self.webTitle;
        shareModel.h5Url = self.webUrl;
        shareModel.videoUrl = self.webUrl;
        
        shareController.shareModel = shareModel;
        shareController.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController presentViewController:shareController animated:NO completion:nil];
       
    }
    if (index == 1) {
        [self.webView reload];
    }
}



-(void)loadData{
    if (self.webUrl.length == 0) {
        return;
    }
    [PVNetTool getDataWithUrl:self.webUrl success:^(id result) {
        if (result[@"title"] && [result[@"title"] isKindOfClass:[NSString class]]) {
            self.webTitle = result[@"title"];
        }
        if (result[@"atcTitle"] && [result[@"atcTitle"] isKindOfClass:[NSString class]]) {
            self.webTitle = result[@"atcTitle"];
        }
        if (result[@"url"] && [result[@"url"] isKindOfClass:[NSString class]]) {
            self.webUrl = result[@"url"];
        }
        [self loadH5Data];
    } failure:^(NSError *error) {
        PVLog(@"--------error--------%@-",error);
    }];
}

-(void)loadH5Data{
    self.scNavigationItem.title = self.webTitle;
    if (self.webUrl.length == 0 || ![self.webUrl hasPrefix:@"http:"]) {
        PVLog(@"缺少链接");
        return;
    }
    NSURL* url = [NSURL URLWithString:self.webUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.webView loadRequest:request];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = self.webTitle;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        float estimateProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self.progress setProgress:estimateProgress animated:YES];
    }
}

#pragma mark - WKNavigationDelegate
/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.progress setHidden:NO];
    [self.progress setProgress:0.1 animated:YES];
}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progress setProgress:1.0 animated:YES];
    [self.progress setHidden:YES];
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progress setHidden:YES];
}

- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progress.frame = CGRectMake(0, kNavBarHeight, self.webView.sc_width, 2);
        _progress.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view insertSubview:_progress aboveSubview:self.scNavigationBar];
    }
    return _progress;
}

-(WKWebView *)webView{
    if (!_webView) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+2, kScreenWidth, kScreenHeight - kNavBarHeight - 2)];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _webView.scrollView.showsVerticalScrollIndicator = false;
        _webView.scrollView.showsHorizontalScrollIndicator = false;
        
        DisableAutoAdjustScrollViewInsets(_webView.scrollView, self);
//        [self.view insertSubview:_webView belowSubview:self.scNavigationBar];
//        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
    }
    return _webView;
}


@end
