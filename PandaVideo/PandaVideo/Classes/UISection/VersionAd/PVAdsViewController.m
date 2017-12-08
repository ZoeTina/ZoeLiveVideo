//
//  PVAdsViewController.m
//  PandaVideo
//
//  Created by songxf on 2017/10/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAdsViewController.h"
#import "SCMainViewController.h"
#import "PVADsModel.h"
@interface PVAdsViewController ()<UIViewControllerTransitioningDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIButton *skipButton;
@property(nonatomic,strong)UIImageView * bottomImageView;
@property(nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,assign)NSInteger currentTime;//当前时间（几秒后跳过）
@property(nonatomic,assign)NSInteger currentPage;//当前页数
@end

@implementation PVAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentTime = 3;
    self.currentPage = 0;
    [self setupUI];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"启动页-无广告"]];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    self.bottomImageView = imageView;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.equalTo(@88.5);
    }];
    [self startTimer];
    // Do any additional setup after loading the view.
}
- (void)dealloc{
    [self stopTimer];
}
- (void)setupUI{
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.skipButton];
    for (NSInteger i = 0; i < self.adsArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight)];
        PVADsModel * model = [self.adsArray sc_safeObjectAtIndex:i];
        [imgView sc_setImageWithUrlString:model.imageUrl placeholderImage:[UIImage imageNamed:@"guide_img_banner"] isAvatar:false];
        imgView.tag = 1150 + i;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickSkipUrl:)]];
        [self.scrollView addSubview:imgView];
    }
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
//        make.bottom.equalTo(self.bottomImageView.mas_top);
    }];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(44);
        make.height.equalTo(@20);
        make.width.equalTo(@62);
    }];
}
- (void)btnClickSkipUrl:(UIImageView *)imageView{
    NSInteger index = imageView.tag -  1150;
    PVADsModel * model = [self.adsArray sc_safeObjectAtIndex:index];
    NSString * url = model.jumpUrl;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳过事件
- (void)skipBtnClick{
    [self setMainViewController];
}
//设置主页界面
- (void)setMainViewController{
    [self stopTimer];
    [self dismissViewControllerAnimated:NO completion:^{
        SCMainViewController * mainViewController = [[SCMainViewController alloc] init];
        kAppDelegate.window.rootViewController = mainViewController;
    }];
//    __weak typeof(self) weakSelf = self;
//    [self presentViewController:mainViewController animated:NO completion:^{
    
//        [weakSelf removeFromParentViewController];
//        [weakSelf.scrollView removeFromSuperview];
//        weakSelf.scrollView = nil;
//        [weakSelf.bottomImageView removeFromSuperview];
//        [weakSelf.skipButton removeFromSuperview];
//        weakSelf.bottomImageView = nil;
//        weakSelf.skipButton = nil;
//    }];
}

#pragma mark -- Timer
- (void)startTimer{
    self.timer =[NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerSelector) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)timerSelector{
    self.currentTime = self.currentTime - 1;
    if (self.currentTime == 0) {
        if (self.currentPage >= self.adsArray.count - 1) {
            [self setMainViewController];
            return ;
        }
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth *(self.currentPage + 1), 0) animated:YES];
        self.currentTime = 3;
        self.currentPage = self.currentPage + 1;
    }
    [self.skipButton setTitle:[NSString stringWithFormat:@"%lds 跳过",self.currentTime] forState:UIControlStateNormal];
}
#pragma mark -- getter,setter
- (UIButton *)skipButton{
    if (_skipButton == nil) {
        _skipButton = [[UIButton alloc] init];
        [_skipButton setTitle:@"3s 跳过" forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipButton.backgroundColor = [UIColor sc_colorWithHex:0x000000];
        [_skipButton addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.layer.cornerRadius = 10;
    }
    return _skipButton;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = true;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.contentSize = CGSizeMake(kScreenWidth * self.adsArray.count, 0);
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

#pragma make -- scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.currentPage = index;
    self.currentTime = 3;
    [self.skipButton setTitle:[NSString stringWithFormat:@"%lds 跳过",self.currentTime] forState:UIControlStateNormal];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
