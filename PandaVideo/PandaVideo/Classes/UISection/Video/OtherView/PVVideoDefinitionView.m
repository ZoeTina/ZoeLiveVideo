//
//  PVVideoDefinitionView.m
//  VideoDemo
//
//  Created by cara on 17/8/16.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoDefinitionView.h"
#import "PVVideoDefinitionCell.h"
#import "PVLiveTelevisionCodeRateList.h"


static NSString* resuPVVideoDefinitionCell = @"resuPVVideoDefinitionCell";

@interface  PVVideoDefinitionView() <UITableViewDataSource,UITableViewDelegate>

//@property(nonatomic, strong)NSArray* definitionArrs;
//@property(nonatomic, strong)NSMutableArray* btnArrs;
//@property(nonatomic, strong)UIButton* selectedBtn;
@property(nonatomic, strong)UITableView* definitionTableView;
@property(nonatomic, strong)NSMutableArray*  definitionDataSource;
@property(nonatomic, copy)PVVideoDefinitionViewBlock callBlock;
@property(nonatomic, strong)PVLiveTelevisionCodeRateList* selectedCodeRateList;
@property(nonatomic, copy)PVIntroduceDefinitionViewBlock callIntroduceBlock;

@end

@implementation PVVideoDefinitionView

-(instancetype)init{
    
    self = [super init];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.8;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.definitionTableView];
    [self.definitionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@86);
            make.width.equalTo(@100);
            make.centerX.equalTo(self);
    }];
    
    /*
    self.definitionArrs = @[@"超清",@"高清",@"标清",@"流畅"];
 CGFloat topAndBottomMargin = 86;
    CGFloat margin = 25;
    CGFloat width = 100;
    CGFloat height = 33;
    for (int i=0; i<self.definitionArrs.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.definitionArrs[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor sc_colorWithHex:0x2AB4E4] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.cornerRadius = height*0.5;
        btn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
        btn.layer.borderWidth = 1.0f;
        [self addSubview:btn];
        CGFloat y = i*(height+margin) + topAndBottomMargin;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@(y));
        }];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArrs addObject:btn];
        if (i == 0) {
            self.selectedBtn = btn;
            self.selectedBtn.layer.borderColor = [UIColor sc_colorWithHex:0x2BBCF0].CGColor;
            self.selectedBtn.selected = true;
        }
    }
     */
}


-(void)setChanelListModel:(PVLiveTelevisionChanelListModel *)chanelListModel{
    _chanelListModel = chanelListModel;
    [self.definitionDataSource removeAllObjects];
    [self.definitionDataSource addObjectsFromArray:chanelListModel.codeRateLists];
    for (PVLiveTelevisionCodeRateList* codeRateList in self.definitionDataSource) {
        if (codeRateList.isSelected) {
            self.selectedCodeRateList = codeRateList;
            break;
        }
    }
    [self.definitionTableView reloadData];
}

- (void)setIntroduceModel:(PVIntroduceModel *)introduceModel{
    _introduceModel = introduceModel;
    [self.definitionDataSource removeAllObjects];
    [self.definitionDataSource addObjectsFromArray:introduceModel.codeRateList];
    for (PVLiveTelevisionCodeRateList* codeRateList in self.definitionDataSource) {
        if (codeRateList.isSelected) {
            self.selectedCodeRateList = codeRateList;
            break;
        }
    }
    [self.definitionTableView reloadData];
}

/// MARK:- ===== UITableViewDataSource,UITableViewDelegate ======
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.definitionDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PVVideoDefinitionCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVVideoDefinitionCell];
    
    if (self.introduceModel) {
        cell.introduceReteList = self.definitionDataSource[indexPath.row];
    }else{
        cell.rateListModel = self.definitionDataSource[indexPath.row];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.definitionDataSource.count==1) {
        return;
    }
    PVLiveTelevisionCodeRateList* rateListModel = self.definitionDataSource[indexPath.row];
    if (rateListModel == self.selectedCodeRateList)return;
    self.selectedCodeRateList = rateListModel;
    
    for (PVLiveTelevisionCodeRateList* rateList in self.definitionDataSource) {
        rateList.isSelected = false;
    }
    
    if (self.introduceModel) {
        for (CodeRateList* rateList in self.definitionDataSource) {
            rateList.isSelected = false;
        }
    }else{
        for (PVLiveTelevisionCodeRateList* rateList in self.definitionDataSource) {
            rateList.isSelected = false;
        }
    }
    rateListModel.isSelected = true;
    [tableView reloadData];
    
    if (self.introduceModel) {
        if (self.callIntroduceBlock) {
            self.callIntroduceBlock(self.introduceModel);
        }
        
    }else{
        if (self.callBlock) {
            self.callBlock(self.chanelListModel);
        }
    }
}
-(void)setPVVideoDefinitionViewBlock:(PVVideoDefinitionViewBlock)block{
    self.callBlock = block;
}

- (void)setPVIntroduceViewBlock:(PVIntroduceDefinitionViewBlock)block{
    self.callIntroduceBlock = block;
}


/*
-(void)btnClicked:(UIButton*)btn{
    if (self.selectedBtn == btn) return;
    //切换清晰度
    self.selectedBtn.selected = false;
    self.selectedBtn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
    self.selectedBtn = btn;
    self.selectedBtn.layer.borderColor = [UIColor sc_colorWithHex:0x2BBCF0].CGColor;
    self.selectedBtn.selected = true;
}

-(NSMutableArray *)btnArrs{
    if (!_btnArrs) {
        _btnArrs = [NSMutableArray array];
    }
    return _btnArrs;
}
 */
-(UITableView *)definitionTableView{
    if (!_definitionTableView) {
        _definitionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _definitionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_definitionTableView registerClass:[PVVideoDefinitionCell class] forCellReuseIdentifier:resuPVVideoDefinitionCell];
        _definitionTableView.backgroundColor = [UIColor clearColor];
        _definitionTableView.dataSource = self;
        _definitionTableView.delegate = self;
        _definitionTableView.showsVerticalScrollIndicator = false;
        _definitionTableView.showsVerticalScrollIndicator = false;
        _definitionTableView.bounces = false;
    }
    return _definitionTableView;
}
-(NSMutableArray *)definitionDataSource{
    if (!_definitionDataSource) {
        _definitionDataSource = [NSMutableArray array];
    }
    return _definitionDataSource;
}


@end
