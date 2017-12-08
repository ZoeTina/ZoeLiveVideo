//
//  PVFullScreenGiftChoiceView.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/8.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFullScreenGiftChoiceView.h"
#import "LZOptionSelectView.h"
#import "PVGiftViewCell.h"
#import "PVGiftsListModel.h"
#import "PVHorizontalPageFlowlayout.h"
#import "MultiParamButton.h"
#import "PVIntroduceModel.h"



#define collectionViewCellId @"PVFullScreenCollectionView"

@interface PVFullScreenGiftChoiceView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    // 礼物标记
    NSInteger _reuse;
    // 送出礼物个数标记
    NSInteger _count;
}

@property (nonatomic, strong) IBOutlet UIView *topLineView;
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) UICollectionView *lzCollectionView;

/** pageControl */
@property (nonatomic, strong) UIPageControl *pageControl;
/** 礼物数据 */
@property (nonatomic, strong) NSMutableArray *itemModelArray;
/** 礼物模型 */
@property (nonatomic, strong) PVGiftsListModel *lzListModel;
/** 父容器View */
@property (nonatomic, strong) IBOutlet UIView *containerView;
/** 充值按钮 */
@property (nonatomic, strong) IBOutlet UIButton *rechargeBtn;
/** 送礼按钮 */
@property (nonatomic, strong) IBOutlet UIButton *sendBtn;
/** 赠送按钮外框 */
@property (nonatomic, strong) IBOutlet UIView *sendBoxView;
/** 礼物数量 */
@property (nonatomic, strong) IBOutlet UILabel *countlabel;
/** 赠送文字 */
@property (nonatomic, strong) IBOutlet UIView *moneyView;
/** 分割线 */
@property (nonatomic, strong) IBOutlet UILabel *lineView;
/** 币 */
@property (nonatomic, strong) IBOutlet UILabel *coinlabel;
/** 选择数量的按钮 */
@property (nonatomic, strong) IBOutlet UIButton *selectCountBtn;

@property (nonatomic, strong) LZOptionSelectView *cellView;
/** 快捷数量数组 */
@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;

@property (nonatomic, copy) NSString    *token;
@property (nonatomic, copy) NSString    *userId;

///** 当前客户端是否有登录(默认没登录) */
//@property (nonatomic, assign) BOOL isLogin;

@end

@implementation PVFullScreenGiftChoiceView

-(void)awakeFromNib{
    
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.equalTo(@(YYScreenWidth * 0.8));
    }];
    self.backgroundColor = [kColorWithRGB(0, 0, 0) colorWithAlphaComponent:0.8];
    [super awakeFromNib];
    
    if ([PVUserModel shared].userId.length != 0) {
//        self.isLogin = YES;
        _token      = [PVUserModel shared].token;
        _userId     = [PVUserModel shared].userId;
    }else{
        
        _token      = @"lzTest";
        _userId     = @"lzTest";
//        self.isLogin = NO;
    }
    [self initView];
    // 获取礼物单列表(动态)
    [self getGiftsList];
}

/** 获取账户余额-金币(动态) */
- (void)getBalance {
    
    NSString *token = @"";
    NSString *userId = @"";
    if (kUserInfo.isLogin) {
        token = kUserInfo.token;
        userId= kUserInfo.userId;
    }
    if ((token.length < 1) || (userId.length < 1)) {
        return;
    }
    NSDictionary *dict = @{@"platform":@(1),@"token":token, @"userId":userId};
    [PVNetTool postDataHaveTokenWithParams:dict url:@"/getPandaBalance" success:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                PVIntroduceMoneyModel *moneyModel = [PVIntroduceMoneyModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [PVUserModel shared].pandaAccount.balance = moneyModel.balance.integerValue;
                self.coinlabel.text = [NSString stringWithFormat:@"%ld", [PVUserModel shared].pandaAccount.balance];
            }
        }
    } failure:^(NSError *error) {
        YYLog(@"error--%@",error);
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        YYLog(@"tokenErrorInfo--%@",tokenErrorInfo);
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
                for (int i=0; i<self.lzListModel.data.giftList.count; i++) {
                    [self.itemModelArray addObject:self.lzListModel.data.giftList[i]];
                }
                [self.lzCollectionView reloadData];
                self.footerView.hidden = NO;
                
                
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
            }else{
                YYLog(@"礼物模板数据没有-code:%@(%@)",responseObject[@"rs"],responseObject[@"errorMsg"]);
            }
        }else{
            YYLog(@"礼物模板数据没有-");
        }
    } failure:^(NSError *error) {
        YYLog(@"error -- %@",error);
    }];
}

-(void)setListModel:(PVGiftsListModel *)listModel{
    _listModel = listModel;
    self.lzListModel = listModel;
    
    [self.itemModelArray removeAllObjects];
    for (int i=0; i<[self.lzListModel.data.giftList count]; i++) {
        [self.itemModelArray addObject:self.lzListModel.data.giftList[i]];
    }
    [self.lzCollectionView reloadData];
}


- (void)initView{

    _width = self.frame.size.width;
    _height = self.frame.size.height;
    
    YYLog(@"_width:---%f======_height:---%f",_width,_height);
    self.backgroundColor = [UIColor clearColor];
    self.moneyView.backgroundColor = [UIColor clearColor];

    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.coinlabel.text = @"0";
    if (kUserInfo.isLogin) {
        self.coinlabel.text = [NSString stringWithFormat:@"%ld", [PVUserModel shared].pandaAccount.balance];
    }
    self.rechargeBtn.layer.masksToBounds = YES;
    self.rechargeBtn.layer.cornerRadius = self.rechargeBtn.sc_height/2;
    
    self.sendBoxView.layer.masksToBounds = YES;
    self.sendBoxView.layer.cornerRadius = self.sendBoxView.sc_height/2;
    
    self.sendBoxView.backgroundColor = [UIColor clearColor];
    self.sendBoxView.layer.borderWidth = 0.5;
    self.sendBoxView.layer.borderColor = textColorSelected.CGColor;
    
    self.rechargeBtn.layer.borderWidth = 0.5;
    self.rechargeBtn.layer.borderColor = textColorSelected.CGColor;
    

    // 赠送按钮
    [self.sendBtn addTarget:self action:@selector(sendGiftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 选择数量
    [self.selectCountBtn addTarget:self action:@selector(selectCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _cellView = [[LZOptionSelectView alloc] initOptionView];
    
    // 默认选中第一个礼物
    _reuse = 0;
    _count = 0;
    self.pageControl.numberOfPages = self.itemModelArray.count/9;// 总数/每页个数+1
    if (self.pageControl.numberOfPages > 1) {
        self.pageControl.hidden = NO;
    }
    [self.rechargeBtn addTarget:self action:@selector(rechargeBtnOnClick:)
               forControlEvents:UIControlEventTouchUpInside];
    [self setSubViews];
}

- (void)setSubViews{
    [self.containerView addSubview:self.lzCollectionView];
    [self.containerView addSubview:self.pageControl];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    self.pageControl.currentPage = page;
}


/// 横屏赠送礼物事件
- (void) sendGiftBtnClick:(UIButton *) sender{
    [self closePopView];
    if (_reuse == 100) {
        ToastView(@"请先选择礼物");
        return;
    }
     PVGiftList *list = self.itemModelArray[_reuse];
    NSInteger money = self.countlabel.text.integerValue * list.price.integerValue;
    if (self.zengsongBlock) {
        self.zengsongBlock(_reuse,[PVUserModel shared].pandaAccount.balance >= money);
    }
//     [self requestPresentGift:_reuse];
}

/** 赠送礼物接口 */
- (void) requestPresentGift:(NSInteger) idx{
    
    PVGiftList *list = self.itemModelArray[idx];
    NSInteger tid = list.giftId;
    NSString *count = self.countlabel.text;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSString stringWithFormat:@"%ld",tid] forKey:@"giftId"];    //礼物ID
    [dictionary setValue:_liveId forKey:@"liveId"];     // 直播ID
    [dictionary setValue:count forKey:@"number"];       // 礼物数量
    // 系列直播ID(如果当前的直播属于某系列直播，则该字段需要传系列直播的code)
    [dictionary setValue:count forKey:@"parentLiveId"];
    [dictionary setValue:@"1" forKey:@"platform"];      // 0:Android，1:ios
    [dictionary setValue:[PVUserModel shared].token forKey:@"token"];       // 令牌
    [dictionary setValue:[PVUserModel shared].userId forKey:@"userId"];     // 用户ID
    PV(weakSelf);
    [PVNetTool postDataWithParams:dictionary url:@"presentGift" success:^(id result) {
        if (result) {
            if ([[result objectForKey:@"rs"] integerValue] == 200) {
                PVIntroduceMoneyModel *moneyModel = [PVIntroduceMoneyModel yy_modelWithDictionary:[result pv_objectForKey:@"data"]];
                YYLog(@"赠送后的余额-- %@",moneyModel.balance);
                [PVUserModel shared].pandaAccount.balance = moneyModel.balance.integerValue;
                weakSelf.coinlabel.text = moneyModel.balance;
                NSInteger count = [weakSelf.countlabel.text integerValue];
                //全屏处理动画
                NSDictionary *dict = @{@"reuse":@(_reuse + 100),@"count":@(count),@"userNickName":[PVUserModel shared].baseInfo.nickName};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"informPerformAnimation" object:nil userInfo:dict];
                //半屏显示通知
                NSString *giftStr = [NSString stringWithFormat:@"送了%ld个%@",count,list.giftName];
                NSDictionary *dictChat = @{@"giftName":giftStr};
                [kNotificationCenter postNotificationName:@"receptionGiftMessage" object:nil userInfo:dictChat];
                return ;
            }
            ToastView(@"赠送礼物失败,请重试");
        }
    } failure:^(NSError *error) {
         ToastView(@"赠送礼物失败,请重试");
    }];
}

/**  充值按钮事件，先判断是否有登录，未登录跳转到登录界面，已登录直接跳转到充值界面*/
- (void) rechargeBtnOnClick:(UIButton *) sender{
    [self closePopView];
    if (self.rechargeBlock) {
        self.rechargeBlock();
    }

//    [self lz_make:@"充值"];
//    if (self.isLogin) {
//        // 跳转到充值界面
//        self.jumpCallBackBlcok(1);
//    }else{
//        // 没登录的情况跳转到登录界面
//        self.jumpCallBackBlcok(2);
//    }
}

#pragma mark -
#pragma mark UICollectionView代理
// Cell 个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PVGiftViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PVGiftViewCell" forIndexPath:indexPath];
    if (self.itemModelArray.count > 0) {
        PVGiftList *list = self.self.itemModelArray[indexPath.row];
        [cell.giftImageView sd_setImageWithURL:[NSURL URLWithString:list.giftImageName]];
        cell.giftNameLabel.text = list.giftName;
        cell.moneyLabel.text = list.price;
        
        cell.moneyLabel.textColor = [UIColor whiteColor];
        cell.giftNameLabel.textColor = [UIColor whiteColor];

        //        [cell.clickBtn setValue:list.tid forKey:@"tid"];
        cell.clickBtn.tag =  indexPath.row;
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



/// 横屏送礼礼物选择事件
- (void) collectionViewClickBtnCell:(UIButton *)sender{
    [self closePopView];
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
//        self.senderButton.backgroundColor = kColorWithRGB(36, 215, 200);
//        self.senderButton.enabled = YES;
        _reuse = sender.tag;
    } else {
        cell.hitButton.selected = NO;
         [cell hitButtonBorderIsSelected];
        // 未有选中，禁用发送按钮
//        self.senderButton.backgroundColor = kColorWithRGB(242,242,242);
//        self.senderButton.enabled = NO;
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
        _reuse = indexPath.row;
    } else {
        cell.hitButton.selected = NO;
         [cell hitButtonBorderIsSelected];
        // 未有选中，禁用发送按钮
        _reuse = 100;
        return;
    }
}

/** 选择数量 */
- (void) selectCountBtnClick:(UIButton *) sender{
    PV(weakSelf);
    NSMutableArray *mbArray = [[NSMutableArray alloc] init];
    for (int i=0; i<self.listArray.count; i++) {
        PVPopoverAction *action = [PVPopoverAction actionWithTitle:self.listArray[i] handler:^(PVPopoverAction *action) {
            
            weakSelf.countlabel.text = action.title;
            [weakSelf closePopView];
            
        }];
        [mbArray addObject:action];
    }
    if (self.popoverView) {
        return;
    }
    PVPopoverView *popView = [PVPopoverView popoverView:self];
    popView.currentWidth = 87;
    popView.style = PopoverViewStyleDefault;
    popView.arrowStyle = PopoverViewArrowStyleTriangle;
    popView.hideAfterTouchOutside = YES; // 点击外部时不允许隐藏
    [popView showToView:sender withActions:mbArray];
    self.popoverView = popView;
//    CGAffineTransform transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
//    [popoverView setTransform:transform];
    
}

- (void)closePopView{
    if (self.popoverView) {
        [self.popoverView removeFromSuperview];
        self.popoverView = nil;
    }
   
}

////设置Cell
- (void)setDefaultCell {
    WEAK(weaklistArray, self.listArray);
    WEAK(weakSelf, self);
    _cellView.canEdit = NO;
    _cellView.isScrollEnabled = NO;
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
        weakSelf.countlabel.text = title;
    };
}

/** 礼物数量：1  10  30  66  188  233 */
- (NSArray *)listArray{
    if (_listArray == nil) {
        _listArray = [[NSArray alloc] init];
        _listArray =@[@"1",@"10",@"30",@"66",@"188",@"233"];
        
    }
    return _listArray;
}

/** 礼物(数据) */
- (NSMutableArray *)itemModelArray{
    if (!_itemModelArray) {
        _itemModelArray = [[NSMutableArray alloc] init];
    }
    return _itemModelArray;
}

#pragma ------------懒加载
#pragma mark - Lazy
- (UICollectionView *)lzCollectionView {
    if (!_lzCollectionView) {

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
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 12*2 - 6*2)/3, 110);
        
        _lzCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.topLineView.y, AUTOLAYOUTSIZE(295), CrossScreenWidth-self.topLineView.y-self.footerView.height-20) collectionViewLayout:flowLayout];
        _lzCollectionView.backgroundColor = [UIColor clearColor];
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

/** 分页 */
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.sc_width-100)/2, CGRectGetMaxY(self.lzCollectionView.frame), 100, 20)];
        _pageControl.currentPage = 0;
        _pageControl.hidden = YES;
        [_pageControl setCurrentPageIndicatorTintColor:kColorWithRGB(42,180,228)];
        [_pageControl setPageIndicatorTintColor:kColorWithRGB(215,215,215)];
    }
    return _pageControl;
}
@end
