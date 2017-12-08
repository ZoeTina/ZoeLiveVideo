//
//  PVBaseWebViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "PVNoticeInfoModel.h"

@interface PVBaseWebViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UIActivityIndicatorView *waitView;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, copy) UILabel *titleLabel;
@property (nonatomic, copy) UILabel *timeLabel;
@end

@implementation PVBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    self.baseTopView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.UIDelegate = nil;
}

- (instancetype)initWebViewWithUrl:(NSString *)urlString title:(NSString *)title{
    self = [super init];
    if (self) {
        self.scNavigationItem.title = title;
        if ((!urlString || [urlString isEqualToString:@""])) {
            self.urlStr = @"http://";
        }else {
            self.urlStr = urlString;
            if ([urlString containsString:@"json"]) {
                [self loadH5DataWithUrl:urlString];
            }else {
                [self loadWebView];
            }
        }
    }
    return self;
}

- (void)initUI {
    [self.view addSubview:self.progress];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.wkWebView];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(kNavBarHeight);
        make.height.mas_equalTo(2);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(IPHONE6WH(12));
        make.top.equalTo(self.progress.mas_bottom).mas_offset(IPHONE6WH(13));
        make.right.mas_offset(-IPHONE6WH(12));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(IPHONE6WH(7));
    }];
    
    if ([self.urlStr containsString:@"json"]) {
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.top.equalTo(self.timeLabel.mas_bottom).mas_offset(15);
        }];
    }else {
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.top.equalTo(self.progress.mas_bottom).mas_offset(0);
        }];
    }
}

- (void)loadH5DataWithUrl:(NSString *)urlStr {
    [PVNetTool getDataWithUrl:urlStr success:^(id result) {
        if (result) {
            PVNoticeInfoDetailModel *noticeDetailModel = [PVNoticeInfoDetailModel yy_modelWithDictionary:result];
            self.urlStr = noticeDetailModel.htmlUrl;
            self.titleLabel.text = noticeDetailModel.title;
            self.timeLabel.text = noticeDetailModel.createTime;
            [self loadWebView];
        }
    } failure:^(NSError *error) {
        if (error) {
            
        }
    }];
}

- (void)loadWebView {
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}

//重写父类方法
- (void)leftItemClick:(UIButton *)sender {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        _progress.frame = CGRectZero;
        _progress.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view insertSubview:_progress aboveSubview:self.scNavigationBar];
        
    }
    return _progress;
}


- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        
//        self.automaticallyAdjustsScrollViewInsets = NO;
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 15.0;
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


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel sc_labelWithText:@"" fontSize:15 textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel sc_labelWithText:@"" fontSize:11 textColor:UIColorHexString(0x808080) alignment:NSTextAlignmentLeft];
        _timeLabel.backgroundColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

