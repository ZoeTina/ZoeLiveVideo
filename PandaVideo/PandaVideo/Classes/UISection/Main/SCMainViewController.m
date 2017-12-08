//
//  SCMainViewController.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/28.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCMainViewController.h"
#import "SCNavigationController.h"
#import "PVMenuModel.h"
#import "PVHomeViewController.h"
#import "PVLIveViewController.h"
#import "PVFamilyViewController.h"
#import "PVActivityViewController.h"
#import "PVMineViewController.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UITabBar+PVBadge.h"

@interface SCMainViewController ()

@property(nonatomic, strong)NSMutableArray<PVMenuModel*>* dataSource;
@property(nonatomic, assign)BOOL isUsingDefaultImages;

@end

@implementation SCMainViewController

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addObverser];
    [self loadData];
    
    //获取到进入这个界面的次数
//    NSInteger  comeInIndex = [kUserDefaults integerForKey: @"comeInMainTotal"];
//    if (comeInIndex < 2) {
//        [kUserDefaults setInteger:(comeInIndex + 1) forKey:@"comeInMainTotal"];
//        [kUserDefaults synchronize];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self createJiaTingQuanShowView];
//        });
//    }
}


//创建家庭圈
- (void)createJiaTingQuanShowView{
    UIView * jtqView = [UIView sc_viewWithColor:[UIColor redColor]];
    [self.view addSubview:jtqView];
    [jtqView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.equalTo(@88);
        make.bottom.equalTo(self.view).offset(-44);
    }];
    UIView * backView = [UIView sc_viewWithColor:[UIColor whiteColor]];
    [jtqView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(jtqView);
        make.left.equalTo(jtqView).offset(30);
        make.height.equalTo(@68);
        make.top.equalTo(jtqView).offset(5);
    }];
}


//http://182.138.102.131:9000/index.json
-(void)loadData{
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/TabBarJson.json"];
    NSData *reuslt_data = [NSData dataWithContentsOfFile:filePath];
    //http://182.138.102.131:9000/index.json
    //http://182.138.102.131:8080/App2/index.json
    //http://pandafile.sctv.com:42086/index.json
    
    [PVNetTool getDataWithUrl:@"http://pandafile.sctv.com:42086/index.json" success:^(id result) {
        
        NSLog(@"result = %@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (result[@"ListInfo"] && [result[@"ListInfo"] isKindOfClass:[NSArray class]]) {
                NSDictionary *json_dic = @{@"arr":result[@"ListInfo"]};
                NSData *json_data = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:nil];
                [json_data writeToFile:filePath atomically:YES];
                // NSLog(@"%@",filePath);
                NSArray* jsonArr = result[@"ListInfo"];
                for (NSDictionary* jsonDict in jsonArr) {
                    NSArray* urls = @[jsonDict[@"defaultImg2X"],jsonDict[@"defaultImg3X"],jsonDict[@"selectImg2X"],jsonDict[@"selectImg3X"]];
                    //根据params进行开辟线程请求，遍历数组params
                    [urls enumerateObjectsUsingBlock:^(NSString* url, NSUInteger index, BOOL *stop) {
                        NSString* getUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                        //执行网络请求
                        UIImageView* imageView = [[UIImageView alloc]  init];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:getUrl]];
                    }];
                }
            }
        }
        if (result[@"UsingDefault"]){
            NSString* usingDefaultString = [NSString stringWithFormat:@"%@",result[@"UsingDefault"]];
            self.isUsingDefaultImages = usingDefaultString.boolValue;
        }
        if (reuslt_data) {//不是第一次调用
            [self setupChildViewControllers:self.isUsingDefaultImages];
        }else{//第一次调用
            [self setupChildViewControllers:true];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error = %@",error);

        
        if (reuslt_data) {//不是第一次调用
            [self setupChildViewControllers:true];
        }else{//第一次调用
            [self setupChildViewControllers:true];
        }
    }];
}

#pragma mark - /***** 子控制器 *****/

/**
 * 设置所有子控制器
 */
- (void)setupChildViewControllers:(BOOL)isFirst{
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/TabBarJson.json"];
    NSData *reuslt_data = [NSData dataWithContentsOfFile:filePath];
    if (reuslt_data) {
        id json = [NSJSONSerialization JSONObjectWithData:reuslt_data options:NSJSONReadingAllowFragments error:nil];
        NSArray *result = [json objectForKey:@"arr"];
        [self.dataSource removeAllObjects];
        for (NSDictionary *dict in result) {
            PVMenuModel* menuModel = [[PVMenuModel alloc]  init];
            [menuModel setValuesForKeysWithDictionary:dict];
            if (menuModel.menuType.integerValue == 3) {
                continue;
            }
            [self.dataSource addObject:menuModel];
        }
    }
    NSString *dictString = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *jsonPath = [dictString stringByAppendingPathComponent:@"Main.json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:jsonPath];
    if (data == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Main.json" ofType:nil];
        data = [[NSData alloc] initWithContentsOfFile:path];
    }
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSMutableArray<UINavigationController*> *arrayM = [NSMutableArray array];
    if (isFirst) {//跳用系统的icon
        for (int idx = 0; idx<array.count; idx++) {
            NSDictionary* dict = array[idx];
            PVMenuModel* menuModel = nil;
            if (self.dataSource.count) {
                menuModel = self.dataSource[idx];
                menuModel.tabbarIndex = idx;
            }
            [arrayM addObject:[self controller:dict menuModel:menuModel isFirst:isFirst]];
        }
    }else{
        for (int idx = 0; idx<self.dataSource.count; idx++) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            PVMenuModel* menuModel = self.dataSource[idx];
            menuModel.tabbarIndex = idx;
            if (menuModel.menuType.intValue == 0) {
                [dict setDictionary:array.firstObject];
            }else if (menuModel.menuType.intValue == 1){
                [dict setDictionary:array[1]];
            }else if (menuModel.menuType.intValue == 2){
                [dict setDictionary:array[2]];
            }else if (menuModel.menuType.intValue == 3){
                [dict setDictionary:array.lastObject];
            }
            /*
             else if (menuModel.menuType.intValue == 2){
             [dict setDictionary:array[1]];
             }
             */
            [arrayM addObject:[self controller:dict menuModel:menuModel isFirst:isFirst]];
        }
    }
    
    if (self.dataSource.count) {
        PVHomeViewController* homeVC = arrayM.firstObject.childViewControllers.firstObject;
        homeVC.menuUrl = self.dataSource.firstObject.menuUrl;
        
        PVLIveViewController* liveVC = arrayM[1].childViewControllers.firstObject;
        liveVC.menuModel = self.dataSource[1];
        
        PVActivityViewController* activityVC = arrayM[2].childViewControllers.firstObject;
        activityVC.menuUrl = self.dataSource[2].menuUrl;
        
        PVMineViewController* mineVC = arrayM.lastObject.childViewControllers.firstObject;
        mineVC.menuUrl = self.dataSource.lastObject.menuUrl;
    }
    
    self.viewControllers = arrayM;
}

/**
 * 创建子控制器
 */
- (UINavigationController *)controller:(NSDictionary *)dictionary  menuModel:(PVMenuModel*)menuModel isFirst:(BOOL)isFirst{
    
        NSString *clsName   = dictionary[@"clsName"];
        NSString *title     = menuModel.menuName;
        NSString *imageNameNomal = menuModel.defaultImg2X;
        NSString *imageNameSelected = menuModel.selectImg2X;
//        if (ScreenWidth >= 413.0) {
//            imageNameNomal = menuModel.defaultImg3X;
//            imageNameSelected = menuModel.selectImg3X;
//        }
        // 创建控制器
        Class cls = NSClassFromString(clsName);
        UIViewController *viewController = [[cls alloc] init];
        UIImage* normalImage = [self getImage:imageNameNomal];
        normalImage = [normalImage imageByScalingAndCroppingForSize:CGSizeMake(21, 21)];
        UIImage* selectedImage = [self getImage:imageNameSelected];
        selectedImage = [selectedImage imageByScalingAndCroppingForSize:CGSizeMake(21, 21)];

        if (isFirst || !normalImage || !selectedImage) {
            title = dictionary[@"title"];
            imageNameNomal = [NSString stringWithFormat:@"home_icon_%@_normal", dictionary[@"imageName"]];
            imageNameSelected = [NSString stringWithFormat:@"home_icon_%@_selected", dictionary[@"imageName"]];
            normalImage = [UIImage imageNamed:imageNameNomal];
            selectedImage = [UIImage imageNamed:imageNameSelected];
        }
        viewController.title = title;
        viewController.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
        UIColor* selectColor = [UIColor sc_colorWithHex:0x00B6E9];
//        if (menuModel.tabbarIndex == 2) {
//             selectColor = [UIColor sc_colorWithHex:0xe97c45];
//        }
        [viewController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName : selectColor} forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName : [UIColor sc_colorWithHex:0x808080]} forState:UIControlStateNormal];
        SCNavigationController *nav = [[SCNavigationController alloc] initWithRootViewController:viewController];
    
        return nav;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
}

- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            for (UIView *view in tabBarButton.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    [tabbarbuttonArray addObject:view];
                }
            }
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.0];
    [[tabbarbuttonArray[index] layer] 
     addAnimation:pulse forKey:nil]; 
}

-(NSMutableArray<PVMenuModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UIImage*)getImage:(NSString*)url{
    if (url.length == 0) return nil;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:url]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    return  [cache imageFromDiskCacheForKey:key];
}

#pragma mark - 添加通知，创建圆点和删除圆点
- (void)addObverser {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBadge) name:@"showBadge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissBadge) name:@"dismissBadge" object:nil];
}

- (void)showBadge {
    for (UITabBarItem *item in self.tabBar.items) {
        if ([item.title isEqualToString:@"家庭圈"]) {
            NSInteger tag = [self.tabBar.items indexOfObject:item];
            [self.tabBar showBadgeOnItemIndex:tag];
        }
    }
}
- (void)dismissBadge {
    for (UITabBarItem *item in self.tabBar.items) {
        if ([item.title isEqualToString:@"家庭圈"]) {
            NSInteger tag = [self.tabBar.items indexOfObject:item];
            [self.tabBar hideBadgeOnItemIndex:tag];
        }
    }
}
@end
