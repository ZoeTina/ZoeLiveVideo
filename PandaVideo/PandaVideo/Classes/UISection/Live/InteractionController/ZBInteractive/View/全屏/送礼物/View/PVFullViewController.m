//
//  PVFullViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/12.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFullViewController.h"
#import "ChatKeyBoardMacroDefine.h"
#import "ChatKeyBoard.h"

@interface PVFullViewController ()<ChatKeyBoardDelegate>


/** 聊天键盘 */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@end

@implementation PVFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];

    
    self.view.backgroundColor = [UIColor redColor];
    [self.chatKeyBoard keyboardUpforComment];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"设置" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 0, 200, 40);
    [self.view addSubview:button];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeybord)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeybord
{
    
    YYLog(@"手势");
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = CrossScreenWidth;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
    
    [self.chatKeyBoard keyboardDownForComment];}


-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.backgroundColor = [UIColor whiteColor];
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowFace = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"快来和小伙伴一起畅聊吧~";
        [self.view addSubview:_chatKeyBoard];
    }
    return _chatKeyBoard;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    YYLog(@"touchesBegan");

    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = CrossScreenWidth;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
//
    [self.chatKeyBoard keyboardDownForComment];
//    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    app.shouldChangeOrientation = NO;
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
