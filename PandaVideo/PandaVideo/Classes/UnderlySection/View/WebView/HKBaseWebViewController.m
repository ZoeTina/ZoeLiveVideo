//
//  HKBaseWebViewController.m
//  HKBicycle
//
//  Created by macy on 17/3/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HKBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "HKShareView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HKActivityCenterModel.h"

#define kShareviewHeight 220

enum {
    SVWebViewControllerAvailableActionsNone             = 0,
    SVWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    SVWebViewControllerAvailableActionsMailLink         = 1 << 1,
    SVWebViewControllerAvailableActionsCopyLink         = 1 << 2
};

@interface HKBaseWebViewController ()<WKNavigationDelegate, UIActionSheetDelegate,WKUIDelegate, WKScriptMessageHandler,HKShareViewDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, strong) UIProgressView *progress;

@property (nonatomic, strong) UIActivityIndicatorView *waitView;

@property (nonatomic, copy) NSString *urlStr;

// ToolBar

@property (nonatomic, strong) UIBarButtonItem *backButtonItem;

@property (nonatomic, strong) UIBarButtonItem *forwardButtonItem;

@property (nonatomic, strong) UIBarButtonItem *refreshButtonItem;

@property (nonatomic, strong) UIBarButtonItem *stopButtonItem;

@property (nonatomic, strong) UIBarButtonItem *actionButtonItem;

@property (nonatomic, strong) UIActionSheet *pageActionSheet;

@property (nonatomic, assign) BOOL availableActions;

// shareview

@property (nonatomic, strong) HKShareView *shareView;

@end

@implementation HKBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self loadWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"showShareview"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.UIDelegate = nil;
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (instancetype)initWebViewWithURL:(NSString*)urlString
{
    self = [super init];
    if (self) {
        if (!urlString || [urlString isEqualToString:@""]) {
#warning 如果地址为nil，则显示官网地址
            self.urlStr = @"http://";
        } else {
            self.urlStr = urlString;
        }
    }
    
    _hiddenToolbar = YES;
    
    return self;
    
}

- (void)initUI
{
    if (self.titleString && ![self.titleString isEqualToString:@""]) {
        self.title = self.titleString;
    } else {
        self.title = @"KingBike";
    }
    
    [self setLeftNavBarItemWithImage:@"common_back"];
    
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.waitView];
    //[self.view addSubview:self.progress];
    
//    if (YES == self.showShareIcon && self.model.shareModel) {
//        [self setRightNavBarItemWithImage:@"share_icon"];
//        [self.view addSubview:self.shareView];
//        
//    }
    
    if (!self.hiddenToolbar) [self updateToolbar];
}

#pragma mark - shareView

- (void)leftItemClick:(UIButton *)sender
{
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightItemClick:(UIButton *)sender {
    [self showShareview];
}

- (void)showShareview {
    if (self.model.shareModel == nil) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.shareView.frame = CGRectMake(0, SCREENHEIGHT - kShareviewHeight - 64, SCREENWIDTH, kShareviewHeight);
    }];
}

- (void)hideShareview {
    [UIView animateWithDuration:0.5 animations:^{
        self.shareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, kShareviewHeight);
    }];
}

#pragma mark - HKShareViewDelegate

- (void)share:(NSInteger)tag {
    [self hideShareview];
    
    switch (tag) {
        case 100:{
            [LoginAndShareCunstom weixinShare:kShareTool_WeiXinFriends model:self.model];
            break;
        }
        case 101:{
            [LoginAndShareCunstom weixinShare:kShareTool_WeiXinCircleFriends  model:self.model];
            break;
        }
        case 102:{
            [LoginAndShareCunstom QQShare:self.model];
            break;
        }
        case 103:{
            [LoginAndShareCunstom weiboShare:self.model];
            break;
        }
            
        default:
            break;
    }
}

- (void)cancelShare {
    [self hideShareview];
}

#pragma mark -

- (void)loadWebView
{
    //[self.waitView startAnimating];
    [HKProgressHUD showHUDTo:self.wkWebView];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
}

- (void)updateToolbar
{
    self.backButtonItem.enabled = self.wkWebView.canGoBack;
    self.forwardButtonItem.enabled = self.wkWebView.canGoForward;
    self.actionButtonItem.enabled = !self.wkWebView.isLoading;
    
    UIBarButtonItem *refreshStopButtonItem = self.wkWebView.isLoading ? self.stopButtonItem : self.refreshButtonItem;
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 10.f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = @[fixedSpace,
                       self.backButtonItem,
                       flexibleSpace,
                       self.forwardButtonItem,
                       flexibleSpace,
                       refreshStopButtonItem,
                       flexibleSpace,
                       self.actionButtonItem,
                       fixedSpace];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.toolbar setItems:items animated:YES];
}

#pragma mark - Action
- (void)backButtonItemClick
{
    [self.wkWebView goBack];
}

- (void)forwardButtonItemClick
{
    [self.wkWebView goForward];
}

- (void)refreshButtonItemClick
{
    [self.wkWebView reload];
}

- (void)stopButtonItemClick
{
    [self.wkWebView stopLoading];
    if (!self.hiddenToolbar) [self updateToolbar];
}

- (void)actionButtonItemClick
{
    if (self.navigationController.toolbar) {
        [self.pageActionSheet showFromToolbar:self.navigationController.toolbar];
    } else {
        [self.pageActionSheet showInView:self.view];
    }
}

#pragma mark - setter & getter

- (WKWebView*)wkWebView
{
    if (!_wkWebView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0., kScreenWidth, kScreenHeight-64.) configuration:configuration];
       
        
    }
    
    return _wkWebView;
}

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    [self showShareview];
//    completionHandler();
//}



- (UIActivityIndicatorView*)waitView
{
    if (!_waitView) {
        _waitView = [[UIActivityIndicatorView alloc] init];
        _waitView.frame = CGRectMake(0, 0, 100, 100);
        _waitView.center = self.wkWebView.center;
        _waitView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    return _waitView;
}

- (UIProgressView*)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progress.frame = CGRectMake(0, 0, self.wkWebView.width, 3);
        _progress.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _progress;
}

- (UIBarButtonItem*)backButtonItem
{
    if (!_backButtonItem) {
        _backButtonItem = [[UIBarButtonItem alloc] initWithImage:kImage(@"back")
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(backButtonItemClick)];
        _backButtonItem.width = 20.;
    }
    
    return _backButtonItem;
}

- (UIBarButtonItem*)forwardButtonItem
{
    if (!_forwardButtonItem) {
        _forwardButtonItem = [[UIBarButtonItem alloc] initWithImage:kImage(@"forward")
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(forwardButtonItemClick)];
        _forwardButtonItem.width = 20.;
        
    }
    
    return _forwardButtonItem;
}

- (UIBarButtonItem*)refreshButtonItem
{
    if (!_refreshButtonItem) {
        _refreshButtonItem = [[UIBarButtonItem alloc] initWithImage:kImage(@"refresh")
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(refreshButtonItemClick)];
        _refreshButtonItem.width = 20.;
    }
    
    return _refreshButtonItem;
}

- (UIBarButtonItem*)stopButtonItem
{
    if (!_stopButtonItem) {
        _stopButtonItem = [[UIBarButtonItem alloc] initWithImage:kImage(@"stop")
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(stopButtonItemClick)];
        _stopButtonItem.width = 20.;
    }
    
    return _stopButtonItem;
}

- (UIBarButtonItem*)actionButtonItem
{
    if (!_actionButtonItem) {
        _actionButtonItem = [[UIBarButtonItem alloc] initWithImage:kImage(@"action")
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(actionButtonItemClick)];
        _actionButtonItem.width = 20.;
    }
    
    return _actionButtonItem;
}

- (UIActionSheet *)pageActionSheet {
    if (!_pageActionSheet) {
        _pageActionSheet = [[UIActionSheet alloc]
                           initWithTitle:self.wkWebView.URL.absoluteString
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
        
        if ((self.availableActions & SVWebViewControllerAvailableActionsCopyLink) == SVWebViewControllerAvailableActionsCopyLink)
            [_pageActionSheet addButtonWithTitle:@"拷贝当前网页的链接"];
        
        if ((self.availableActions & SVWebViewControllerAvailableActionsOpenInSafari) == SVWebViewControllerAvailableActionsOpenInSafari)
            [_pageActionSheet addButtonWithTitle:@"在Safari浏览器中打开"];
        
        [_pageActionSheet addButtonWithTitle:@"取消"];
        _pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons] - 1;
    }
    
    return _pageActionSheet;
}

- (HKShareView *)shareView {
    if (!_shareView) {
        _shareView = [[HKShareView alloc] init];
        _shareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, kShareviewHeight);
        _shareView.delegate = self;
    }
    
    return _shareView;
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"estimatedProgress"])
    {
        float estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self.progress setProgress:estimatedProgress animated:YES];
    }
}

#pragma mark - WKNavigationDelegate
/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if (![PPNetworkHelper isNetwork]) {
        [HKNetwrongView showView:self sel:@selector(loadWebView)];
        return;
    }
    
    [self.progress setProgress:0.1 animated:YES];
    if (!self.hiddenToolbar) [self updateToolbar];
}

/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{

}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (YES == self.showShareIcon && self.model.shareModel) {
        [self setRightNavBarItemWithImage:@"share_icon"];
        [self.view addSubview:self.shareView];
        
    }
    
    //[self.waitView stopAnimating];
    [HKProgressHUD hideHUDTo:self.wkWebView];
    [self.progress setProgress:1.0 animated:YES];
    [self.progress setHidden:YES];
    if (!self.hiddenToolbar) [self updateToolbar];
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    //[self.waitView stopAnimating];
    [HKProgressHUD hideHUDTo:self.wkWebView];
    [self.progress setHidden:YES];
    if (!self.hiddenToolbar) [self updateToolbar];
    
    [HKNetwrongView showView:self sel:@selector(loadWebView)];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self showShareview];
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:NSLocalizedString(@"在Safari浏览器中打开", @"")])
        [[UIApplication sharedApplication] openURL:self.wkWebView.URL];
    
    if ([title isEqualToString:NSLocalizedString(@"拷贝当前网页的链接", @"")]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.wkWebView.URL.absoluteString;
    }
    
    self.pageActionSheet = nil;
}

@end
