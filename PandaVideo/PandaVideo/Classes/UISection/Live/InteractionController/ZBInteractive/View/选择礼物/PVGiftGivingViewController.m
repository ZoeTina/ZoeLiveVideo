//
//  PVGiftGivingViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVGiftGivingViewController.h"
#import "PVGIftGivingCollectionViewCell.h"
#import "PVSendGiftView.h"
#import "PVFlowLayout.h"
#import "UIControl+Extension.h"
#import "PVIntroduceModel.h"
#import "PVGiftsListModel.h"
#import "LZOptionSelectView.h"
#import "PVLoginViewController.h"
#import "PVHorizontalPageFlowlayout.h"
#import "PVTipsPopoverView.h"
#import "PVPresentViewCell.h"
#import "PVMoneyViewController.h"
#import "PVLoginViewController.h"
static NSString * const identifier = @"HorizontalPageCell";

@interface PVGiftGivingViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    // 礼物标记
    NSInteger _reuse;
    // 送出礼物个数标记
    NSInteger _count;
}
@property (nonatomic, strong) PVTipsPopoverView   *showTipsView;

/** 余额 */
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
/** 头部View */
@property (strong, nonatomic) IBOutlet UIView *headerView;
/** 底部View */
@property (strong, nonatomic) IBOutlet UIView *footerView;
/** 赠送按钮底层View */
@property (strong, nonatomic) IBOutlet UIView *givingView;
/** 选择的礼物数量 */
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
/** 充值按钮 */
@property (strong, nonatomic) IBOutlet UIButton *rechargeBtn;
/** 显示礼物的View */
@property (strong, nonatomic) IBOutlet UIView *showGiftContainerView;
/** collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView *lzCollectionView;
/** pageControl */
@property (strong, nonatomic) UIPageControl *pageControl;
/** 礼物数据(图片) */
@property (nonatomic, strong) NSMutableArray *itemModelArray;
/** 快捷数量数组 */
@property (nonatomic, strong) NSArray *listArray;
/** 礼物数据(名称) */
@property (nonatomic, strong) NSArray *dataNameArr;
/** 礼物数据(钱币) */
@property (nonatomic, strong) NSArray *dataMoneyArr;

/** 发送礼物按钮 */
@property (nonatomic, strong) UIButton *senderButton;
/** token~ */
@property (nonatomic, copy)   NSString       *token;
/** 用户ID~ */
@property (nonatomic, copy)   NSString       *userId;
/** 直播ID~ */
@property (nonatomic, copy)   NSString       *liveId;
@property (nonatomic, strong) LZOptionSelectView *cellView;

@property (strong, nonatomic, readonly) id<PVPresentModelAble> gitfModel;

@end

@implementation PVGiftGivingViewController
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ( self = [super init] )
    {
        _token = dictionary[@"token"];
        _userId = dictionary[@"userId"];
        _liveId = dictionary[@"liveId"];
        // 获取礼物单列表(动态)
        [self getGiftsList];
        // 获取账户余额
//        [self getBalance];
    }
    return self;
}

- (void)setParentLiveId:(NSString *)parentLiveId{
    _parentLiveId = parentLiveId;
}

- (void)setCurrentViewHeight:(CGFloat)currentViewHeight{
    _currentViewHeight = currentViewHeight;
    [self initView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cellView = [[LZOptionSelectView alloc] initOptionView];
    self.countLabel.text = @"1";
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld", [PVUserModel shared].pandaAccount.balance];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.footerView.hidden = YES;
//    self.showGiftContainerView.hidden = YES;
    self.showGiftContainerView.backgroundColor = [UIColor clearColor];
}

- (IBAction)backBtnClicked {
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = kScreenHeight;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
}


/** 获取礼物模型数据 */
- (void) getGiftsList{

    [PVNetTool getWithURLString:@"getGiftsList" parameter:nil success:^(id responseObject){

        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {

            if ([[responseObject pv_objectForKey:@"rs"] integerValue]==200) {

                PVGiftsListModel *listModel = [[PVGiftsListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:responseObject];
                self.lzListModel = listModel;

                YYLog(@"根据直播基本信息中的 礼物URL获取---responseObject --%@",responseObject);
                // 根据直播基本信息中的 礼物URL获取
                [self.itemModelArray removeAllObjects];
                for (int i=0; i<[self.lzListModel.data.giftList count]; i++) {
                    [self.itemModelArray addObject:self.lzListModel.data.giftList[i]];
                }
                [self.lzCollectionView reloadData];
                [self.collectionView reloadData];
                self.footerView.hidden = NO;
                self.showGiftContainerView.hidden = NO;
                
                
                NSInteger itemTotalCount = self.itemModelArray.count;
                NSInteger itemCount = 9;
                // 余数（用于确定最后一页展示的item个数）
                NSInteger remainder = itemTotalCount % itemCount;
                // 除数（用于判断页数）
                NSInteger pageNumber = itemTotalCount / itemCount;
                // 总个数小于self.rowCount * self.itemCountPerRow
                if (itemTotalCount <= itemCount) {
                    pageNumber = 1;
                }else {
                    if (remainder == 0) {
                        pageNumber = pageNumber;
                    }else {
                        // 余数不为0,除数加1
                        pageNumber = pageNumber + 1;
                    }
                }
                self.pageControl.numberOfPages = pageNumber;// 总数/每页个数+1
                if (pageNumber>1) {
                    self.pageControl.hidden = NO;
                }else{
                    self.pageControl.hidden = YES;
                }

            }
        }else{
            YYLog(@"礼物模板数据没有-");
        }
    } failure:^(NSError *error) {
        YYLog(@"error -- %@",error);
    }];
}


/** 获取账户余额-金币(动态) */
- (void)getBalance {
    
    NSString *token = @"";
    NSString *userId = @"";
    if (kUserInfo.isLogin) {
        token = kUserInfo.token;
        userId= kUserInfo.userId;
    }
    
    NSDictionary *dict = @{@"platform":@(1),@"token":token, @"userId":userId};
    [PVNetTool postDataHaveTokenWithParams:dict url:@"/getPandaBalance" success:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                PVIntroduceMoneyModel *moneyModel = [PVIntroduceMoneyModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [PVUserModel shared].pandaAccount.balance = moneyModel.balance.integerValue;
                self.moneyLabel.text = [NSString stringWithFormat:@"%ld", [PVUserModel shared].pandaAccount.balance];
                NSString *tips = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorMsg"]];
                Toast(tips);
            }
        }
    } failure:^(NSError *error) {
        YYLog(@"error--%@",error);
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        YYLog(@"tokenErrorInfo--%@",tokenErrorInfo);
    }];
}


/** 赠送礼物接口 */
- (void) requestPresentGift:(NSInteger) idx{
    
    NSString *token = @"";
    NSString *userId = @"";
    if (kUserInfo.isLogin) {
        token = kUserInfo.token;
        userId= kUserInfo.userId;
    }
    
    PVGiftList *list = self.itemModelArray[idx];
    NSInteger tid = list.giftId;
    YYLog(@"选择的礼物ID==%ld",tid);
    YYLog(@"选择的礼物ID==%@",list.price);
    NSString *count = self.countLabel.text;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSString stringWithFormat:@"%ld",tid] forKey:@"giftId"];    //礼物ID
    [dictionary setValue:_liveId forKey:@"liveId"];     // 直播ID
    [dictionary setValue:count forKey:@"number"];       // 礼物数量
    // 系列直播ID(如果当前的直播属于某系列直播，则该字段需要传系列直播的code)
    [dictionary setValue:self.parentLiveId forKey:@"parentLiveId"];
    [dictionary setValue:@"1" forKey:@"platform"];      // 0:Android，1:ios
    [dictionary setValue:token forKey:@"token"];       // 令牌
    [dictionary setValue:userId forKey:@"userId"];     // 用户ID
    PV(weakSelf);
    [PVNetTool postDataWithParams:dictionary url:@"presentGift" success:^(id result) {
        if (result) {
            if ([[result objectForKey:@"rs"] integerValue] == 200) {
                PVIntroduceMoneyModel *moneyModel = [PVIntroduceMoneyModel yy_modelWithDictionary:[result pv_objectForKey:@"data"]];
                YYLog(@"赠送后的余额-- %@",moneyModel.balance);
                [PVUserModel shared].pandaAccount.balance =moneyModel.balance.integerValue;
                weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%ld", [PVUserModel shared].pandaAccount.balance];
                [weakSelf backBtnClicked];
                if (weakSelf.giftClick) {
                    weakSelf.giftClick(_reuse,count.integerValue);
                }
                NSString *giftStr = [NSString stringWithFormat:@"送了%@个%@",count,list.giftName];
                NSDictionary *dict = @{@"giftName":giftStr};
                [kNotificationCenter postNotificationName:@"receptionGiftMessage" object:nil userInfo:dict];
                return ;
            }
            Toast(@"赠送礼物失败");
        }
    } failure:^(NSError *error) {
            Toast(@"赠送礼物失败");
    }];
}

- (void) initView{

    // 默认选中第一个礼物
    _reuse = 0;
    _count = 0;

    _headerView.backgroundColor = [UIColor whiteColor];
    _givingView.backgroundColor = [UIColor clearColor];
    
    [_givingView setBordersWithColor:kColorWithRGB(41, 180, 228)
                        cornerRadius:_givingView.sc_height/2
                         borderWidth:1.0];
    [_rechargeBtn setBordersWithColor:kColorWithRGB(41, 180, 228)
                         cornerRadius:_rechargeBtn.sc_height/2
                          borderWidth:1.0];
    [self.rechargeBtn addTarget:self action:@selector(rechargeBtnOnClick)
               forControlEvents:UIControlEventTouchUpInside];
    _showGiftContainerView.backgroundColor = [UIColor clearColor];
    _showGiftContainerView.userInteractionEnabled = YES;
    [self setSubViews];
}

- (void)setSubViews{
    [self.showGiftContainerView addSubview:self.lzCollectionView];
//    [self.showGiftContainerView addSubview:self.collectionView];
    [self.showGiftContainerView addSubview:self.pageControl];
    [self.footerView addSubview:self.senderButton];
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    self.pageControl.currentPage = page;
}

// Cell 个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PVGiftViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PVGiftViewCell" forIndexPath:indexPath];
    if (self.itemModelArray.count > 0) {
        PVGiftList *list = self.itemModelArray[indexPath.row];
        cell.isFullScreen = NO;
        [cell.giftImageView sd_setImageWithURL:[NSURL URLWithString:list.giftImageName]];
        cell.giftNameLabel.text = list.giftName;
        cell.moneyLabel.text = list.price;
//        [cell.clickBtn setValue:list.tid forKey:@"tid"];
        cell.clickBtn.tag = indexPath.row;
        // 通过点击按钮传indexPath参数
        NSDictionary* paramDic = @{@"indexPath":indexPath, @"row":@(indexPath.row), @"section":@(indexPath.section)};
        cell.clickBtn.multiParamDic = paramDic;
        objc_setAssociatedObject(cell.clickBtn, "indexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.clickBtn addTarget:self action:@selector(collectionViewClickBtnCell:) forControlEvents:UIControlEventTouchUpInside];
        if (_reuse == indexPath.row) {
            cell.hitButton.selected = YES;
        } else {
            cell.hitButton.selected = NO;
        }
         [cell hitButtonBorderIsSelected];
    }
    return cell;
}


- (void) collectionViewClickBtnCell:(UIButton *)sender{

    MultiParamButton *multiParamButton = (MultiParamButton* )sender;
    
    YYLog(@"multiParamButton.multiParamDic : %@", multiParamButton.multiParamDic);

    // 接收参数
    id indexPath = objc_getAssociatedObject(sender, "indexPath");        //取参
    
    _reuse = sender.tag;
    PVGiftViewCell *cell = (PVGiftViewCell *)[self.lzCollectionView cellForItemAtIndexPath:indexPath];
    if (!cell.hitButton.selected) {
        for (UIView *view in self.lzCollectionView.subviews) {
            //遍历所有cell，重置为未连击状态
            if ([view isKindOfClass:[PVGiftViewCell class]]) {
                PVGiftViewCell *cell = (PVGiftViewCell *)view;
                cell.hitButton.selected = NO;
                 [cell hitButtonBorderIsSelected];
            }
        }
        cell.hitButton.selected = YES;
         [cell hitButtonBorderIsSelected];
        // 可以发送礼物
        self.senderButton.backgroundColor = kColorWithRGB(36, 215, 200);
        self.senderButton.enabled = YES;
        _reuse = sender.tag;
    } else {
        cell.hitButton.selected = NO;
         [cell hitButtonBorderIsSelected];
        // 未有选中，禁用发送按钮
        self.senderButton.backgroundColor = kColorWithRGB(242,242,242);
        self.senderButton.enabled = NO;
        _reuse = 100;
        return;
    }
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    YYLog(@"indexPath -- %ld",indexPath.row);
    PVGiftViewCell *cell = (PVGiftViewCell *)[self.lzCollectionView cellForItemAtIndexPath:indexPath];
    if (!cell.hitButton.selected) {
        for (UIView *view in self.lzCollectionView.subviews) {
            //遍历所有cell，重置为未连击状态
            if ([view isKindOfClass:[PVGiftViewCell class]]) {
                PVGiftViewCell *cell = (PVGiftViewCell *)view;
                cell.hitButton.selected = NO;
                 [cell hitButtonBorderIsSelected];
            }
        }
        cell.hitButton.selected = YES;
         [cell hitButtonBorderIsSelected];
        // 可以发送礼物
        self.senderButton.backgroundColor = kColorWithRGB(36, 215, 200);
        self.senderButton.enabled = YES;
        _reuse = indexPath.row;
    } else {
        cell.hitButton.selected = NO;
        [cell hitButtonBorderIsSelected];
        // 未有选中，禁用发送按钮
        self.senderButton.backgroundColor = kColorWithRGB(242,242,242);
        self.senderButton.enabled = NO;
        _reuse = 100;
        return;
    }
}

#pragma ------------懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        CGFloat collectionHeight=self.view.sc_height-self.footerView.sc_height - self.headerView.sc_height;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(12, 12, 0, 12);
        flowLayout.minimumInteritemSpacing = 6.f;
        flowLayout.minimumLineSpacing      = 6.f;
        flowLayout.itemSize = CGSizeMake((YYScreenWidth - 12*2 - 6*2)/3, collectionHeight/3);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YYScreenWidth, collectionHeight)
                                             collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = kColorWithRGBA(242, 242, 242, 1.0);
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[PVGiftViewCell class] forCellWithReuseIdentifier:@"PVGiftViewCell"];
    }
    return _collectionView;
}

/** 发送礼物(按钮)*/
- (UIButton *)senderButton{
    if (!_senderButton) {
        _senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _senderButton.frame = CGRectMake(kScreenWidth - 113, 10, 100, 33);
        _senderButton.tag = 0;
        _senderButton.hidden = YES;
        [_senderButton setTitle:@"发送" forState:UIControlStateNormal];
        [_senderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _senderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _senderButton.layer.cornerRadius = 16;
        _senderButton.layer.masksToBounds = YES;
        [_senderButton setBackgroundColor:kColorWithRGB(36, 215, 200)];
        [_senderButton addTarget:self action:@selector(sendGiftOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _senderButton;
}


- (PVTipsPopoverView *)showTipsView{
    
    if (!_showTipsView) {
        _showTipsView = [[NSBundle mainBundle] loadNibNamed:@"PVTipsPopoverView" owner:nil options:nil ].lastObject;
//        _showTipsView.delegate = self;
    }
    return _showTipsView;
}

// 赠送礼物(没使用)
- (void) sendGiftOnClick:(UIButton *)sender{
    
    NSString *money = self.moneyLabel.text;
    NSString *count = self.countLabel.text;
    PVGiftList *list = self.itemModelArray[_reuse];

    NSInteger totalPrice = list.price.integerValue*count.integerValue;
    
    if (money.integerValue<totalPrice) {
        PV(pv)
        _showTipsView.jumpCallBlock = ^(NSInteger idx) {
            if (idx==1) {
                YYLog(@"暂不");
            }else{
                YYLog(@"去充值");
            }
            [pv.showTipsView disMissView];
        };
        [self.showTipsView showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        YYLog(@"送礼物%ld",(long)_reuse);
        if (self.giftClick) {
//            self.giftClick(_reuse);
        }
        [self requestPresentGift:_reuse];
    }
    
}


/**
 * 选择礼物数量的按钮操作
 *
 * @param sender 按钮
 */
- (IBAction)chooseGiftQuantityButtonClick:(UIButton *)sender {
    _count = 100;
    [self setDefaultCell];
    _cellView.vhShow = NO;
    _cellView.optionType = LZOptionSelectViewTypeArrow;
    
    if (kiPhoneX) {
        [_cellView showTapPoint:CGPointMake(self.givingView.sc_x+self.givingView.width/4, kScreenHeight-lz_kiPhoneXB(55))
                      viewWidth:87
                      direction:LZOptionSelectViewTop];
    }else{
        [_cellView showTapPoint:CGPointMake(self.givingView.sc_x+self.givingView.width/4, kScreenHeight-55)
                      viewWidth:87
                      direction:LZOptionSelectViewTop];
    }
}

/** 设置Cell */
- (void)setDefaultCell {
    WEAK(weaklistArray, self.listArray);
    WEAK(weakSelf, self);
    _cellView.canEdit = NO;
    [_cellView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LZPopupTableViewCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        UITableViewCell *cell = [weakSelf.cellView dequeueReusableCellWithIdentifier:@"LZPopupTableViewCell"];

        cell.textLabel.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row]];
        cell.textLabel.textColor = [UIColor sc_colorWithRed:42 green:180 blue:228];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 35.f;
    };
    _cellView.rowNumber = ^(){
        
        YYLog(@"(NSInteger)weaklistArray.count -%ld",(NSInteger)weaklistArray.count);
        return (NSInteger)weaklistArray.count;
    };  
    _cellView.selectedOption = ^(NSIndexPath *indexPath){
        
        NSString *title = [weaklistArray objectAtIndex:indexPath.row];
        YYLog(@"选中的数字 -- title --- %@",title);
        weakSelf.countLabel.text = title;
    };
}

/**
 * 选择好礼物点击赠送操作
 *
 * @param sender 按钮
 */
- (IBAction)sendGiftButtonClick:(id)sender {
    YYLog(@"送礼物的标记(下标)%ld",(long)_reuse);
    if (![PVUserModel shared].isLogin) {
        PVLoginViewController *vc = [[PVLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (_reuse  ==  100) {
        Toast(@"请选择礼物");
        return;
    }
    NSString *money = self.moneyLabel.text;
    NSString *count = self.countLabel.text;
    PVGiftList *list = [self.itemModelArray sc_safeObjectAtIndex:_reuse];

    NSInteger totalPrice = list.price.integerValue*count.integerValue;
    if (money.integerValue<totalPrice) {
        PV(pv)
        self.showTipsView.jumpCallBlock = ^(NSInteger idx) {
            if (idx==1) {
                YYLog(@"暂不");
            }else{
                if (pv.jumpReturnCallBlock) {
                    pv.jumpReturnCallBlock();
                };
            }
            [pv.showTipsView disMissView];
        };
        [self.showTipsView showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        [self requestPresentGift:_reuse];
    }
}


/**  充值按钮事件，先判断是否有登录，未登录跳转到登录界面，已登录直接跳转到充值界面*/
- (void) rechargeBtnOnClick{
    if (self.jumpReturnCallBlock) {
        self.jumpReturnCallBlock();
    }
    [self backBtnClicked];
}

/** 分页 */
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, CGRectGetMaxY(self.lzCollectionView.frame), 100, 20)];
        _pageControl.currentPage = 0;
        _pageControl.hidden = YES;
        [_pageControl setCurrentPageIndicatorTintColor:kColorWithRGB(42,180,228)];
        [_pageControl setPageIndicatorTintColor:kColorWithRGB(215,215,215)];
    }
    return _pageControl;
}

/** 礼物图片(数据) */
- (NSMutableArray *)itemModelArray{
    if (!_itemModelArray) {
        _itemModelArray = [[NSMutableArray alloc] init];
        /**for (NSInteger i = 0; i < 9; i++) {
            NSString *imagePath=[NSString stringWithFormat:@"live_icon_gift%zd",i + 1];
            [_itemModelArray addObject:imagePath];
        }
        [_collectionView reloadData];*/
    }
    return _itemModelArray;
}

/** 礼物名称(数据) */
- (NSArray *)dataNameArr{
    if (!_dataNameArr) {
        _dataNameArr = [NSArray arrayWithObjects:@"爱你哟",@"吉他",@"金话筒",@"迷你乐队",@"糖心炸弹",@"香气粑粑",@"心好累",@"兰博基尼",@"豪华游艇", nil];
        [_collectionView reloadData];
    }
    return _dataNameArr;
}
/** 礼物价格(数据) */
- (NSArray *)dataMoneyArr{
    if (!_dataMoneyArr) {
        _dataMoneyArr = [NSArray arrayWithObjects:@"1000",@"2000",@"3000",@"4000",@"5000",@"6000",@"7000",@"8000",@"8000", nil];
        [_collectionView reloadData];
    }
    return _dataMoneyArr;
}


/** 礼物数量：1  10  30  66  188  233 */
- (NSArray *)listArray{
    if (_listArray == nil) {
        _listArray = [[NSArray alloc] init];
        _listArray =@[@"1",@"10",@"30",@"66",@"188",@"233"];

    }
    return _listArray;
}


#pragma mark - Lazy
- (UICollectionView *)lzCollectionView {
    if (!_lzCollectionView) {
        CGFloat collectionHeight=self.currentViewHeight-100;
        YYLog(@"collectionHeight -- %f",collectionHeight);
        /** -----1.使用系统提供的的UICollectionViewFlowLayout布局----- */
//         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        /** -----2.使用自定义的的HorizontalPageFlowlayout布局----- */
        PVHorizontalPageFlowlayout *flowLayout = [[PVHorizontalPageFlowlayout alloc] initWithRowCount:3 itemCountPerRow:3];
        [flowLayout setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsMake(12, 0, 0, 0)];
        
        /** 注意,此处设置的item的尺寸是理论值，实际是由行列间距、collectionView的内边距和宽高决定 */
        // layout.itemSize = CGSizeMake(kScreenWidth / 4, 60);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
//        flowLayout.sectionInset = UIEdgeInsetsMake(12, 12, 0, 12);
//        flowLayout.minimumInteritemSpacing = 6.f;
//        flowLayout.minimumLineSpacing      = 6.f;//0
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 12*2 - 6*2)/3, collectionHeight/3);
        
        _lzCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, collectionHeight) collectionViewLayout:flowLayout];
        _lzCollectionView.backgroundColor = kColorWithRGBA(242, 242, 242, 1.0);
        _lzCollectionView.showsVerticalScrollIndicator = NO;
        _lzCollectionView.showsHorizontalScrollIndicator = NO;
        _lzCollectionView.bounces = YES;
        _lzCollectionView.pagingEnabled = YES;
        _lzCollectionView.dataSource = self;
        _lzCollectionView.delegate = self;
        [_lzCollectionView registerClass:[PVGiftViewCell class] forCellWithReuseIdentifier:@"PVGiftViewCell"];

    }
    return _lzCollectionView;
}


- (void) dealloc{
    
}

@end
