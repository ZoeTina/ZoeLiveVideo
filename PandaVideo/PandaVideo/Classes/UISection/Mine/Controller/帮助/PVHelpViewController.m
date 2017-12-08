
//  PVHelpViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHelpViewController.h"
#import "PVHelpsTextTableViewCell.h"
#import "PVHelpsTextHeaderView.h"
#import "PVHelpDetailsViewController.h"
#import "PVQuestionClassModel.h"
#import "PVHelpBottomView.h"
#import "UIAlertController+SCExtension.h"

static NSString* resuPVHelpsTextHeaderView = @"resuPVHelpsTextHeaderView";
static NSString* resuPVHelpsTextTableViewCell = @"resuPVHelpsTextTableViewCell";

@interface PVHelpViewController () <UITableViewDataSource, UITableViewDelegate>

///设置tableview
@property(nonatomic, strong)UITableView* helpsTableView;
///数据源
@property(nonatomic, strong)NSMutableArray* dataSource;

@property (nonatomic, strong) PVQuestionClassModel *questionClassModel;

@end

@implementation PVHelpViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self loadData];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"帮助";
    self.automaticallyAdjustsScrollViewInsets = false;
}
-(void)setupUI{
    self.view.backgroundColor = UIColorHexString(0xf2f2f2);
    
    PVHelpBottomView *helpBottomView = [[PVHelpBottomView alloc] initHelpBottomView];
    helpBottomView.questionClassModel = self.questionClassModel;
    [self.view addSubview:helpBottomView];

    [helpBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-SafeAreaBottomHeight);
        make.height.mas_equalTo(kDistanceHeightRatio(96));
    }];
    [helpBottomView setPVHelpBottomViewBlock:^(id sender) {
        [self callServerPhone];
    }];
    
    [self.view insertSubview:self.helpsTableView belowSubview:self.scNavigationBar];
    
    
}

- (void)callServerPhone {
    if (self.questionClassModel.phoneNum.length == 0) {
        Toast(@"电话号码为空");
        return;
    }
    UIAlertController *alerController = [UIAlertController addAlertReminderText:@"" message:self.questionClassModel.phoneNum  cancelTitle:@"取消" doTitle:@"呼叫" preferredStyle:UIAlertControllerStyleAlert cancelBlock:nil doBlock:^{
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.questionClassModel.phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [self presentViewController:alerController animated:YES completion:nil];
}

- (void)loadData {
    PV(pv);
    
    
    [PVNetTool getDataWithUrl:helpJson success:^(id result) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            
            self.questionClassModel = [PVQuestionClassModel yy_modelWithDictionary:result];
            [pv.helpsTableView reloadData];
            [pv setupUI];
        }
        
    } failure:^(NSError *error) {
        SCLog(@"-------error--------%@",error);
    }];
}
/// MARK:- ===== UITableViewDelegate,UITableViewDataSource ==========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.questionClassModel) {
        return self.questionClassModel.classList.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.questionClassModel) {
        PVQuestionListModel *listModel = [self.questionClassModel.classList sc_safeObjectAtIndex:section];
        if (listModel) {
            return listModel.questionList.count;
        }
        return 0;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PVHelpsTextHeaderView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVHelpsTextHeaderView];
    if (self.questionClassModel == nil) return headView;
    
    headView.questsionListModel = [self.questionClassModel.classList sc_safeObjectAtIndex:section];
    PV(pv)
    [headView setPVHelpsTextHeaderViewBlock:^{
        PVHelpDetailsViewController* vc = [[PVHelpDetailsViewController alloc]  init];
        if (pv.questionClassModel.classList) {
            vc.questListModel = [pv.questionClassModel.classList sc_safeObjectAtIndex:section];
            [pv.navigationController pushViewController:vc animated:true];
        }
        
    }];
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PVHelpsTextTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVHelpsTextTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.questionClassModel.classList) {
        PVQuestionListModel *listModel = self.questionClassModel.classList[indexPath.section];
        if (listModel.questionList) {
            cell.questionModel = [listModel.questionList sc_safeObjectAtIndex:indexPath.row];
        }
    }
//    cell.title = @"哈哈哈哈哈哈啊哈哈";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PV(pv)
    PVHelpDetailsViewController* vc = [[PVHelpDetailsViewController alloc]  init];
    if (pv.questionClassModel.classList) {
        vc.questListModel = [pv.questionClassModel.classList sc_safeObjectAtIndex:indexPath.section];
        [pv.navigationController pushViewController:vc animated:true];
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return IPHONE6WH(50);
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6WH(50);
}

/// MARK:- ====================== 懒加载 ======================
-(UITableView *)helpsTableView{
    if (!_helpsTableView) {
        _helpsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight - kNavBarHeight - SafeAreaBottomHeight - kDistanceHeightRatio(96)) style:UITableViewStyleGrouped];
        _helpsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _helpsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _helpsTableView.showsVerticalScrollIndicator = false;
//        [_helpsTableView registerClass:[PVHelpsTextTableViewCell class] forCellReuseIdentifier:resuPVHelpsTextTableViewCell];
        [_helpsTableView registerNib:[UINib nibWithNibName:@"PVHelpsTextTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVHelpsTextTableViewCell];
        [_helpsTableView registerNib:[UINib nibWithNibName:@"PVHelpsTextHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVHelpsTextHeaderView];
        _helpsTableView.delegate = self;
        _helpsTableView.dataSource = self;
        _helpsTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _helpsTableView.sectionFooterHeight = 2.0;
        _helpsTableView.estimatedSectionHeaderHeight = IPHONE6WH(50);
        
    }
    return _helpsTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
