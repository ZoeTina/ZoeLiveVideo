//
//  PVStarViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVStarViewController.h"
#import "PVStarTableViewCell.h"
#import "PVStarDetailViewController.h"

static NSString* resuPVStarTableViewCell = @"resuPVStarTableViewCell";

@interface PVStarViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UITableView *starTabelView;
@property (nonatomic, strong)NSMutableArray* dataSource;

@end

@implementation PVStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerStarTableViewCell];
    
}

-(void)registerStarTableViewCell{
    [self.starTabelView registerNib:[UINib nibWithNibName:@"PVStarTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVStarTableViewCell];
}
/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.dataSource.count+10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVStarTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVStarTableViewCell];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PVStarDetailViewController* vc = [[PVStarDetailViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:true];
}
- (IBAction)backBtnClicked {
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = ScreenHeight;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
