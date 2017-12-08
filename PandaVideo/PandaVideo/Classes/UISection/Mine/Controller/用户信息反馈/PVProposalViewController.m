//
//  PVProposalViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVProposalViewController.h"
#import "PVTextView.h"
#import "PVProposalCollectionViewCell.h"
#import "PVPhotoModel.h"
#import "PVPhotoSelectedViewController.h"

static NSString* resuPVProposalCollectionViewCell = @"resuPVProposalCollectionViewCell";

@interface PVProposalViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (weak, nonatomic) IBOutlet PVTextView *proposalTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *proposalCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *proposalTextFiled;
@property (nonatomic, strong)NSMutableArray* dataSource;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;


@end

@implementation PVProposalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLayout.constant = kNavBarHeight;
    [self setupUI];
    
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"意见反馈";
    self.automaticallyAdjustsScrollViewInsets = false;
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    self.proposalTextView.placehoder = @"请输入您的宝贵意见，帮助我们进步……";
    self.proposalCollectionView.dataSource = self;
    self.proposalCollectionView.delegate = self;
    
    [self.proposalCollectionView registerNib:[UINib nibWithNibName:@"PVProposalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVProposalCollectionViewCell];
    self.proposalCollectionView.showsHorizontalScrollIndicator = NO;
    self.determineBtn.clipsToBounds = true;
    self.determineBtn.layer.cornerRadius = 20;
    self.proposalTextFiled.text = [PVUserModel shared].userId;
}
/// MARK:- ===== UICollectionViewDataSource,UICollectionViewDelegate =====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count == 6) return 5;
    return  self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PVProposalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVProposalCollectionViewCell forIndexPath:indexPath];
//    if (self.dataSource.count == 6) {
//        cell.photoModel = [self.dataSource sc_safeObjectAtIndex:(indexPath.item + 1)];
//    }else {
        cell.photoModel = [self.dataSource sc_safeObjectAtIndex:indexPath.item];
//    }
    
    
    PV(pv)
    [cell setPVProposalCollectionViewCellBlock:^{//删除照片
        PVPhotoModel* model = [pv.dataSource sc_safeObjectAtIndex:indexPath.item];;
//        [self analysisImageArrayWithImageModel:model isAdd:NO];
//        model.image = nil;
//        model.imageUrl = nil;
//        if (model.image == nil || pv.dataSource.count == 6) {
//            PVPhotoModel *twoModel = [pv.dataSource sc_safeObjectAtIndex:(indexPath.item + 1)];
//            [self.dataSource removeObject:twoModel];
//        }else {
            [self.dataSource removeObject:model];
//        }
        
        [collectionView reloadData];
    }];
    
    return cell;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat margin = 6;
    CGFloat width = (ScreenWidth-margin*(self.dataSource.count-1)-20)/5;
    return CGSizeMake(width,width);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,10,0,10);
}
//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    PV(pv)
    PVPhotoModel* model;
//    if (self.dataSource.count == 6) {
//        model = [self.dataSource sc_safeObjectAtIndex:(indexPath.item + 1)];
//    }else {
        model = self.dataSource[indexPath.item];
//    }
    
    if (model.image) {
        //修改照片
        [self isModifyOrSelectPhoto:^(UIImage *image) {
            model.image = image;
            [collectionView reloadData];
            [pv dismissViewControllerAnimated:false completion:nil];
        }];
    }else {
        //选照片
        if (self.dataSource.count == 6) {
            Toast(@"最多只能上传5张照片");
            return;
        }
        [self isModifyOrSelectPhoto:^(UIImage *image) {
            PVPhotoModel *model = [[PVPhotoModel alloc] init];
            model.image = image;
//            [pv.dataSource addObject:model];
            [pv.dataSource insertObject:model atIndex:0];

            [collectionView reloadData];
//            [pv analysisImageArrayWithImageModel:model isAdd:YES];
            [pv dismissViewControllerAnimated:false completion:nil];
        }];
    }
}

-(void)isModifyOrSelectPhoto:(PVPhotoSelectedViewControllerBlock)block{
    PV(pv)
    dispatch_async(dispatch_get_main_queue(), ^{
        PVPhotoSelectedViewController* vc = [[PVPhotoSelectedViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [vc setPVPhotoSelectedViewControllerBlock:block];
        [pv presentViewController:vc animated:NO completion:nil];
    });
}


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:5];
            PVPhotoModel* model = [[PVPhotoModel alloc]  init];
            model.isLast = true;
            [_dataSource addObject:model];
    }
    return _dataSource;
}

- (IBAction)determineBtnClicked {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (self.proposalTextFiled.text.length == 0) {
        Toast(@"请输入联系方式");
        return;
    }
    
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (PVPhotoModel *model in self.dataSource) {
        if (model.image) {
            [imagesArray addObject:model];
        }
    }
    
    if (imagesArray.count == 0 && self.proposalTextView.text.length == 0) {
        Toast(@"请填写相关反馈内容");
        return;
    }
    
    if (imagesArray.count == 0 && self.proposalTextView.text.length != 0) {
        dict = [NSMutableDictionary dictionaryWithDictionary: @{@"content":self.proposalTextView.text, @"phone":self.proposalTextFiled.text, @"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId}];
        [self uploadTextInfoWithPara:dict];
    }
    
    
    if (imagesArray.count != 0 && self.proposalTextView.text.length == 0) {
        dict = [NSMutableDictionary dictionaryWithDictionary:@{ @"phone":self.proposalTextFiled.text, @"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId,@"content":@""}];
     [self uploadImagesWithTextInfo:dict];
    }
    
    if (imagesArray.count != 0 && self.proposalTextView.text.length != 0 && self.proposalTextFiled.text.length != 0) {
        dict = [NSMutableDictionary dictionaryWithDictionary:@{@"content":self.proposalTextView.text,@"phone":self.proposalTextFiled.text, @"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId}];
        [self uploadImagesWithTextInfo:dict];
    }
}

- (void)uploadTextInfoWithPara:(NSDictionary *)dict {
    [PVNetTool postDataHaveTokenWithParams:dict url:commitFeedback success:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200){
                Toast(@"信息反馈成功");
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                NSString *errmsg = [responseObject pv_objectForKey:@"errorMsg"];
                if (errmsg.length > 0) {
                    Toast(errmsg);
                }else {
                    Toast(@"信息反馈失败");
                }
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            Toast(@"信息反馈失败");
        }
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        
    }];
}

- (void)uploadImagesWithTextInfo:(NSDictionary *)infoDict {
    NSDictionary *dict = @{@"type":@(0)};
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (PVPhotoModel *photoModel in self.dataSource) {
        if (photoModel.image) {
            [imagesArray addObject:photoModel.image];
        }
    }
    [PVNetTool postImageArrayWithUrl:uploadFile parammeter:dict image:imagesArray success:^(NSArray *result) {
        if (result.count > 0) {
            NSString *urlStr = [NSString new];
            for (NSString *imageUrl in result) {
              urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@,",imageUrl]];
            }
            [infoDict setValue:urlStr forKey:@"images"];
            [self uploadTextInfoWithPara:infoDict];
        }
    } failure:^(NSArray *errorResult) {
        if (errorResult.count == imagesArray.count) {
            Toast(@"图片上传失败");
        }
        
    }];
    
   
}



@end
