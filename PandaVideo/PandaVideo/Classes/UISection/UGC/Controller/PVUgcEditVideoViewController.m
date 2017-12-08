//
//  PVUgcEditVideoViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUgcEditVideoViewController.h"
#import "LZImageManager.h"
#import "SCImageManager.h"
#import "PVDBManager.h"
#import "PVWebViewController.h"
#import "PVUGCBeginUploadViewController.h"
#import "PVUploadVideoTool.h"
#import "PVRegionFlowController.h"

@interface PVUgcEditVideoViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *imageCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *descriptCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *publishCell;
@property (weak, nonatomic) IBOutlet UITableView *ugcTableView;
@property (weak, nonatomic) IBOutlet UIImageView *corverImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *desctiptTextView;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIImageView *topicIconImageView;


//@property (nonatomic, strong) UIImage *corverImage;
@property (nonatomic, strong) NSData *videoData;
//@property (nonatomic, strong) PVUGCVideoInfo *videoInfo;
@property (nonatomic, assign) BOOL isUpload;
@end

@implementation PVUgcEditVideoViewController

- (void)canclePostNetwork {
    [PVNetTool cancelCurrentRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scNavigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.scNavigationBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // app被杀死
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationTerminate) name:UIApplicationWillTerminateNotification object:nil];
    // 进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];

    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canclePostNetwork) name:@"canclePostNetwork" object:nil];
    [self.view insertSubview:self.ugcTableView aboveSubview:self.scNavigationBar];
    [self.view insertSubview:self.testButton aboveSubview:self.ugcTableView];
}

- (void)applicationTerminate {
    NSArray *assetArray = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    for (SCAssetModel *assetModel in assetArray) {
        if ([assetModel.videoPublishState isEqualToString:@"0"] || [assetModel.videoPublishState isEqualToString:@"2"]) {
            [[[PVUploadVideoTool alloc] init] postNoticicationWithState:@"3" assetModel:assetModel];
        }
    }
}
- (void)applicationEnterBackground {
    NSArray *assetArray = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    for (SCAssetModel *assetModel in assetArray) {
        if ([assetModel.videoPublishState isEqualToString:@"0"] || [assetModel.videoPublishState isEqualToString:@"2"]) {
            [[[PVUploadVideoTool alloc] init] postNoticicationWithState:@"3" assetModel:assetModel];
        }
    }
}

- (void)setupUI {
    self.ugcTableView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight, 0);
    self.ugcTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.desctiptTextView.delegate = self;
    self.titleField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeVideoCorverImage)];
    [self.corverImageView addGestureRecognizer:tap];
    self.corverImageView.userInteractionEnabled = YES;
    
    self.placeholderLabel.text = _editUgcModel.desc;
    [self.topicIconImageView sc_setImageWithUrlString:_editUgcModel.icon placeholderImage:[UIImage imageNamed:@""] isAvatar:false];
    self.titleField.placeholder = _editUgcModel.name;
    if (_assetModel.corverImage) {
        self.corverImageView.image = _assetModel.corverImage;
    }

}

- (void)setAssetModel:(SCAssetModel *)assetModel {
    _assetModel = assetModel;
   
}


/**
 ugcModel

 @param editUgcModel ugcModel
 */
- (void)setEditUgcModel:(PVUGCModel *)editUgcModel {
    _editUgcModel = editUgcModel;
    
}

/**
 获取视频信息

 @param sender 视频
 */
- (IBAction)getVideoModels:(id)sender {
    NSArray *array = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    self.assetModel = array.lastObject;
    [self asyncConcurrent];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.publishButton.layer.masksToBounds = YES;
    self.publishButton.layer.cornerRadius = self.publishButton.sc_height / 2.;
}

/**
 返回按钮事件

 @param sender 返回按钮
 */
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 更换视频封面
 */
- (void)changeVideoCorverImage {
    CGFloat width = AUTOLAYOUTSIZE(327);
    CGFloat height = AUTOLAYOUTSIZE(185);
    PV(weakSelf);
    [[LZImageManager sharedManager] getSquareImageInVC:self
                                              withSize:CGSizeMake(width, height)
                                          withCallback:^(UIImage *image) {
                                              weakSelf.corverImageView.image = image;
                                              weakSelf.assetModel.corverImage = image;
                                          }];
}


/**
 是否同意用户协议

 @param sender 用户协议按钮
 */
- (IBAction)agreeProtocolButtonClick:(id)sender {
    self.agreeButton.selected = !self.agreeButton.selected;
}


/**
 查看用户协议

 @param sender 用户协议按钮
 */
- (IBAction)lookProtocol:(id)sender {
    PVWebViewController *webCon = [[PVWebViewController alloc] initWebViewControllerWithWebUrl:self.editUgcModel.protocol webTitle:@"熊猫视频内容上传协议"];
    [self.navigationController pushViewController:webCon animated:YES];
}

/**
 视频发布

 @param sender 发布按钮
 */
- (IBAction)publishButtonClick:(id)sender {
    if (self.titleField.text.length == 0) {
        Toast(@"请输入视频名称");
        return;
    }
    
    if (self.agreeButton.selected) {
        Toast(@"请同意用户相关协议");
        return;
    }
   
    self.assetModel.createTime = [NSString stringWithFormat:@"%@",self.assetModel.asset.creationDate];
    if (self.assetModel.publishTime.length == 0) {
        self.assetModel.publishTime = [NSDate PVDateToStringTime:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    if ([SCSmallTool stringContainsEmoji:self.titleField.text]) {
        Toast(@"视频标题不能含有表情符");
        return;
    }
    
    if (self.desctiptTextView.text.length > 0 && [SCSmallTool stringContainsEmoji:self.desctiptTextView.text]) {
        Toast(@"视频描述信息不能包含表情符");
        return;
    }
    
    //用于保存数据库的视频信息数据
    self.assetModel.videoTitle = self.titleField.text;
    self.assetModel.videoCorverImage = @"asdasd";
    self.assetModel.videoDescTitle = self.desctiptTextView.text;
    self.assetModel.videoInfo = [[PVUGCVideoInfo alloc] init];
    
    //用于上传后台的视频信息数据
    self.assetModel.videoInfo.videoTitle = self.titleField.text;
    self.assetModel.videoInfo.videoDes = self.desctiptTextView.text;
    self.assetModel.videoInfo.videoDuration = [[NSString getIntervalWithTimeStr:self.assetModel.timeLength] integerValue];
    self.assetModel.videoInfo.ugcId = self.editUgcModel.id;
    [self judgeNetworkState];
}



/**
 视频上传状态， 0:压缩中，1:压缩失败，2:上传中，3:封面图上传失败，4.封面图上传成功，视频上传失败 5:视频上传成功，但是其他视频信息上传失败,6:上传成功
 压缩视频成功---->保存数据库
 压缩视频失败---->将视频model保存起来，并将压缩失败记录保存数据库
 */
- (void)asyncConcurrent {
    if (self.assetModel) {
//        [[PVProgressHUD shared] showHudInView:self.view];
        dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            
            //压缩中的视频
            [self postNoticicationWithState:@"0"];
            
            [[SCImageManager manager] getVideoOutputPathWithAsset:self.assetModel.asset createTime:self.assetModel.createTime publishTime:self.assetModel.publishTime completion:^(NSData *videoData) { //压缩并上传
                if (videoData) {
                    self.videoData = videoData;
                    [self uploadCorverImageWithImageData:self.assetModel.corverImage];
                }else {
                    [self postNoticicationWithState:@"1"];
                    
                    //取消线程会崩
//                    dispatch_suspend(queue);
                }
            }];
        });
        PVUGCBeginUploadViewController *uploadCon = [[PVUGCBeginUploadViewController alloc] init];
        [self.navigationController pushViewController:uploadCon animated:YES];
    }else {
        Toast(@"视频数据为空");
    }
}


/**
 上传视频封面图片

 @param corverImage 封面图片
 */
- (void)uploadCorverImageWithImageData:(UIImage *)corverImage {
    [self postNoticicationWithState:@"2"];
    
    NSDictionary *dict = @{@"type":@(0),@"videoTitle":self.self.assetModel.videoTitle};
    [PVNetTool postImageWithUrl:ugcUploadFile parammeter:dict image:corverImage success:^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                self.assetModel.videoInfo.videoImg = [[result pv_objectForKey:@"data"] pv_objectForKey:@"url"];
                [self uploadVideoDataWithVideoData:self.videoData];
            }else {
                Toast([result pv_objectForKey:@"errorMsg"]);
                [self postNoticicationWithState:@"3"];
            }
        }else {
            [self postNoticicationWithState:@"3"];
        }
    } failure:^(NSError *error) {
        [self postNoticicationWithState:@"3"];
    }];
}


/**
 上传视频数据

 @param data 视频二进制
 */
- (void)uploadVideoDataWithVideoData:(NSData *)data {
    
    [self postNoticicationWithState:@"2"];
    
    NSDictionary *dict = @{@"type":@(1),@"videoTitle":self.self.assetModel.videoTitle};

    [PVNetTool uploadVideoDataWithUrl:ugcUploadFile Parameter:dict withVideoData:self.videoData SuccessBlock:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                self.assetModel.videoInfo.videoUrl = [[responseObject pv_objectForKey:@"data"] pv_objectForKey:@"url"];
                 [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@", self.assetModel.publishTime] error:nil];
                [self uploadUGCVideoInfo];
            }else {
                [self postNoticicationWithState:@"4"];
            }
        }
    } FailureBlock:^(NSError *error) {
        if (error) {
            [self postNoticicationWithState:@"4"];
        }
    }];
}

- (void)uploadUGCVideoInfo {
    [self postNoticicationWithState:@"2"];
    
    NSDictionary *videoINfoDict = @{@"tag":@[],@"videoDes":self.assetModel.videoInfo.videoDes,@"videoDuration":@(self.assetModel.videoInfo.videoDuration),@"videoImg":self.assetModel.videoInfo.videoImg,@"videoTitle":self.assetModel.videoInfo.videoTitle,@"videoUrl":self.assetModel.videoInfo.videoUrl};
    NSString *jsonStr = [videoINfoDict yy_modelToJSONString];
    NSDictionary *dict = @{@"token":huangToken,@"userId":huangUserId,@"ugcId":@(self.assetModel.videoInfo.ugcId),@"videoInfo":jsonStr};

    NSString *paraJson = [dict yy_modelToJSONString];
    
    [PVNetTool postBodyDataURLString:postUgcInfo parameter:paraJson success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                [self postNoticicationWithState:@"6"];
            }else {
                [self postNoticicationWithState:@"5"];
            }
        }else {
            [self postNoticicationWithState:@"5"];
        }
    } failure:^(NSError *error) {
        if (error) {
            [self postNoticicationWithState:@"5"];
        }
    }];
    
}

- (void)postNoticicationWithState:(NSString *)state {
    self.assetModel.videoPublishState = state;
    self.assetModel.corverImageData = UIImageJPEGRepresentation(self.assetModel.corverImage, 0.6);
    self.assetModel.assetInentifier = self.assetModel.asset.localIdentifier;
    
    [[[PVUploadVideoTool alloc] init] postNoticicationWithState:state assetModel:self.assetModel];
}

- (void)judgeNetworkState {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        Toast(@"请检查网络状态是否正常");
        return;
    }
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        if ([PVMineConfigModel shared].netUploadingTips) {
            PVAlertModel *model = [[PVAlertModel alloc] init];
            model.cancleButtonName = @"取消";
            model.eventName = @"上传";
            model.alertType = OnlyText;
            model.descript = @"非Wi-Fi环境,继续上传视频将消耗您的数据流量,是否继续上传?";
            PVFamilyCircleAlertControlelr *controller = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:model];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self.navigationController presentViewController:controller animated:NO completion:nil];
            
            __weak PVFamilyCircleAlertControlelr *weakAlertCon = controller;
            [controller setAlertViewSureEventBlock:^(id sender) {
               [self asyncConcurrent];
                [weakAlertCon dismissViewControllerAnimated:NO completion:nil];
            }];
        }else {
            Toast(@"当前是数据网络，请到设置中打开流量上传开关");
        }
    }else{
        [self asyncConcurrent];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.desctiptTextView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.titleField.textColor = [UIColor blackColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.titleField.textColor = UIColorHexString(0xD7D7D7);
    if (self.titleField.text.length > 0 && ![self.titleField.text isEqualToString:_editUgcModel.name]) {
        self.titleField.textColor = [UIColor blackColor];
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PVPersonalInfoViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row == 0) {
        _imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _imageCell;
    }
    if (indexPath.row == 1) {
        _titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _titleCell;
    }
    if (indexPath.row == 2) {
        _descriptCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _descriptCell;
    }
    if (indexPath.row == 3) {
        _publishCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _publishCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kDistanceHeightRatio(270);
    }
    if (indexPath.row == 1) {
        return kDistanceHeightRatio(100);
    }
    if (indexPath.row == 2) {
        return kDistanceHeightRatio(180);
    }
    if (indexPath.row == 3) {
        return kDistanceHeightRatio(93);
    }
    return 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
