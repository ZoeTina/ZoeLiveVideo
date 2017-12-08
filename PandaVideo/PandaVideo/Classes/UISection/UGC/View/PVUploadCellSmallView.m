//
//  PVUploadCellSmallView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUploadCellSmallView.h"

@implementation PVUploadCellSmallView

- (instancetype)initUploadStateViewWithUploading {
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PVUploadCellSmallView" owner:self options:nil];
        self = [array objectAtIndex:0];
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

- (instancetype)initUploadStateViewWithProcessing {
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PVUploadCellSmallView" owner:self options:nil];
        self = [array objectAtIndex:1];
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

- (instancetype)initUploadStateViewWithRePublish {
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PVUploadCellSmallView" owner:self options:nil];
        self = [array objectAtIndex:2];
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

- (instancetype)initUploadStateViewWithFailure {
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PVUploadCellSmallView" owner:self options:nil];
        self = [array objectAtIndex:3];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}

@end
