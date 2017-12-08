//
//  PVRechargeDetailViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRechargeDetailViewController.h"
#import "PVRechargeRecordCell.h"

static NSString* resuPVRechargeRecordCell = @"resuPVRechargeRecordCell";


@interface PVRechargeDetailViewController () <UITableViewDataSource, UITableViewDelegate>

///设置tableview
@property(nonatomic, strong)UITableView* recordTableView;
///数据源
@property(nonatomic, strong)NSMutableArray* dataSource;

@end

@implementation PVRechargeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.recordTableView];
}

/// MARK:- ========== UITableViewDelegate,UITableViewDataSource ========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVRechargeRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVRechargeRecordCell forIndexPath:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6WH(50);
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


// MARK:- ====================== 懒加载 ======================
-(UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _recordTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recordTableView.showsVerticalScrollIndicator = false;
        [_recordTableView registerNib:[UINib nibWithNibName:@"PVRechargeRecordCell" bundle:nil] forCellReuseIdentifier:resuPVRechargeRecordCell];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.backgroundColor = [UIColor whiteColor];
        _recordTableView.sectionFooterHeight = 1.0;
        _recordTableView.sectionHeaderHeight = 1.0;
    }
    return _recordTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

@end
