//
//  PVLiveStreamActivityViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveStreamActivityViewController.h"
#import "LZKeyboardAvoidingScrollView.h"

@interface PVLiveStreamActivityViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, assign) CGSize sizeH;
@property (nonatomic, strong) LZKeyboardAvoidingScrollView *mainScrollView;
@property (nonatomic, strong) IBOutlet UIView *titleView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *closeBtn;

@end

@implementation PVLiveStreamActivityViewController

-(void)setURLString:(NSString *)URLString{
    _URLString = URLString;

    NSString *token = @"";
    NSString *userId = @"";
    if (kUserInfo.isLogin) {
        userId = kUserInfo.userId;
        token = kUserInfo.token;

    }
    NSString *strURL = [NSString stringWithFormat:@"%@?platform=1&token=%@&userId=%@",self.URLString,token,userId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];//创建NSURLRequest
    
    [self.webView loadRequest:request];//加载
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, kScreenWidth, _currentHeigh);
    [self.view addSubview:self.mainScrollView];

    [self.mainScrollView addSubview:self.webView];
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL

    
}
- (IBAction)backBtnClicked:(id)sender {
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = kScreenHeight;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
}
- (void)setCurrentHeigh:(CGFloat)currentHeigh{
    _currentHeigh = currentHeigh;
    YYLog(@"currentHeigh -- %f",currentHeigh);
}

// 数据加载完 - 网页加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //自动适应webview高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    NSString *theTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titleLabel.text = theTitle;
    self.sizeH = fittingSize;
}

// 当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型。
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

// 滑动后隐藏键盘
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [scrollView endEditing:YES];
}


#pragma mark - Setter/Getter
- (LZKeyboardAvoidingScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[LZKeyboardAvoidingScrollView alloc] init];
        _mainScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), kScreenWidth, _currentHeigh-self.titleView.sc_height);
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.backgroundColor = [UIColor clearColor];
    }
    return _mainScrollView;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = self.mainScrollView.bounds;
        _webView.backgroundColor = [UIColor clearColor];
    }
    return _webView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
