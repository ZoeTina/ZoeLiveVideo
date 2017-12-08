//
//  PVScreeningBoxView.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVScreeningBoxView.h"
#import "PVScreeningBoxViewCell.h"

static NSString *CellIdentifier = @"PVScreeningBoxViewCell";

@interface PVScreeningBoxView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *lzTableView;
@property (nonatomic, strong) PVScreeningBoxViewCell *tableViewCell;
@property (nonatomic, copy) NSMutableDictionary     *dictionary;
@property (nonatomic, strong) PVChoiceSecondColumnModel *secondColumnModel;
@property (nonatomic, strong) NSMutableArray *itemModelArray;

@end

@implementation PVScreeningBoxView

// 后执行
-(instancetype)initWithModels:(PVChoiceSecondColumnModel *) secondColumnModel{
    
    if ( self = [super init] )
    {
        
        NSMutableArray *mbArray = [[NSMutableArray alloc] init];
        if (secondColumnModel) {
            for (Filter *filter in secondColumnModel.filterList) {
                if (filter.keys.count==0) {
                    [mbArray addObject:@([secondColumnModel.filterList indexOfObject:filter])];
                }
            }
            for (NSNumber *num in mbArray) {
                [secondColumnModel.filterList removeObjectAtIndex:num.integerValue];
            }
        }
        
        self.secondColumnModel = secondColumnModel;

        for (Filter *filter in self.secondColumnModel.filterList) {
            [self.itemModelArray addObject:filter];
        }
        
        self.frame = CGRectMake(0, 0, YYScreenWidth, self.itemModelArray.count*AUTOLAYOUTSIZE(50));
        [self addSubview:self.lzTableView];
        [self.lzTableView reloadData];
    }
    return self;
}

// 先执行
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVScreeningBoxViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.filter = self.itemModelArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return self.itemModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AUTOLAYOUTSIZE(50);
}

-(UITableView *)lzTableView{

    if (!_lzTableView) {
        _lzTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _lzTableView.showsVerticalScrollIndicator = false;
        [_lzTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
           forCellReuseIdentifier:CellIdentifier];
        [_lzTableView setSeparatorInset:UIEdgeInsetsMake(13,0,0,0)];
        _lzTableView.separatorStyle = NO;
        _lzTableView.delegate = self;
        _lzTableView.dataSource = self;
        _lzTableView.scrollEnabled = NO;
//        _lzTableView.userInteractionEnabled = NO;
        _lzTableView.backgroundColor = kColorWithRGB(211, 0, 0);
    }
    return _lzTableView;
}

- (NSMutableArray *)itemModelArray{
    if (!_itemModelArray) {
        _itemModelArray = [[NSMutableArray alloc] init];
    }
    return _itemModelArray;
}
@end
