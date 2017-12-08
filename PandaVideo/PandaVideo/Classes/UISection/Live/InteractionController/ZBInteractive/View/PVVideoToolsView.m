//
//  PVVideoToolsView.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoToolsView.h"

@interface PVVideoToolsView ()

@property (nonatomic, strong) IBOutlet UIButton *btnPlay;
@property (nonatomic, strong) IBOutlet UIView *switchView;

@end

@implementation PVVideoToolsView

- (void) awakeFromNib{
    [super awakeFromNib];
    
    YYLog(@"1");
}


/** 横屏底部工具栏 */
+ (PVVideoToolsView *)bottomViewHorizontallyScreen{
    return [[[NSBundle mainBundle] loadNibNamed:@"PVVideoToolsView" owner:nil options:nil] objectAtIndex:0];
}

/** 横屏顶部工具栏 */
+ (PVVideoToolsView *)topViewHorizontallyScreen{
    return [[[NSBundle mainBundle] loadNibNamed:@"PVVideoToolsView" owner:nil options:nil] objectAtIndex:1];
}


/** 竖屏底部工具栏 */
+ (PVVideoToolsView *)bottomViewVerticalScreen{
    return [[[NSBundle mainBundle] loadNibNamed:@"PVVideoToolsView" owner:nil options:nil] objectAtIndex:2];
}

/** 竖屏顶部工具栏 */
+ (PVVideoToolsView *)topViewVerticalScreen{
    return [[[NSBundle mainBundle] loadNibNamed:@"PVVideoToolsView" owner:nil options:nil] objectAtIndex:3];
}

+ (PVVideoToolsView *)loadLiveXibView:(NSInteger)index{
    return [[[NSBundle mainBundle] loadNibNamed:@"PVVideoToolsView" owner:nil options:nil] objectAtIndex:index];
}


- (IBAction) didShowLiveBottomToolsButtonClick:(UIButton *) sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didShowLiveBottomToolsButtonClick:)]){
        [self.delegate didShowLiveBottomToolsButtonClick:sender];
    }
}

- (void)bottomClick:(id)sender{
    UIButton *tagButton = (UIButton *)sender;
    if (self.buttonClick) {
        self.buttonClick(tagButton.tag);
    }
}

@end
