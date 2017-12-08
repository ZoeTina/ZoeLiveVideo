//
//  PVFamilyCircleAlertControlelr.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//


//PVAlertModel *model = [[PVAlertModel alloc] init];
//model.alertType = OnlyText;
////    model.alertTitle = @"对方电视端未授权";
//model.descript = @"通知对方打开“允许家庭通知对方打开“允许";
//model.imageName = @"1.jpg";
//model.cancleButtonName = @"取消";
//model.eventName = @"知道了";
//model.imagePosition = Right;
//PVFamilyCircleAlertControlelr *con = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:model];
//
////    [con initCancelButtonName:@"知道了" eventButtonName:@"打电话"];
//[con setAlertViewSureEventBlock:^{
//    SCLog(@"------点击事件响应啦--------");
//}];
//
//[con setAlertCancleEventBlock:^{
//    [con.navigationController popViewControllerAnimated:YES];
//}];
//[self.navigationController pushViewController:con animated:YES];
#import "PVFamilyCircleAlertControlelr.h"
#import "PVOnlyTextView.h"
#import "PVImageAndTextView.h"
#import "PVBottomAlertView.h"

@interface PVFamilyCircleAlertControlelr () <PVOnlyTextViewDelegate, PVImageAndTextViewDelegate, PVBottomAlertViewDelegate>

@property (nonatomic, copy) AlertViewEventBlock eventBlock;
@property (nonatomic, copy) AlertViewEventBlock cancleBlock;
@property (nonatomic, strong) PVAlertModel *alertModel;
@end

@implementation PVFamilyCircleAlertControlelr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addLayerView];
    
}

//初始化，根据model的弹窗类型，确定加载的弹窗类型
- (instancetype)initAlertViewModel:(PVAlertModel *)alertModel {
    self = [super init];
    if (self) {
        self.alertModel = alertModel;
        if (self.alertModel.alertType == OnlyText) {
            [self addOnlyTextView];
        }
        if (self.alertModel.alertType == ImageAndText) {
            [self addImageAndTextView];
        }
        if (self.alertModel.alertType == BottomAlert) {
            [self addBottomView];
        }
        
    }
    return self;
}


//加载文字弹窗，并设置弹窗代理
- (void)addOnlyTextView {
    PVOnlyTextView *textView = [[PVOnlyTextView  alloc] initOnlyTextViewWithFrame:CGRectZero];
    textView.delegate = self;
    [self.view addSubview:textView];
    
    textView.alertTitle = self.alertModel.alertTitle;
    textView.descript = self.alertModel.descript;
    [textView initCancelButtonName:self.alertModel.cancleButtonName eventButtonName:self.alertModel.eventName];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(IPHONE6WH(191));
        make.left.mas_offset(IPHONE6WH(13));
        make.right.mas_offset(-IPHONE6WH(13));
        make.height.mas_equalTo(IPHONE6WH(180));
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
}

//加载图文弹窗
- (void)addImageAndTextView {
    PVImageAndTextView *imageAndTextView = [[PVImageAndTextView alloc] initImageAndTextViewWithFrame:CGRectZero];
    imageAndTextView.delegate = self;
    [self.view addSubview:imageAndTextView];
    
    imageAndTextView.alertTitle = self.alertModel.alertTitle;
    imageAndTextView.descript = self.alertModel.descript;
    imageAndTextView.imageName = self.alertModel.imageName;
    imageAndTextView.imagePosition = self.alertModel.imagePosition;
    [imageAndTextView initCancelButtonName:self.alertModel.cancleButtonName eventButtonName:self.alertModel.eventName];
    
    [imageAndTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(IPHONE6WH(59));
        make.left.mas_equalTo(IPHONE6WH(13));
        make.right.mas_equalTo(-IPHONE6WH(13));
        make.height.mas_equalTo(IPHONE6WH(373));
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
}

- (void)addBottomView {
    PVBottomAlertView *bottomAlertView = [[PVBottomAlertView alloc] initWithFrame:CGRectZero ImagesArray:self.alertModel.imagesArray textsArray:self.alertModel.imagesTextArray];
    NSInteger rows = ceilf(self.alertModel.imagesArray.count / 3.0);
    CGFloat height = rows * IPHONE6WH(102) + IPHONE6WH(19) + 4 + IPHONE6WH(51) + SafeAreaBottomHeight;
    [self.view addSubview:bottomAlertView];
    bottomAlertView.delegate = self;
    [bottomAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(height);
    }];
}
//弹窗底部视图，可以不加，也可以设置为透明
- (void)addLayerView {
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    layerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:layerView];
}


/**确定按钮的点击事件**/
- (void)setAlertViewSureEventBlock:(AlertViewEventBlock)eventBlock {
    self.eventBlock = eventBlock;
}

/**取消按钮的点击事件**/
- (void)setAlertCancleEventBlock:(AlertViewEventBlock)cancleBlock {
    self.cancleBlock = cancleBlock;
}

#pragma mark - 只有文字弹框的代理方法
- (void)onlyTextViewCancelButtonClick {
    if (self.cancleBlock) {
        self.cancleBlock(self);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)onlyTextViewSureButtonClick {
    if (self.eventBlock) {
       self.eventBlock(self);
    }
}

#pragma mark - 图文弹框的代理方法
- (void)imageAndTextCancelButtonClick {
    if (self.cancleBlock) {
        self.cancleBlock(self);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)imageAndTextSureButtonClick {
    if (self.eventBlock) {
        self.eventBlock(self);
    }
}

- (void)PVBottomAlertViewCancleButtonClick {
    if (self.cancleBlock) {
        self.cancleBlock(self);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
