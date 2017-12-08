//
//  PVMenuModel.h
//  PandaVideo
//
//  Created by cara on 17/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"


/*
 "defaultImg3X": "http://172.16.17.188:666/Images/2017/09/06/20170906162440626xkuipbbcyl.png",
 "menuUrl": "http://182.138.102.131:8080/App/Column/choiceness/choiceness.json",
 "menuType": 1,
 "menuId": "1",
 "selectImg2X": "http://172.16.17.188:666/Images/2017/09/06/20170906162438403wqswegdohk.png",
 "defaultImg2X": "http://172.16.17.188:666/Images/2017/09/06/20170906162434758wtrjaencfb.png",
 "selectImg3X": "http://172.16.17.188:666/Images/2017/09/06/20170906162443932dkhfbksvws.png",
 "menuIconName": "精选",
 "menuName": "精选"
*/

@interface PVMenuModel : PVBaseModel

@property(nonatomic, assign)NSInteger tabbarIndex;
@property(nonatomic, copy)NSString*  defaultImg3X;
@property(nonatomic, copy)NSString*  menuUrl;
@property(nonatomic, copy)NSString*  menuType;
@property(nonatomic, copy)NSString*  menuId;
@property(nonatomic, copy)NSString*  selectImg2X;
@property(nonatomic, copy)NSString*  defaultImg2X;
@property(nonatomic, copy)NSString*  selectImg3X;
@property(nonatomic, copy)NSString*  menuIconName;
@property(nonatomic, copy)NSString*  menuName;
@property(nonatomic, copy)NSString*  tvLiveUrl;
@property(nonatomic, copy)NSString*  interactiveLiveUrl;
@property(nonatomic, strong)NSMutableArray<NSString*>*  menuUrls;
///是否跳转过来滴
@property(nonatomic, copy)NSString* jumpType;
///跳转url
@property(nonatomic, copy)NSString* jumpUrl;

@end
