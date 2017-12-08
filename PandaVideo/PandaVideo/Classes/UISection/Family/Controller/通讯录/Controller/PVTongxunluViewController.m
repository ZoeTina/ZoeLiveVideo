//
//  PVTongxunluViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTongxunluViewController.h"
#import "PVTongxunluModel.h"
#import "LZChineseSort.h"
#import "PVTongxunluTableViewCell.h"
#import "PVTongxunluSectionView.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "NSString+SCExtension.h"
#import "NSString+LZPinYin.h"
#import "LZPinYinSearch.h"
#import "LZSearchBar.h"
#import "AppDelegate+AddressBook.h"
#import "PVInviteFamilyTableViewCell.h"
#import "PVInviteValidationViewController.h"

//static NSString *CellIdentifier = @"PVTongxunluTableViewCell";
static NSString *CellIdentifier = @"PVInviteFamilyTableViewCell";
@interface PVTongxunluViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
{
    NSMutableArray<PVTongxunluModel *> *dataArray;
    PVTongxunluSectionView  *sectionView;
    BOOL  isSearch; // 是否处于搜索状态
}
/** 设置tableview */
@property (nonatomic, strong) UITableView *lzTableView;
/** tabViewCell */
//@property (nonatomic, strong) PVTongxunluTableViewCell *tableViewCell;

@property(nonatomic, strong) LZSearchBar *searchBar;

@property (strong, nonatomic) UISearchController    *searchController;
@property (strong, nonatomic) PVTongxunluModel      *tongxunluModel;
/** <排序前的整个数据源> */
@property (strong, nonatomic) NSMutableArray        *itemModelArray;
/** <排序后的整个数据源> */
@property (strong, nonatomic) NSDictionary          *letterResultDictionary;
/** <索引数据源> */
@property (strong, nonatomic) NSArray               *indexArray;

/** <搜索结果排序前的整个数据源> */
@property (strong, nonatomic) NSMutableArray        *searchResultsArray;
/** <搜索结果排序后的整个数据源> */
@property (strong, nonatomic) NSDictionary          *searchResultsDictionary;
/** 搜索结果索引数据源 */
@property (strong, nonatomic) NSArray               *searchResultsIndexArray;

/** <上传后的整个数据源> */
@property (strong, nonatomic) NSMutableArray        *uploadResultsArray;
/** <上传后的的整个数据源> */
@property (strong, nonatomic) NSDictionary          *uploadResultsDictionary;
/** 上传后的索引数据源 */
@property (strong, nonatomic) NSArray               *uploadResultsIndexArray;

/** 通讯录访问权限是否已经开启提示 */
@property (strong, nonatomic) UILabel               *tipslabel;
@property (copy, nonatomic) NSString                *searchText;

//页数
@property (nonatomic, assign) NSInteger index;
//每页请求量
@property (nonatomic, assign) NSInteger pageSize;
//总页数
@property (nonatomic, assign) NSInteger totalPage;
@end

@implementation PVTongxunluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSearch = NO;  // 默认不在搜索状态
    [self initView];
    
}

- (void) initView {
    self.view.backgroundColor = kColorWithRGB(242, 242, 242);
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusDenied) {
        YYLog(@"没有授权...");
        self.tipslabel.hidden = NO;
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            // 获取通讯录数据
            [self loadData];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
//                [self.lzTableView reloadData];
            });
            
        });
        [self.view addSubview:self.lzTableView];
        [Utils setExtraCellLineHidden:self.lzTableView];
        
        // 1.设置右侧索引字体颜色
        self.lzTableView.sectionIndexColor = [Utils colorWithHexString:@"#808080"];
        //2.设置右侧索引背景色
        self.lzTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        [self.lzTableView setTableHeaderView:self.searchController.searchBar];
    }
}

#pragma mark - -------
- (void)loadData {
    // 模拟数据
//    _itemModelArray = [PVTongxunluModel getModelData];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    if (delegate.dataArray.count>0) {
        
        //所有的数据，没分组
        _itemModelArray = delegate.dataArray;
        
        //通讯录分组，乱序的
        _letterResultDictionary = [LZChineseSort sortAndGroupForArray:_itemModelArray PropertyName:@"name"];
        
        //抽取排序，A，B，C
        _indexArray = [LZChineseSort sortForStringAry:[_letterResultDictionary allKeys]];
        _searchResultsArray = [NSMutableArray new];
        _searchResultsDictionary = [NSDictionary new];
        _searchResultsIndexArray = [NSMutableArray new];
//        [self.lzTableView reloadData];
    }else{
        YYLog(@"没有数据");
    }
}


- (void)postAndLoadData {
    
    self.pageSize = 3;
    self.index = 0;
    
    if (self.uploadResultsArray.count > 0) {
        [self.uploadResultsArray removeAllObjects];
        self.uploadResultsIndexArray = [NSArray array];
        self.uploadResultsDictionary = [NSDictionary dictionary];
    }
    
    self.lzTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.lzTableView.mj_footer.hidden = YES;
    
    NSString *contactStr = [NSString new];
    NSMutableArray *contactArray = [NSMutableArray new];
    if (_itemModelArray.count >= self.pageSize) {
        for (int i = 0; i <self.pageSize; i ++) {
            PVTongxunluModel *model = _itemModelArray[i];
            [contactArray addObject:model];
            contactStr = [contactStr stringByAppendingString:[NSString stringWithFormat:@"%@,",model.phone]];
        }
    }else {
        for (PVTongxunluModel *model in self.itemModelArray) {
            [contactArray addObject:model];
            contactStr = [contactStr stringByAppendingString:[NSString stringWithFormat:@"%@,",model.phone]];
        }
        
    }
    
    NSDictionary *paraDic = @{@"contacts":contactStr, @"familyId":@"106", @"phone":@"15378206591"};
    [PVNetTool postDataWithParams:paraDic url:getContactsState success:^(id result) {
        [self.lzTableView.mj_header endRefreshing];
        if (result) {
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                NSArray *dataArray = [[result pv_objectForKey:@"data"] pv_objectForKey:@"contacts"];
                [self analysisContractDataWithResponseArray:dataArray uploadArray:contactArray isHeader:YES];
            }else {
                Toast([result pv_objectForKey:@"errorMsg"]);
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            Toast(@"通讯录获取失败");
            [self.lzTableView.mj_header endRefreshing];
        }
    }];
}

- (void)loadMoreData {
    self.index += self.pageSize;
    if (self.itemModelArray.count - self.index <= 0) {
        [self.lzTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSString *contactPhoneStr = [NSString new];
    NSMutableArray *contractArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.pageSize ; i ++) {
        PVTongxunluModel *model = [self.itemModelArray sc_safeObjectAtIndex:(self.index + i)];
        contactPhoneStr = [contactPhoneStr stringByAppendingString:[NSString stringWithFormat:@"%@,",model.phone]];
        [contractArray addObject:model];
    }
    
    [self.lzTableView.mj_footer endRefreshing];
    NSDictionary *paraDic = @{@"contacts":contactPhoneStr, @"familyId":@"", @"phone":@"18215679704"};
    [PVNetTool postDataWithParams:paraDic url:getContactsState success:^(id result) {
        [self.lzTableView.mj_footer endRefreshing];
        if (result) {
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                NSArray *dataArray = [[result pv_objectForKey:@"data"] pv_objectForKey:@"contacts"];
                [self analysisContractDataWithResponseArray:dataArray uploadArray:contractArray isHeader:NO];
            }else {
                Toast([result pv_objectForKey:@"errorMsg"]);
            }
        }
    } failure:^(NSError *error) {
        Toast(@"上拉加载通讯录失败");
        [self.lzTableView.mj_footer endRefreshing];
    }];
}

- (void)analysisContractDataWithResponseArray:(NSArray *)responseArray uploadArray:(NSMutableArray *)contractArray isHeader:(BOOL)isHeader{
    
    for (int i = 0; i < self.pageSize; i ++) {
        NSDictionary *phoneDict = responseArray[i];
        PVTongxunluModel *originModel = self.itemModelArray[self.index + i];
        if ([[phoneDict pv_objectForKey:@"phone"] isEqualToString:originModel.phone]) {
            originModel.state = [[phoneDict pv_objectForKey:@"state"] integerValue];
//            originModel.state = 1;
        }
    }

    
    self.uploadResultsDictionary = [LZChineseSort sortAndGroupForArray:self.uploadResultsArray PropertyName:@"name"];
    self.uploadResultsIndexArray = [LZChineseSort sortForStringAry:[self.uploadResultsDictionary allKeys]];
    
    if (isHeader) {
        
        self.lzTableView.mj_footer.hidden = NO;
        
    } 
    [self.lzTableView reloadData];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"通讯录";
}

- (LZSearchBar *)searchBar {
    
    if (_searchBar == nil) {
        _searchBar = [[LZSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        // 删除UISearchBar中的UISearchBarBackground
        [_searchBar setShowsCancelButton:NO animated:YES];
    }
    return _searchBar;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.placeholder = @"搜索";
        self.definesPresentationContext = YES;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    PVInviteFamilyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //获得对应的PVTongxunluModel对象<替换为你自己的model对象>
    if (!self.searchController.active) {
        NSArray *value = [self.letterResultDictionary objectForKey:[self.indexArray sc_safeObjectAtIndex:section]];
        self.tongxunluModel = value[row];
        cell.contractModel = self.tongxunluModel;
    }else{
        NSArray *value = [self.searchResultsDictionary objectForKey:[self.searchResultsIndexArray sc_safeObjectAtIndex:section]];
        self.tongxunluModel = [value sc_safeObjectAtIndex:row];

//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
        
        if (self.searchText) {
            NSMutableAttributedString *attrStr = [self matchingStrWithTongxunluModel:self.tongxunluModel targetStr:self.searchText];
            cell.contractModel = self.tongxunluModel;
            if (self.tongxunluModel.name.length == 0) {
                cell.bigPhoneLabel.attributedText = attrStr;
            }else {
                if ([self isNum:self.searchText]) {
                    cell.smallPhoneLabel.attributedText = attrStr;
                }else {
                    cell.labelName.attributedText = attrStr;
                }
                
            }
            // 后面文字颜色
//            cell.smallPhoneLabel.attributedText = attrStr;
        }else{

//            [attrStr addAttribute:NSForegroundColorAttributeName
//                            value:kColorWithRGB(0, 0, 0)
//                            range:NSMakeRange(0, [self.tongxunluModel.name length])];
        }

        
    }
    cell.isShowArrowView = NO;
    return cell;
}

- (NSMutableAttributedString *)matchingStrWithTongxunluModel:(PVTongxunluModel *)model targetStr:(NSString *)targetStr {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    if ([self isNum:targetStr]) {
        attStr = [[NSMutableAttributedString alloc] initWithString:model.phone];
        NSRange range = [model.phone rangeOfString:self.searchText];//匹配得到的下标
        YYLog(@"rang:%@",NSStringFromRange(range));
        [attStr addAttribute:NSForegroundColorAttributeName
                        value:kColorWithRGB(42, 180, 228)
                        range:range];
    }else {
        attStr = [[NSMutableAttributedString alloc] initWithString:model.name];
        NSRange range = [model.name rangeOfString:self.searchText];//匹配得到的下标
        YYLog(@"rang:%@",NSStringFromRange(range));
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:kColorWithRGB(42, 180, 228)
                       range:range];
    }
    return attStr;
}
#pragma mark - Table view data source
// 每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!self.searchController.active) {
        NSArray *value = [self.letterResultDictionary objectForKey:[self.indexArray sc_safeObjectAtIndex:section]];
        return value.count;
    }else {
        NSArray *value = [self.searchResultsDictionary objectForKey:[self.searchResultsIndexArray sc_safeObjectAtIndex:section]];
        return value.count;
    }
}

// 多少个组Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        return self.indexArray.count;
    }else {
        return self.searchResultsIndexArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark -
#pragma mark Table View Delegate Methods
#pragma mark - 选中的哪个Cell
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (!self.searchController.active) {
        NSArray *value = [self.letterResultDictionary objectForKey:[self.indexArray sc_safeObjectAtIndex:section]];
        _tongxunluModel = value[row];
    }else{
        NSArray *value = [_searchResultsDictionary objectForKey:[_searchResultsIndexArray sc_safeObjectAtIndex:section]];
        _tongxunluModel = value[row];
    }
//    self.searchController.active = NO;
    if (_tongxunluModel.state == 0) {
        //未加入朋友圈
        PVInviteValidationViewController *con = [[PVInviteValidationViewController alloc] init];
        con.targetPhone = _tongxunluModel.phone;
        [self.navigationController pushViewController:con animated:YES];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    sectionView = [[PVTongxunluSectionView alloc] init];
    if (!self.searchController.active) {
        sectionView.labelTitle.text = [self.indexArray sc_safeObjectAtIndex:section];
    }else {
        sectionView.labelTitle.text = [_searchResultsIndexArray sc_safeObjectAtIndex:section];
    }
    return sectionView;
}


//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (!self.searchController.active) {
        return self.indexArray;
    }else {
        return nil;
    }
}

//  点击右侧索引表项时调用 索引与section的对应关系
//  自定义索引与数组的对应关系 (响应点击索引时的委托方法) //索引列点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}



- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}



/// MARK:- ====================== 懒加载 ======================
-(UITableView *)lzTableView{
    if (!_lzTableView) {
        
        _lzTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        if (@available(iOS 11.0, *)) {
            _lzTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
        }
        _lzTableView.showsVerticalScrollIndicator = false;
        [_lzTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
           forCellReuseIdentifier:CellIdentifier];
        [_lzTableView setSeparatorInset:UIEdgeInsetsMake(13,0,0,0)];
        _lzTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _lzTableView.delegate = self;
        _lzTableView.dataSource = self;
        _lzTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _lzTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
            [self postAndLoadData];
        }];
        [_lzTableView.mj_header beginRefreshing];
    }
    return _lzTableView;
}

#pragma mark - UISearchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    [_searchResultsArray removeAllObjects];
    NSArray *searchArray = [NSArray new];
    //对排序好的数据进行搜索
    searchArray = [LZChineseSort getAllValuesFromDictionary:_letterResultDictionary];
    
    if (searchController.searchBar.text.length == 0) {
        [_searchResultsArray addObjectsFromArray:searchArray];
        
        // 根据搜索结果中的数据进行name再次排序
        _searchResultsDictionary = [LZChineseSort sortAndGroupForArray:_searchResultsArray PropertyName:@"name"];
        _searchResultsIndexArray = [LZChineseSort sortForStringAry:[_searchResultsDictionary allKeys]];
    } else {
        
        NSString *parameterStr = [NSString new];
        // 被搜索的字符串
        self.searchText = searchController.searchBar.text;
        // 判断是数字还是字符串
        BOOL isNum = [self deptNumInputShouldNumber:self.searchText];
        if (isNum) {
            // 根据电话号码进行搜索(tel)
            parameterStr = @"tel";
        }else{
            // 根据姓名进行搜索(name)
            parameterStr = @"name";
        }

        searchArray = [LZPinYinSearch searchWithOriginalArray:searchArray
                                                andSearchText:self.searchText
                                      andSearchByPropertyName:parameterStr];
        // 将搜索的数据放到数组
        [_searchResultsArray addObjectsFromArray:searchArray];
        // 根据搜索结果中的数据进行name再次排序
        _searchResultsDictionary = [LZChineseSort sortAndGroupForArray:_searchResultsArray PropertyName:@"name"];
        _searchResultsIndexArray = [LZChineseSort sortForStringAry:[_searchResultsDictionary allKeys]];
    }
    [self.lzTableView reloadData];
}

- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

- (UILabel *)tipslabel{
    if (!_tipslabel) {
        NSString *tips = @"请在iPhone的\"设置-隐私-通讯录\"选项中，允许熊猫视频访问你的通讯录";
        _tipslabel = [UILabel sc_labelWithText:tips fontSize:15.0 textColor:kColorWithRGB(0, 0, 0) alignment:NSTextAlignmentCenter];
        _tipslabel.frame = CGRectMake(13, (kScreenHeight-40)/2-100, kScreenWidth-26, 40);
        _tipslabel.numberOfLines = 0;
        _tipslabel.hidden = YES;
        [self.view addSubview:self.tipslabel];
    }
    return _tipslabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)uploadResultsArray {
    if (!_uploadResultsArray) {
        _uploadResultsArray = [[NSMutableArray alloc] init];
    }
    return _uploadResultsArray;
}

- (NSDictionary *)uploadResultsDictionary {
    if (!_uploadResultsDictionary) {
        _uploadResultsDictionary = [[NSDictionary alloc] init];
    }
    return _uploadResultsDictionary;
}


- (NSArray *)uploadResultsIndexArray {
    if (!_uploadResultsIndexArray) {
        _uploadResultsIndexArray = [NSArray array];
    }
    return _uploadResultsIndexArray;
}
@end
