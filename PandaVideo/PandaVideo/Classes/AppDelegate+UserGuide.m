//
//  AppDelegate+UserGuide.m
//  PandaVideo
//
//  Created by songxf on 2017/11/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "AppDelegate+UserGuide.h"

@implementation AppDelegate (UserGuide)


#pragma mark -- 创建主页新手指导页

- (void)createUserGuide:(NSInteger)index  withFrame:(CGRect)frame{
    //GCD延迟动画模拟网络
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //创建阴影
        UIView *shadowView = [[UIView alloc] initWithFrame:YYScreenBounds];
        shadowView.tag = 5555 + index;
        shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.shadowView = shadowView;
        if (index == 1) {
            for(UIView*window in [UIApplication sharedApplication].windows){
                if([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
                {
                    [window addSubview:shadowView];
                }
            }
        }else{
                [[[UIApplication sharedApplication] keyWindow] addSubview:self.shadowView];
            }
       
            
            [self createUserView:index withFrame:frame];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [ self.shadowView addGestureRecognizer:singleTap];
       
    });
}

- (void)createUserView:(NSInteger)index withFrame:(CGRect)frame{
    switch (index) {
        case 0:
        {
            UIImageView * quanView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_img_3"]];
            quanView.backgroundColor = [UIColor clearColor];
            quanView.frame = CGRectMake(2 + frame.size.width/2 - 27.5, ScreenHeight -  kTabBarHeight + frame.size.height/2 - 27.5 , 55, 55);
            [self.shadowView addSubview:quanView];
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(2 + frame.size.width/2, ScreenHeight -  kTabBarHeight + frame.size.height/2) radius:19 startAngle:0 endAngle:2*M_PI clockwise:NO]];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = path.CGPath;
            [self.shadowView.layer setMask:shapeLayer];
            
            UIImageView * imagArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_arrow_1"]];
            imagArrow.backgroundColor = [UIColor clearColor];
            [self.shadowView addSubview:imagArrow];
            UIImageView * imagInfo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_text_1"]];
            imagArrow.backgroundColor = [UIColor clearColor];
            [self.shadowView addSubview:imagInfo];
            [imagArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(quanView).offset(10);
                make.width.equalTo(@38);
                make.height.equalTo(@65.5);
                make.bottom.mas_equalTo(quanView.mas_top).offset(-5);
            }];
            
            [imagInfo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.shadowView);
                make.width.equalTo(@220);
                make.height.equalTo(@60);
                make.bottom.equalTo(imagArrow.mas_top).offset(-33);
            }];
            
        }
            break;
        case 1:
        {
            CGRect tempFrame = frame;
            tempFrame.origin.y = frame.origin.y + kNavBarHeight - 44;
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:tempFrame cornerRadius:frame.size.height/2] bezierPathByReversingPath]];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = path.CGPath;
            [self.shadowView.layer setMask:shapeLayer];
            float orginY =  ScreenHeight -IPHONE6WH(40 + 3) - (kiPhoneX ? 78 : 0);
            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(ScreenWidth -IPHONE6WH(85 + 5),orginY, IPHONE6WH(85) , IPHONE6WH(39)) cornerRadius:5] bezierPathByReversingPath]];
            CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
            shapeLayer2.path = path.CGPath;
            [self.shadowView.layer setMask:shapeLayer2];
            
            UIImageView * imagArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_arrow_2"]];
            imagArrow.backgroundColor = [UIColor clearColor];
            [self.shadowView addSubview:imagArrow];
            UIImageView * imagArrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_arrow_3"]];
            imagArrow2.backgroundColor = [UIColor clearColor];
            [self.shadowView addSubview:imagArrow2];
            UIImageView * imagInfo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_text_2"]];
            imagArrow.backgroundColor = [UIColor clearColor];
            [self.shadowView addSubview:imagInfo];
            [imagArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.shadowView);
                make.width.equalTo(@26.5);
                make.height.equalTo(@130);
                make.top.equalTo(self.shadowView).offset(86);
            }];
            
            [imagArrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.shadowView).offset(-IPHONE6WH(55));
                make.width.equalTo(@52);
                make.height.equalTo(@96);
                make.bottom.equalTo(self.shadowView.mas_top).offset(orginY - 30);
            }];
            
            [imagInfo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.shadowView);
                make.width.equalTo(@300);
                make.height.equalTo(@60);
                make.top.equalTo(imagArrow.mas_bottom).offset(50);
            }];
        }
            break;
        case 2:
        {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_img_guide3"]];
            imageView.frame = self.shadowView.bounds;
            imageView.userInteractionEnabled = YES;
            imageView.backgroundColor = [UIColor clearColor];
            [self.shadowView addSubview:imageView];
        }
            break;
        case 3:
        {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_img_guide4"]];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled = YES;
            imageView.frame = self.shadowView.bounds;
            [self.shadowView addSubview:imageView];
        }
            break;
            
        default:
            break;
    }
}

/** 点击移除 */
- (void) handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
     NSInteger tag = self.shadowView.tag - 5555;
    [ self.shadowView removeFromSuperview];
     self.shadowView = nil;
     [gestureRecognizer.view removeGestureRecognizer:gestureRecognizer];
    if (self.userGuideBlock) {
        self.userGuideBlock(tag);
    }
}
@end
