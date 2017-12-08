//
//  QWArrayDataSource.h
//  QuJie
//
//  Created by cara on 16/8/3.
//  Copyright © 2016年 cara. All rights reserved.
//
/*
 本类作用：用以处理TableView以及CollectionView的数据源
 */

#import <Foundation/Foundation.h>

// 用于配置当前Cell的数据
// id cell表示什么类型的Cell
// id item表示什么类型的模型对象
typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface QWArrayDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

// 参数1：用以数据源的控制，主要是通过改数组来控制当前tableView或者collectionView显示Cell的数量
// 参数2：当前需要显示的cell的重用标示
// 参数3：用以配置当前cell数据的block
- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

// 通过indexPath来获取当前具体的某一个对象
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end