//
//  PVGifViews.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVGifViews.h"



/**
 * 帧动画
 */
@implementation PVGifViews

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.gifImageView.frame = frame;
        [self startAnimation];
        [self addSubview:_gifImageView];
    }
    return self;
}

- (void)startAnimation{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i = 0; i < 54; i ++) {
        NSString *strImage = [NSString new];
        if (i<10) {
            strImage = [NSString stringWithFormat:@"糖心炸弹_0000%d",i];
        }else{
            strImage = [NSString stringWithFormat:@"糖心炸弹_000%d",i];
        }
        YYLog(@"strImage --- %@",strImage);
        //不直接使用imageNamed（结束后不释放)
//        NSString *path = [[NSBundle mainBundle] pathForResource:strImage ofType:@"png"];
//        UIImage *image = [UIImage imageWithContentsOfFile:path];;
//        YYLog(@"strImage --- %@",image);

        [tempArr addObject:kGetImage(strImage)];
        
    }
    
    _gifImageView.animationImages = tempArr;
    _gifImageView.animationDuration = 2.5f;
    _gifImageView.animationRepeatCount = 1;
    [_gifImageView startAnimating];
    
    [self performSelector:@selector(deleteGif:) withObject:nil afterDelay:3];
}

//释放内存
- (void)deleteGif:(id)object{
    [_gifImageView stopAnimating];
    _gifImageView.animationImages = nil;
    [self removeFromSuperview];
}

- (UIImageView *)gifImageView{
    if (_gifImageView == nil) {
        _gifImageView = [[UIImageView alloc]init];
    }
    return _gifImageView;
}
@end
