//
//  PVDemandSystemVideoModel.h
//  PandaVideo
//
//  Created by cara on 2017/11/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

/*
 videoTitle = [绵阳]测试春风十里;
 code = 1e1473288efd3376bc7fd32;
 
 videoType = 1;
 videoVImage = http://pandafile.sctv.com:42086/Images/2017/11/12/20171112143527367vnfwjwnaby.jpg;
 tagData = {
 topLeftCorner = {"tagColor":"","tagType":6,"detail":[],"tagName":"","tagImage":""};
 topRightCorner = {"tagType":9,"detail":"#696969,#FFA500,#F8F8FF,#00FF00,#FFFF00,#FF0000","tagName":"","tagImage":""};
 bottomRightCorner = {"tagColor":"","tagType":0,"detail":[],"tagName":"","tagImage":""};
 }
 ;
 videoUrl = ;
 videoSubTitle = [object Object];
 */



@interface PVDemandSystemVideoModel : PVBaseModel

@property(nonatomic, copy)NSString* videoTitle;
@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* videoType;
@property(nonatomic, copy)NSString* videoVImage;
@property(nonatomic, copy)NSString* videoUrl;
@property(nonatomic, copy)NSString* videoSubTitle;

@end
