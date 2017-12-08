//
//  PVHistoryAndHotHeadView.m
//  PandaVideo
//
//  Created by cara on 17/7/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHistoryAndHotHeadView.h"

@interface PVHistoryAndHotHeadView()

@property(nonatomic, strong)UILabel* titleLabel;
@property(nonatomic, strong)UIButton* clearBtn;
@property(nonatomic, copy)ClearClickedBlock clearClickedBlock;

@end


@implementation PVHistoryAndHotHeadView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UILabel* titleLabel = [[UILabel alloc]  init];
    titleLabel.textColor = [UIColor sc_colorWithHex:0x010101];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"历史搜索";
    self.titleLabel = titleLabel;
    
    UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setImage:[UIImage imageNamed:@"search_btn_ashcan"] forState:UIControlStateNormal];
    [clearBtn setTitle:@"  清除" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor sc_colorWithHex:0x808080] forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clearBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn = clearBtn;
    
    
    UIView* topView = [[UIView  alloc]  init];
    topView.backgroundColor  = [UIColor sc_colorWithHex:0xd7d7d7];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(1));
    }];
    
    self.backgroundColor = [UIColor whiteColor];
}
-(void)clearBtnClicked{
    if (self.clearClickedBlock) {
        self.clearClickedBlock();
    }
}
-(void)setItem:(NSInteger)item{    
    _item = item;
    if (item) {
        self.titleLabel.text = @"热门搜索";
        self.clearBtn.hidden = true;
    }else{
        self.titleLabel.text = @"历史搜索";
        self.clearBtn.hidden = false;
    }
}
-(void)setClearClickedCallBlock:(ClearClickedBlock)clearClickedBlock{
    _clearClickedBlock = clearClickedBlock;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(15, 1, 150, self.sc_height);
    self.clearBtn.frame = CGRectMake(self.sc_width-80, 0, 65, self.sc_height);
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 2;
    [super setFrame:frame];
}


@end
