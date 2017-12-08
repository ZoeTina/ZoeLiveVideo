//
//  PVHelpDetailsViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHelpDetailsViewController.h"
#import "PVDetailHeipsTextHeadView.h"
#import "PVHelpsTextTableViewCell.h"
#import "PVDetailHelpsTextFootView.h"
#import "PVHistoryDetailModel.h"
#import "PVQuestionDetailModel.h"

static NSString* resuPVDetailHeipsTextHeadView = @"resuPVDetailHeipsTextHeadView";
static NSString* resuPVHelpsTextTableViewCell = @"resuPVHelpsTextTableViewCell";
static NSString* resuPVDetailHelpsTextFootView = @"resuPVDetailHelpsTextFootView";

@interface PVHelpDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

///设置tableview
@property(nonatomic, strong)UITableView* detalHelpsTableView;
///数据源
@property(nonatomic, strong)NSMutableArray* dataSource;

@property (nonatomic, strong) PVQuestionDetailModel *questionDetailModel;
@end

@implementation PVHelpDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
}

-(void)setupNavigationBar{
    NSString* titel = @"常见问题";
    if (self.section) {
        titel = (self.section == 1) ? @"系统问题" : @"其他问题";
    }
    self.scNavigationItem.title = titel;
    self.automaticallyAdjustsScrollViewInsets = false;
}
-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.detalHelpsTableView belowSubview:self.scNavigationBar];
}

- (void)loadData {
    PV(pv);
    
    
    [PVNetTool getDataWithUrl:self.questListModel.questionJsonUrl success:^(id result) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            self.questionDetailModel = [PVQuestionDetailModel yy_modelWithDictionary:result];
//            self.questionClassModel = [PVQuestionClassModel yy_modelWithDictionary:result];
//            [pv.helpsTableView reloadData];
            for (PVQuestionModel *model in self.questionDetailModel.questionList) {
                model.isOpen = NO;
            }
        }
        [self.detalHelpsTableView reloadData];
        
    } failure:^(NSError *error) {
        SCLog(@"-------error--------%@",error);
    }];
}

/// MARK:- ===== UITableViewDelegate,UITableViewDataSource ==========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.questionDetailModel) {
        return self.questionDetailModel.questionList.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    PVHistoryDetailModel* model = self.dataSource[section];
    if (self.questionDetailModel.questionList) {
        PVQuestionModel *questionModel = [self.questionDetailModel.questionList sc_safeObjectAtIndex:section];
        return questionModel.isOpen ? 2 : 0;
    }
//    return model.isOpen ? 3 : 0;
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PVDetailHeipsTextHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVDetailHeipsTextHeadView];
    PV(pv)
    PVQuestionModel* detailModel = [self.questionDetailModel.questionList sc_safeObjectAtIndex:section];
    headView.detailModel = detailModel;
    [headView setPVDetailHeipsTextHeadViewBlock:^{
        PVQuestionModel* model = [pv.questionDetailModel.questionList sc_safeObjectAtIndex:section];
        model.isOpen = !model.isOpen;
        [tableView reloadData];
        NSLog(@"展开");
    }];
    
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PVHelpsTextTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVHelpsTextTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isQuestion = true;
    PVQuestionModel *questionModel = [self.questionDetailModel.questionList sc_safeObjectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
      cell.title = @"当出现这种提示时，您可以这么做:";
      return cell;
    }
    cell.title = questionModel.answer;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    PVDetailHelpsTextFootView* footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVDetailHelpsTextFootView];
    PVHistoryDetailModel* model = self.dataSource[section];
    footView.detailModel = model;
    [footView setPVDetailHelpsTextFootViewBlock:^(UIButton *userfulBtn, UIButton *unlessUserfulBtn) {
        if (userfulBtn) {
            model.isHelpStatus = !model.isHelpStatus;
        }else{
            model.isUnlessStatus = !model.isUnlessStatus;
        }
        [tableView  reloadData];
    }];
    
    return model.isOpen ? footView : nil;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return IPHONE6WH(50);
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return IPHONE6WH(30);
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    PVHistoryDetailModel* model = self.dataSource[section];
    return model.isOpen ? IPHONE6WH(50) : 0.01;
}

/// MARK:- ====================== 懒加载 ======================
-(UITableView *)detalHelpsTableView{
    if (!_detalHelpsTableView) {
        _detalHelpsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight - kNavBarHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _detalHelpsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detalHelpsTableView.showsVerticalScrollIndicator = false;
       [_detalHelpsTableView registerNib:[UINib nibWithNibName:@"PVDetailHeipsTextHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVDetailHeipsTextHeadView];
//        [_detalHelpsTableView registerClass:[PVHelpsTextTableViewCell class] forCellReuseIdentifier:resuPVHelpsTextTableViewCell];
        [_detalHelpsTableView registerNib:[UINib nibWithNibName:@"PVHelpsTextTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVHelpsTextTableViewCell];
        [_detalHelpsTableView registerNib:[UINib nibWithNibName:@"PVDetailHelpsTextFootView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVDetailHelpsTextFootView];
        _detalHelpsTableView.delegate = self;
        _detalHelpsTableView.dataSource = self;
        _detalHelpsTableView.backgroundColor = [UIColor sc_colorWithHex:0xffffff];
        _detalHelpsTableView.estimatedSectionHeaderHeight = IPHONE6WH(50);
        _detalHelpsTableView.estimatedRowHeight = IPHONE6WH(30);
    }
    return _detalHelpsTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (int i=0; i<16; i++) {
            PVHistoryDetailModel* model = [[PVHistoryDetailModel alloc]  init];
            model.isOpen = false;
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}
@end
