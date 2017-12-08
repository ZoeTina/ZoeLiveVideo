//
//  PVTelevisionCloudViewController.m
//  PandaVideo
//
//  Created by cara on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTelevisionCloudViewController.h"
#import "PVTelevisionCloudCell.h"
#import "PVSerachViewController.h"
#import "PVLookOrdermanagerViewController.h"


static NSString* resuPVTelevisionCloudCell = @"resuPVTelevisionCloudCell";


@interface PVTelevisionCloudViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView* televisionTabelview;

@end

@implementation PVTelevisionCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.televisionTabelview belowSubview:self.scNavigationBar];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = self.nikeName;
}

/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVTelevisionCloudCell *cell =  [tableView dequeueReusableCellWithIdentifier:resuPVTelevisionCloudCell];
    if(indexPath.row == 0){
        cell.titleLabel.text = @"云看单管理";
        cell.iconImageView.image = [UIImage imageNamed:@"yunkandan"];
    }else{
        cell.titleLabel.text = @"添加云看单";
        cell.iconImageView.image = [UIImage imageNamed:@"add_yunkandan"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {//云看单管理
        PVLookOrdermanagerViewController* vc = [[PVLookOrdermanagerViewController alloc]  init];
        vc.targetPhone = self.targetPhone;
        [self.navigationController pushViewController:vc animated:true];
    }else{//添加云看单
        PVSerachViewController* vc = [[PVSerachViewController alloc]  init];
        vc.isFamily = true;
        vc.nikename = self.nikeName;
        vc.targetPhone = self.targetPhone;
        vc.nav = self.navigationController;
        [self.navigationController pushViewController:vc animated:true];        
    }
}


-(UITableView *)televisionTabelview{
    if (!_televisionTabelview) {
        _televisionTabelview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _televisionTabelview.frame = self.view.bounds;
        CGFloat bottom = kiPhoneX ? 34 : 0;
        _televisionTabelview.sc_height = self.view.sc_height-bottom;
        _televisionTabelview.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0);
        _televisionTabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_televisionTabelview registerNib:[UINib nibWithNibName:@"PVTelevisionCloudCell" bundle:nil] forCellReuseIdentifier:resuPVTelevisionCloudCell];
        _televisionTabelview.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _televisionTabelview.dataSource = self;
        _televisionTabelview.delegate = self;
        _televisionTabelview.showsVerticalScrollIndicator = false;
        _televisionTabelview.showsVerticalScrollIndicator = false;
    }
    return _televisionTabelview;
}

@end
