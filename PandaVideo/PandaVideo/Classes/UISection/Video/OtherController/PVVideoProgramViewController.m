//
//  PVVideoProgramViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoProgramViewController.h"
#import "PVVideoLiveTimeTableViewCell.h"
#import "PVVideoLiveTableViewCell.h"
#import "PVNoProGramView.h"

static NSString* resuPVVideoLiveTimeTableViewCell = @"resuPVVideoLiveTimeTableViewCell";
static NSString* resuPVVideoLiveTableViewCell = @"resuPVVideoLiveTableViewCell";

@interface PVVideoProgramViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, copy)PVVideoProgramViewControllerCallBlock callBlock;
@property(nonatomic, copy)PVVideoProgramViewControllerRealDataCallBlock realDataCallBlock;
@property (nonatomic, strong)PVNoProGramView* noProGramView;

@end

@implementation PVVideoProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.timeTableView];
    [self.timeTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(@(60));
    }];
    
    UIView* bottomView = [[UIView alloc]  init];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.9f;
    [self.view addSubview:bottomView];
    [bottomView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.bottom.right.equalTo(self.view);
        make.left.equalTo(self.timeTableView.mas_right);
    }];
    
    [self.view addSubview:self.proGramTableView];
    [self.proGramTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.view);
        make.left.equalTo(self.timeTableView.mas_right);
    }];
    [self.noProGramView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.view);
        make.left.equalTo(self.timeTableView.mas_right);
    }];
    
}

-(void)setPVVideoProgramViewControllerCallBlock:(PVVideoProgramViewControllerCallBlock)block{
    self.callBlock = block;
}
-(void)setPVVideoProgramViewControllerRealDataCallBlock:(PVVideoProgramViewControllerRealDataCallBlock)block{
    self.realDataCallBlock = block;
}


-(void)loadloadDefaultProGram{
    if (self.defaultProGramModel.programUrl.length == 0) return;
    [PVNetTool getDataWithUrl:self.defaultProGramModel.programUrl success:^(id result) {
        if (result && [result isKindOfClass:[NSArray class]]) {
            for (NSDictionary* jsonDict in result) {
                PVLiveTelevisionDetailProGramModel* detailProGramModel = [[PVLiveTelevisionDetailProGramModel alloc]  init];
                [detailProGramModel setValuesForKeysWithDictionary:jsonDict];
                if (self.defaultProGramModel.type == 1) {
                    [detailProGramModel calculationProgramTime:self.defaultProGramModel.date];
                }else{//那么就全是回看
                    detailProGramModel.type = 1;
                }
                if (detailProGramModel.isPlaying) {
                    detailProGramModel.type = 2;
                    self.defaultDetailProGramModel = detailProGramModel;
                }
                [self.defaultProGramModel.programs addObject:detailProGramModel];
            }
            [self.proGramTableView reloadData];
            if (self.defaultDetailProGramModel) {
                NSInteger index = [self.defaultProGramModel.programs indexOfObject:self.defaultDetailProGramModel];
                NSIndexPath*  indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                [self.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"---error----=%@-",error);
    }];
}

/// MARK:- ====================== UITableViewDataSource,UITableViewDelegate ======================

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.timeTableView) {
        return self.timeDataSource.count;
    }else{
        self.noProGramView.hidden = self.defaultProGramModel.programs.count;
        return self.defaultProGramModel.programs.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.timeTableView) {
        PVVideoLiveTimeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVVideoLiveTimeTableViewCell];
        cell.proGramModel = self.timeDataSource[indexPath.row];
        return cell;
    }else{
        PVVideoLiveTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVVideoLiveTableViewCell];
        
        __block PVLiveTelevisionDetailProGramModel* detailProGramModel = self.defaultProGramModel.programs[indexPath.row];;
        cell.detailProGramModel = detailProGramModel;
        PV(pv)
        [cell setPVProGramTableViewCellCallBlock:^{
            if (detailProGramModel.appointMentStatus.integerValue == 1) {//取消预约
                detailProGramModel.appointMentStatus = @"2";
                [detailProGramModel cancelLocalNotificationWithKey:detailProGramModel.programId];
            }else{//预约
                detailProGramModel.appointMentStatus = @"1";
                [detailProGramModel sureLocalNotification];
            }
            [[PVDBManager sharedInstance] updateLiveChannelProgramModel:detailProGramModel];
            [tableView reloadData];
            if (pv.realDataCallBlock) {
                pv.realDataCallBlock();
            }
        }];
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.timeTableView) {
        return 60;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    if (tableView == self.timeTableView) {
        PVLiveTelevisionProGramModel* proGramModel = self.timeDataSource[indexPath.row];
        // if ([proGramModel.date isEqualToString:self.defaultProGramModel.date]) return;
        if (proGramModel == self.defaultProGramModel) return;
        for (PVLiveTelevisionProGramModel* tempProGramModel in self.timeDataSource) {
            tempProGramModel.isSelected = false;
        }
        self.defaultProGramModel = proGramModel;
        self.defaultProGramModel.isSelected = true;
        [self.timeTableView reloadData];
        [self.timeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        if (proGramModel.programs.count) {
            [self.proGramTableView reloadData];
        }else{
            [self loadloadDefaultProGram];
        }
    }else{
        ///点击了节目单信息
        PVLiveTelevisionDetailProGramModel* detailProGramModel = self.defaultProGramModel.programs[indexPath.row];
        if (self.defaultDetailProGramModel == detailProGramModel || detailProGramModel.type == 4) {
            return;
        }
        if (self.defaultDetailProGramModel.isPlaying ) {
            self.defaultDetailProGramModel.type = 3;
        }else{
            self.defaultDetailProGramModel.type = 1;
        }
        self.defaultDetailProGramModel = detailProGramModel;
        [self.defaultDetailProGramModel calculationProgramTime:self.defaultProGramModel.date];
        [self.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        if (self.callBlock) {
         self.callBlock(self.defaultProGramModel,self.defaultDetailProGramModel);
        }
    }
}
-(UITableView *)timeTableView{
    if (!_timeTableView) {
        _timeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _timeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_timeTableView registerClass:[PVVideoLiveTimeTableViewCell class] forCellReuseIdentifier:resuPVVideoLiveTimeTableViewCell];
        _timeTableView.backgroundColor = [UIColor blackColor];
        _timeTableView.dataSource = self;
        _timeTableView.delegate = self;
        _timeTableView.showsVerticalScrollIndicator = false;
        _timeTableView.showsVerticalScrollIndicator = false;
        _timeTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return _timeTableView;
}
-(NSMutableArray *)timeDataSource{
    if (!_timeDataSource) {
        _timeDataSource = [NSMutableArray array];
    }
    return _timeDataSource;
}
-(UITableView *)proGramTableView{
    if (!_proGramTableView) {
        _proGramTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _proGramTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _proGramTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_proGramTableView registerNib:[UINib nibWithNibName:@"PVVideoLiveTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVVideoLiveTableViewCell];
        _proGramTableView.dataSource = self;
        _proGramTableView.delegate = self;
        _proGramTableView.backgroundColor = [UIColor clearColor];
        _proGramTableView.showsVerticalScrollIndicator = false;
        _proGramTableView.showsVerticalScrollIndicator = false;
    }
    return _proGramTableView;
}
-(PVNoProGramView *)noProGramView{
    if (!_noProGramView) {
        _noProGramView = [[NSBundle mainBundle] loadNibNamed:@"PVNoProGramView" owner:nil options:0].lastObject;
        _noProGramView.noDataLabel.textColor = [UIColor whiteColor];
        [self.proGramTableView addSubview:_noProGramView];
    }
    return _noProGramView;
}

@end
