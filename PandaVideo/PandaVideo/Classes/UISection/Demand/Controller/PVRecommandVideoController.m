//
//  PVRecommandVideoController.m
//  PandaVideo
//
//  Created by cara on 17/8/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRecommandVideoController.h"
#import "PVDemandRecommandTableViewCell.h"

static NSString* resuPVDemandRecommandTableViewCell = @"resuPVDemandRecommandTableViewCell";

@interface PVRecommandVideoController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *recommandLabel;
//@property (nonatomic, strong)NSMutableArray* dataSource;
@property (nonatomic, copy)PVRecommandVideoControllerCallBlock callBlock;

@end

@implementation PVRecommandVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recommandLabel.font = [UIFont fontWithName:FontBlod size:15];    
    [self registerRecommandTableViewCell];
}
-(void)registerRecommandTableViewCell{
    
    self.recommandTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.recommandTableView registerNib:[UINib nibWithNibName:@"PVDemandRecommandTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVDemandRecommandTableViewCell];
}

-(void)setPVRecommandVideoControllerCallBlock:(PVRecommandVideoControllerCallBlock)block{
    self.callBlock = block;
}

-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 1) {
        self.recommandLabel.text = @"小编推荐";
    }else if (type == 2){
        self.recommandLabel.text = @"猜你喜欢";
    }
}

/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVDemandRecommandTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVDemandRecommandTableViewCell];
    if (self.type == 1) {
        cell.videoListModel = self.dataSource[indexPath.row];
    }else if (self.type == 2){
        cell.systemVideoModel = self.dataSource[indexPath.row];
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self backBtnClicked];
    if (self.callBlock) {
        if (self.type == 1) {
            self.callBlock(self.dataSource[indexPath.row],nil,self.type);
        }else if (self.type == 2){
            self.callBlock(nil,self.dataSource[indexPath.row],self.type);
        }
    }
}

- (IBAction)backBtnClicked {
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = ScreenHeight;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
}
@end
