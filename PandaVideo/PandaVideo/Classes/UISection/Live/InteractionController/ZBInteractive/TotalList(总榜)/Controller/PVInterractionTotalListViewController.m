//
//  PVInterractionTotalListViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInterractionTotalListViewController.h"
#import "PVBroadcastLiveCell.h"
#import "PVCurrentListModel.h"

static NSString *CellIdentifier = @"PVInterractionTotalListViewController";

@interface PVInterractionTotalListViewController ()

@property (nonatomic, strong) NSMutableArray *itemModelArray;
@property (nonatomic, strong) PVCurrentListModel *currentListModel;
@property (nonatomic, copy) NSString *parentId;


@end

@implementation PVInterractionTotalListViewController
- (id)initDictionary:(NSDictionary *)dictionary{
    
    if ( self = [super init] ){
        _parentId  = dictionary[@"parentId"];//@"1be84ad1b55a47b3bf2933c33d6e98f0";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithRGB(242, 242, 242);
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"PVBroadcastLiveCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [Utils setExtraCellLineHidden:self.tableView];
    self.tableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void) loadData{
    NSDictionary *dictionary = @{@"liveId":_parentId};
    [PVNetTool postDataWithParams:dictionary url:@"getTotalRankingList" success:^(id result) {
        YYLog(@"result -- %@",result);
        if (result != nil) {
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                
                if ([[result pv_objectForKey:@"rs"] integerValue]==200) {
                    
                    PVCurrentListModel *currentListModel = [[PVCurrentListModel alloc] init];
                    [currentListModel setValuesForKeysWithDictionary:result];
                    self.currentListModel = currentListModel;
                    
                    YYLog(@"获取当前榜单数据---result --%@",result);
                    // 根据直播基本信息中的 礼物URL获取
                    [self.itemModelArray removeAllObjects];
                    for (int i=0; i<[self.currentListModel.listData.rankingList count]; i++) {
                        [self.itemModelArray addObject:self.currentListModel.listData.rankingList[i]];
                    }
                }
            }else{
                YYLog(@"礼物模板数据没有-");
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

kRemoveCellSeparator

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PVBroadcastLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PVBroadcastLiveCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listDataModel = self.itemModelArray[indexPath.row];
    [cell setTagGradation:indexPath.row];
    return cell;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.itemModelArray.count;
}

// 每个cell  高度多少
//---------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 获取当前 Cell 高度
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}

#pragma mark -
#pragma mark Table View Delegate Methods
#pragma mark - 选中的哪个Cell
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *) itemModelArray{
    
    if (_itemModelArray == nil) {
        
        _itemModelArray = [[NSMutableArray alloc] init];
    }
    return _itemModelArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
