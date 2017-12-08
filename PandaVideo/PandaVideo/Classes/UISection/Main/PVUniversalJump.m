//
//  PVUniversalJump.m
//  PandaVideo
//
//  Created by cara on 17/9/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUniversalJump.h"
#import "PVDemandViewController.h"
#import "PVInteractiveZBViewController.h"
#import "PVWebViewController.h"
#import "PVHomeViewController.h"
#import "PVChoiceColumnController.h"
#import "PVSpecialSecondDetailController.h"
#import "PVStarDetailViewController.h"
#import "PVSpecialViewController.h"
#import "PVFindHomeViewController.h"
#import "PVInterractionViewController.h"
#import "PVActivityViewController.h"
#import "PVTelevisionViewController.h"
#import "PVRankingListController.h"
#import "PVTeleplayListViewController.h"
#import "PVLIveViewController.h"
#import "PVTeleplayChildViewController.h"
#import "PVUgcHtmlViewController.h"

@interface PVUniversalJump()

@property(nonatomic, strong)PVJumpModel* jumpModel;

@end


@implementation PVUniversalJump

-(instancetype)initPVUniversalJumpWithPVJumpModel:(PVJumpModel *)jumpModel{
    if (self = [super init]) {
        self.jumpModel = jumpModel;
    }
    return self;
}

///1.点播详情页
-(void)jumpDemand{
    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
    vc.url = self.jumpModel.jumpUrl;
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///2.互动直播详情页
-(void)jumpInteractive{
    PVInteractiveZBViewController* vc = [[PVInteractiveZBViewController alloc]  init];
    vc.menuUrl = self.jumpModel.jumpUrl;
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///3.电视直播详情页-直播
-(void)jumpTelevisionLive{
    PVLIveViewController* liveVC = self.self.jumpModel.jumpVC.tabBarController.childViewControllers[1].childViewControllers.firstObject;
    if (liveVC.childViewControllers.count > 0) {
        PVTelevisionViewController* vc = liveVC.childViewControllers.firstObject;
        vc.jumpType = @"2";
        vc.jumpUrl = self.jumpModel.jumpUrl;
        [liveVC scrollTelevision];
    }else{
        liveVC.menuModel.jumpType = @"1";
        liveVC.menuModel.jumpUrl = self.jumpModel.jumpUrl;
    }
    self.jumpModel.jumpVC.tabBarController.selectedIndex = 1;
    /*
    PVTelevisionViewController* vc = [[PVTelevisionViewController alloc]  init];
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
     */
    
}
///4.电视直播详情页-回看
-(void)jumpTelevisionLookBack{
    self.jumpModel.jumpVC.tabBarController.selectedIndex = 1;
    /*
    PVTelevisionViewController* vc = [[PVTelevisionViewController alloc]  init];
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
     */
    
}
///5.H5外链（webview）
-(void)jumpWebview{
    PVWebViewController* vc = [[PVWebViewController alloc]  initWebViewControllerWithWebUrl:self.jumpModel.jumpUrl webTitle:self.jumpModel.jumpTitle];
    if (self.jumpModel.jumpUrl.length < 10) {
        return;
    }
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///6.专题详情页
-(void)jumpDetailSpecial{
    PVSpecialSecondDetailController* vc = [[PVSpecialSecondDetailController alloc]  init];
    vc.menuUrl = self.jumpModel.jumpUrl;
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///8.明星详情页
-(void)jumpStarDetail{
    PVStarDetailViewController* vc = [[PVStarDetailViewController alloc]  init];
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///9.图文（消息中心）
///10.点播二级栏目列表
-(void)jumpTeleplay{
    PVTeleplayListViewController* vc = [[PVTeleplayListViewController alloc]  init];
    vc.url = self.jumpModel.jumpUrl;
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///11.专题列表
-(void)jumpSpecial{
    PVSpecialViewController* vc = [[PVSpecialViewController alloc]  init];
    vc.url = self.jumpModel.jumpUrl;
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///12.排行榜列表
-(void)jumpRankingList{
    PVRankingListController* vc = [[PVRankingListController alloc]  init];
    vc.url = self.jumpModel.jumpUrl;
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///13.一级栏目页面
-(void)jumpColumn{
    if (![self.jumpModel.jumpVC isKindOfClass:[PVChoiceColumnController class]]) {
        PVChoiceColumnController* vc = [[PVChoiceColumnController alloc]  init];
        vc.url = self.jumpModel.jumpUrl;
        vc.navType = 1;
        vc.navTitle = self.jumpModel.jumpTitle;
        [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
    }else{
        PVChoiceColumnController* vc = (PVChoiceColumnController*)self.jumpModel.jumpVC;
        NSInteger index = -1;
        for (PVTempletModel* templetModel in vc.templetDataSource) {
            if ([templetModel.modelType isEqualToString:self.jumpModel.jumpVCID]) {
                index = [vc.templetDataSource indexOfObject:templetModel];
                break;
            }
        }
        if (index == -1) {//生成新的对象
            PVChoiceColumnController* vc = [[PVChoiceColumnController alloc]  init];
            vc.url = self.jumpModel.jumpUrl;
            vc.navType = 1;
            vc.navTitle = self.jumpModel.jumpTitle;
            [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
        }else{//利用旧对象，翻滚到对应的模板
            PVHomeViewController* homeVC = (PVHomeViewController*) self.jumpModel.jumpVC.parentViewController;
            [homeVC scrollColumn:index];
        }
    }
}
///14.大型活动栏目页
-(void)jumpActivityHome{
    PVActivityViewController* vc = [[PVActivityViewController alloc]  init];
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///15.互动直播首页
-(void)jumpInterractionHome{
    PVInterractionViewController* vc = [[PVInterractionViewController alloc]  init];
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///16.发现首页
-(void)jumpFindHome{
    PVFindHomeViewController* vc = [[PVFindHomeViewController alloc]  init];
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///17.二级栏目
-(void)jumpTeleplayListHome{
    PVTeleplayChildViewController* vc = [[PVTeleplayChildViewController alloc]  init];
    vc.type = 3;
    vc.title = self.jumpModel.jumpTitle;
    vc.teleplayUrl = self.jumpModel.jumpUrl;
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}
///18.ugc
-(void)jumpUgcHtmlViewController{
    PVUgcHtmlViewController* vc = [[PVUgcHtmlViewController alloc]  init];
    [self.jumpModel.jumpVC.navigationController pushViewController:vc animated:true];
}



///给外界调用进行跳转
-(void)jumpVniversalJumpVC{
    
    switch (self.jumpModel.jumpID.intValue) {
        case 1:
            [self jumpDemand];
            break;
        case 2:
            [self jumpInteractive];
            break;
        case 3:
            [self jumpTelevisionLive];
            break;
        case 4:
            [self jumpTelevisionLive];
            break;
        case 5:
            [self jumpWebview];
            break;
        case 6:
            [self jumpDetailSpecial];
            break;
        case 7:
            [self jumpWebview];
            break;
        case 8:
            [self jumpStarDetail];
            break;
        case 10:
            [self jumpTeleplay];
            break;
        case 11:
            [self jumpSpecial];
            break;
        case 12:
            [self jumpRankingList];
            break;
        case 13:
            [self jumpColumn];
            break;
        case 14:
            [self jumpColumn];
            break;
        case 15:
            [self jumpColumn];
            break;
        case 16:
            [self jumpFindHome];
            break;
        case 17:
            [self jumpTeleplayListHome];
            break;
        case 18:
            [self jumpUgcHtmlViewController];
            break;
        default:
            break;
    }
}

@end

@implementation PVJumpModel
@end
