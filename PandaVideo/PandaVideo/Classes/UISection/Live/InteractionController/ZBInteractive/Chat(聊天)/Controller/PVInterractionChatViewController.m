//
//  PVInterractionChatViewController.m
//  PandaVideo
//
//  Created by 寕小陌 on 2017/8/15.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "PVInterractionChatViewController.h"
#import "DialogueModel.h"
#import "UIButton+UserInfo.h"
#import "Dialog.h"
#import "YYExtensions.h"
#import "PVMessageCell.h"
#import "PVLiveRoomModel.h"
#import "PVMessageModel.h"

@interface PVInterractionChatViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,TYAttributedLabelDelegate>

//@property(nonatomic, strong) UITableView    *tableView;         // 显示聊天列表
@property (nonatomic, assign) NSInteger      width;
@property (nonatomic, assign) NSInteger      height;
@property (nonatomic, copy)   NSString       *antename;          // 点击的昵称
@property (nonatomic, copy)   NSString       *anteid;

@property (nonatomic, strong) PVLiveRoomModel *liveRoomModel;
@property (nonatomic, strong) PVMessageModel *messageModel;
@property (nonatomic, strong) PVMessageData *messageData;
@property (nonatomic, strong) PVChatList *chatList;


/** 定时器用于模拟聊天 */
@property (nonatomic, strong) NSTimer       *timer;
/** im数据源 */
@property (nonatomic, strong) NSMutableArray *imTableDataSoure;
@property (nonatomic, strong) NSArray        *dataList;
@property (nonatomic, strong) NSArray        *nicknameList;

/** 直播ID */
@property (nonatomic, copy)   NSString       *liveId;
/** token */
@property (nonatomic, copy)   NSString       *token;
/** 用户ID */
@property (nonatomic, copy)   NSString       *userId;
/** 第一次进入的标识 */
@property (nonatomic, assign) BOOL           isFirstTo;
/** 最新的消息ID*/
@property (nonatomic, copy)     NSString    *messageID;
/** 游客身份 */
@property (nonatomic, copy)     NSString    *touristsIdentity;
/** 是否登录 */
@property (nonatomic, assign)   BOOL        isLogin;
/** 是否进入房间成功 */
@property (nonatomic, assign)   BOOL        isRoom;
/** 是否为自己发送的消息 */
@property (nonatomic, assign)   BOOL        isSelfMessage;
@end


@class PVLiveRoomData;
@implementation PVInterractionChatViewController

- (id)initDictionary:(NSDictionary *)dictionary{
    
    if ( self = [super init] ){
        _liveId  = dictionary[@"liveId"];
    }
    return self;
}


- (NSArray*)dataList
{
    if (!_dataList) {
        _dataList = [NSArray arrayWithObjects:@"美女",@"你眼睛好大啊 ~",@"能动手就别吵吵",@"你的腿好白好长😋",@"😆别逗乐~",@"哪有啦,人家只是美美哒~",@"你个人妖王",@"我是要成为主播男人的男人~😂",@"看到你我的心就凌乱了~",@"主播你是🐒请来的逗比吗~",@"哈哈哈哈哈哈 ~ ",@"都别当我看球~",@"主播,这么美~~~",@"你把所有誓言所有诺言,藏在手中化成一把火,燃烧我的真心我的真意,将我变成一只飞蛾,在寂寞萦绕的夜空中,飞过爱曾停留的角落,最后折断翅膀跌落在深渊,竟无处去闪躲,你把所有誓言,所有诺言藏在手中化成一把火", nil];
    }
    return _dataList;
}

- (NSArray*)nicknameList
{
    if (!_nicknameList) {
        _nicknameList = [NSArray arrayWithObjects:@"高渐离",@"安其拉",@"王昭君",@"兰陵王",@"吕布",@"盖伦",@"艾希",@"卡兹克",@"皮城女警",@"赏金猎人",@"后羿",@"亚索",@"曹操", nil];
    }
    return _nicknameList;
}

- (NSMutableArray*)imTableDataSoure
{
    if (!_imTableDataSoure) {
        _imTableDataSoure = [[NSMutableArray alloc] init];
    }
    return _imTableDataSoure;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirstTo = YES;
    self.isSelfMessage = NO;
    if ([kUserInfo.userId length] > 0) {
        _token      = kUserInfo.token;
        _userId     = kUserInfo.userId;
        _isLogin    = YES;
    }else{
        
        _isLogin    = NO;
        _touristsIdentity = [NSString stringWithFormat:@"游客%d",[Utils getRandomNumber:0 to:100000000]];

//        _token      = @"lzTest";
//        _userId     = @"lzTest";
    }
    self.isRoom = NO;
    self.view.backgroundColor = kColorWithRGB(242, 242, 242);
    [self initView];
    
    [self showLocalMessage:@"来了" chatType:@"1"];

    [self requestJoinLiveRoomData];
    //写个定时器去刷新聊天界面,毕竟demo
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 block:^(NSTimer * _Nonnull timer) {

        if (self.isRoom) {  // 进入直播间成功
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:self.messageID forKey:@"lastMsgId"];
            [dictionary setValue:self.liveId forKey:@"liveId"];
            
            [self requestChatListData:dictionary];
        }else{
            // 进入直播间失败从新进入
            [self requestJoinLiveRoomData];
        }
    } repeats:YES];
}

/** 获取进入直播间的数据 */
- (void) requestJoinLiveRoomData{
    
    // 进入直播间接口
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_liveId forKey:@"liveId"];
    if (kUserInfo.isLogin) {
        [dict setObject:kUserInfo.token forKey:@"token"];
        [dict setObject:kUserInfo.userId forKey:@"userId"];
    }else{
        [dict setObject:@"1" forKey:@"token"];
        [dict setObject:@"1" forKey:@"userId"];
    }
    YYLog(@"进入直播间接口参数 - %@",dict);
    [PVNetTool postDataWithParams:dict url:@"joinLiveRoom" success:^(id responseObject) {
        
        if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary* jsonDict = responseObject[@"data"];
            if (!jsonDict.allKeys.count) return ;
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                
                self.isRoom = YES;
                PVLiveRoomModel *liveRoomModel = [[PVLiveRoomModel alloc] init];
                [liveRoomModel setValuesForKeysWithDictionary:responseObject];
                self.liveRoomModel = liveRoomModel;
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                [dictionary setValue:liveRoomModel.liveRoomData.lastMsgId forKey:@"lastMsgId"];
                [dictionary setValue:_liveId forKey:@"liveId"];
                self.messageID = liveRoomModel.liveRoomData.lastMsgId;
                YYLog(@"进入直播间:dictionary -- %@",liveRoomModel.liveRoomData.lastMsgId);
                [self requestChatListData:dictionary];
            }
            // 获取聊天信息
        }else{
            YYLog(@"直播间数据没有-");
        }
    } failure:^(NSError *error) {
        YYLog(@"error -- %@",error);
        
    }];
}

/** 获取聊天列表数据 */
- (void) requestChatListData:(NSDictionary *)params{
    
    YYLog(@"params --- %@",params);
    [PVNetTool postDataWithParams:params url:@"getChatList" success:^(id responseObject) {

        NSDictionary *dictionary  = responseObject;
        NSDictionary *result = [dictionary[@"data"] mutableCopy];
        NSMutableArray * dianzanArray = [NSMutableArray array];
        YYLog(@"从接口中获取到的原始聊天数据-result -- %@",result);
        if (!result.allKeys.count) return ;
        if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
            
            //在线人数
            NSInteger renshuTotal = [result[@"userCount"] integerValue];
            if (renshuTotal > 0 && self.zaiXianRenshuBlock) {
                self.zaiXianRenshuBlock(renshuTotal);
            }
            NSMutableArray *mbArr = [result[@"chatList"] mutableCopy];
            if ([mbArr isKindOfClass:[NSArray class]]) {
                NSArray* jsonArr = result[@"chatList"];
                for (NSDictionary *dictionary in jsonArr) {
                    PVChatList *chatList = [[PVChatList alloc] init];
                    [chatList setValuesForKeysWithDictionary:dictionary];
                    self.chatList = chatList;
                   
                    if (![self.chatList.userData.userId isEqualToString:kUserInfo.userId]) {
                        if (self.chatList.chatType.integerValue == 3) {
                            [self onPublicChatMessage:chatList];
                            continue;
                        }
                          NSLog(@"dialogue.chatType === %@",self.chatList.chatType);
                        // 上次消息ID和本次消息ID不相等的情况下才显示或者是第一次进入直播间
                        if ((![self.messageID isEqualToString:self.chatList.chatId] || self.isFirstTo) && (self.chatList.chatType.integerValue != 3)) {
                            
                            self.isFirstTo = NO;
                            self.messageID = self.chatList.chatId;
                            if ([self.chatList.chatType integerValue] == 5) { //点赞
                                [dianzanArray addObject:chatList];
                                continue;
                            }
                            [self.imTableDataSoure insertObject:chatList atIndex:0];
//                                [self.imTableDataSoure addObject: chatList];
//                                NSArray *reversedArray = [[self.imTableDataSoure reverseObjectEnumerator] allObjects];
//                                [self.imTableDataSoure removeAllObjects];
//                                [self.imTableDataSoure addObjectsFromArray:reversedArray];
                                [self onPublicChatMessage:chatList];
                                [self.tableView reloadData];
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:true];
                            
                          
                        }
                    }
                }
                // 取出在线人数
//                YYLog(@"当前在线人数 -- %@",result[@"userCount"]);
            }else{
//                YYLog(@"成功，但没数据");
            }
        }else{
//            YYLog(@"没有聊天数据-");
        }
        
        if (self.dianzanBlock && (dianzanArray.count > 0)) {
            NSInteger total = 0;
            for (PVChatList *chatList in dianzanArray) {
                total = total + chatList.count.integerValue;
            }
            self.dianzanBlock(total);
        }
    } failure:^(NSError *error) {
        YYLog(@"error -- %@",error);
    }];
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

- (void)initView{

    //注册Cell
    [self.tableView registerClass:[PVMessageCell class] forCellReuseIdentifier:@"PVMessageCell"];

    _width = self.view.bounds.size.width;
    _height = self.view.bounds.size.height;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //倒过来 ~
    self.tableView.transform = CGAffineTransformMakeScale(1, -1);
    
    /// 发出去的消息
    [kNotificationCenter addObserver:self selector:@selector(receptionMessage:) name:@"receptionMessage" object:nil];
    // 送礼物需要显示的内容
    [kNotificationCenter addObserver:self selector:@selector(receptionGiftMessage:) name:@"receptionGiftMessage" object:nil];

//---------------------------------------------------------------------------------------------------------------------------------------------

}

- (void) receptionGiftMessage:(NSNotification *)notification{
    self.isFirstTo = NO;
    NSString *giftName = notification.userInfo[@"giftName"];
    [self showLocalMessage:giftName chatType:@"2"];
}
/*** 发出去的消息 */
- (void) receptionMessage:(NSNotification *)notification{
    
    if (kUserInfo.isLogin) {
        self.isFirstTo = NO;
        YYLog(@"----------%@",notification.object);
        // 发出去的消息内容
        NSString *chatMessage = notification.userInfo[@"message"];
        [self showLocalMessage:chatMessage chatType:@"0"];
        //------------------------------发送到服务器数据------------------------------
        /*
         liveId         直播ID
         msg            消息
         targetUserId   回复消息目标用户ID
         token          令牌
         userId         用户ID
         */
        NSDictionary *dictionary = @{@"liveId":_liveId,
                                     @"msg":chatMessage,
                                     @"targetNickName":@"",
                                     @"targetUserId":@"",
                                     @"token":kUserInfo.token,
                                     @"userId":kUserInfo.userId};
        [self chatSendMessage:dictionary];
    }else{
        // 未登录
    }
}

// 进入房间和自己发消息本地显示
- (void) showLocalMessage:(NSString *)chatMessage chatType:(NSString *)chatType{
    
    
    NSString *nickName = self.touristsIdentity;
    if (self.isLogin) {
        nickName = kUserInfo.baseInfo.nickName;
    }
    
    
    /**
     *    chatDate   消息时间
     *    chatId     消息ID
     *    chatMsg    消息内容（类型为点赞时显示点赞数，类型为礼物时为礼物ID）
     *    chatType   消息类型(0.聊天、1.用户进入、2.送礼、3.红包&活动、4.公告，5.点赞)
     *    count      数量（礼物数量，点赞数量）
     *    userData   object
     *        avatar     头像
     *        nickName   用户名
     *        userId     ID
     */
    //------------------------------显示自己发送的数据------------------------------
    NSString *namestr = @"";
    if (kUserInfo.isLogin) {
        namestr = kUserInfo.userId;
    }
    NSDictionary *message = @{@"chatDate":@"时间",
                              @"chatId":@"消息ID",
                              @"chatMsg":chatMessage,
                              @"chatType":chatType,
                              @"count":@"",
                              @"userData":@{
                                      @"avatar":@"头像",
                                      @"nickName":nickName,
                                      @"userId":namestr
                                      }
                              };
    YYLog(@"text -- %@",message);
    self.isSelfMessage = YES;
    PVChatList *chatList = [[PVChatList alloc] init];
    [chatList setValuesForKeysWithDictionary:message];
    self.chatList = chatList;
    [self.imTableDataSoure insertObject:chatList atIndex:0];
    [self.tableView insertRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark tableview delegate
// 显示分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 点击Cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.imTableDataSoure.count;
}

#pragma KeyBoardInputViewDelegate2


/**
 *  发送出去的消息(没使用)
 *
 *  @param message 消息内容
 *  @param danmu 是否为弹幕（YES：弹幕 NO：普通消息）
 */
- (void)keyBoardSendMessage:(NSString*)message isDanmu:(BOOL)danmu{
    if (message.length == 0) {
        return;
    }
    Toast(message);
    if (danmu) {
        // 发送弹幕消息
//        if (self.danmuView) {
//            DanmuItem *item = [[DanmuItem alloc] init];
//            item.u_userID = @"three id";
//            item.u_nickName = self.nickName;
//            item.thumUrl = self.userIcon;
//            item.content = message;
//            [self.danmuView setModel:item];
//            if (self.guestKit) {
//                [self.guestKit SendBarrage:self.nickName andCustomHeader:self.userIcon andContent:message];
//            }
//        }
    }else{
        // 发送普通消息
//        MessageModel *model = [[MessageModel alloc] init];
//        [model setModel:@"guestID" withName:self.nickName withIcon:self.userIcon withType:CellNewChatMessageType withMessage:message];
//        [self.messageTableView sendMessage:model];
//        
//        if (self.guestKit) {
//            [self.guestKit SendUserMsg:self.nickName andCustomHeader:self.userIcon andContent:message];
//        }
        
    }
}

// 直播显示聊天对话
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"PVMessageCell";
    PVMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PVChatList *dialogue = self.imTableDataSoure[indexPath.row];

    //  用户进入直播间
    //  消息类型(0.聊天、1.用户进入、2.送礼、3.红包&活动、4.公告，5.点赞)
    NSString * chatMsg = @"";
    BOOL isShowMaohao = NO;
    UIColor * infoColor = [UIColor blackColor];
    switch (dialogue.chatType.integerValue) {
        case 0:
            
            if (![dialogue.chatMsg isEqualToString:@"useravatar"]){
               chatMsg = dialogue.chatMsg;
            }else{
                chatMsg = [self verticalScreenGiftIDConversionsGiftName:dialogue];
            }
            isShowMaohao = YES;
            break;
        case 1:
            
            if (kStringIsEmpty(dialogue.userData.nickName)) {
                dialogue.userData.nickName = _touristsIdentity;
            }
            infoColor = [UIColor sc_colorWithHex:0x27beef];
            chatMsg = @"进入直播间";
            break;
        case 2:
            /** 竖屏收到礼物根据ID转换礼物名称 */
            infoColor = [UIColor sc_colorWithHex:0xff8c46];
            chatMsg = dialogue.chatMsg;
            if (dialogue.count.integerValue > 0) {
                 chatMsg = [self verticalScreenGiftIDConversionsGiftName:dialogue];
            }
           
        break;
        case 5:
            cell.hidden = YES;
            return cell;
            break;
        default:
            break;
    }
    if ((dialogue.userData.nickName.length < 1) || (chatMsg.length < 1)) {
        return cell;
    }
    cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    [cell.nicknameBtn addTarget:self action:@selector(antesomeone:) forControlEvents:UIControlEventTouchUpInside];
    cell.textLabel.font = font(12);
    NSString *content =  isShowMaohao ? [NSString stringWithFormat:@"%@：%@",dialogue.userData.nickName,chatMsg] : [NSString stringWithFormat:@"%@%@",dialogue.userData.nickName,chatMsg];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    // 昵称文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor sc_colorWithHex:0x808080]
                    range:NSMakeRange(0, [dialogue.userData.nickName length])];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:infoColor
                    range:isShowMaohao ? NSMakeRange([dialogue.userData.nickName length] + 1, content.length - dialogue.userData.nickName.length - 1): NSMakeRange([dialogue.userData.nickName length], content.length - dialogue.userData.nickName.length)];
    
    cell.textLabel.attributedText = attrStr;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    //
    // 计算用户名宽高
    dialogue.userNameSize = [self getTitleSizeByFont:dialogue.userData.nickName width:self.tableView.sc_width font:[UIFont systemFontOfSize:13]];
    // 计算消息内容宽高
    dialogue.msgSize = [self getTitleSizeByFont:[chatMsg stringByAppendingString:dialogue.userData.nickName]
                                          width:self.tableView.sc_width
                                           font:font(12)];
    
    // 只有是自己发送的消息才有下划线。进入没有下划线||![dialogue.chatMsg isEqualToString:@"进入直播间"]
    if ([dialogue.userData.userId isEqualToString: [PVUserModel shared].userId] && (dialogue.chatType.integerValue == 0)) {
        
        NSRange range = (NSRange){dialogue.userData.nickName.length + 1,content.length - dialogue.userData.nickName.length - 1};
        [attrStr addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:range];
        [attrStr addAttribute:NSUnderlineColorAttributeName value:infoColor range:range];
        
         cell.textLabel.attributedText = attrStr;
    }
    
    
    
        //    YYLog(@"昵称宽 -- %f",dialogue.userNameSize.width);
        //    YYLog(@"昵称高 -- %f",dialogue.userNameSize.height);
        
//        cell.dialogue = dialogue;
//        // 必须放在赋值后面
//        cell.nicknameBtn.transform = CGAffineTransformMakeScale (1,-1);
//        cell.messageLabel.transform = CGAffineTransformMakeScale (1,-1);
    return cell;
}

/** 竖屏收到礼物根据ID转换礼物名称 */
- (NSString *)verticalScreenGiftIDConversionsGiftName:(PVChatList *)dialogue{
    
    NSString *giftName = @"";
    switch (dialogue.chatMsg.integerValue) {
            /********（一）普通档礼物：表达喜欢情绪  静态呈现********/
        case 1001:
            giftName = [self joiningTogetherStr:dialogue giftName:@"爱你哟"];
            break;
        case 1002:
            giftName = [self joiningTogetherStr:dialogue giftName:@"吉他"];
            break;
        case 1003:
            giftName = [self joiningTogetherStr:dialogue giftName:@"金话筒"];
            break;
        case 1004:
            giftName = [self joiningTogetherStr:dialogue giftName:@"迷你乐队"];
            break;
            /********（二）中档礼物：表达吐槽情绪 gif呈现********/
        case 2001:
            giftName = [self joiningTogetherStr:dialogue giftName:@"糖心炸弹"];
            break;
        case 2002:
            giftName = [self joiningTogetherStr:dialogue giftName:@"香气粑粑"];
            break;
        case 2003:
            giftName = [self joiningTogetherStr:dialogue giftName:@"心好累"];
            break;
            /********（三）高档礼物：土豪专区  全屏动效呈现********/
        case 3001:
            giftName = [self joiningTogetherStr:dialogue giftName:@"兰博基尼"];
            break;
        case 3002:
            giftName = [self joiningTogetherStr:dialogue giftName:@"豪华游艇"];
            break;
        default:
            break;
    }
    return giftName;
}

- (NSString *) joiningTogetherStr:(PVChatList *)dialogue giftName:(NSString *)giftName{
    return [NSString stringWithFormat:@"送了%ld个%@",(long)dialogue.count.integerValue,giftName];
}

// 每个cell  高度多少
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PVChatList *dialogue = [self.imTableDataSoure objectAtIndex:indexPath.row];
    if (dialogue.chatType.integerValue == 5) {
        return 0;
    }
    return dialogue.msgSize.height + 10;
}


/**
 *	@brief  收到(发送)消息、礼物
 */
- (void)onPublicChatMessage:(PVChatList *)dialog
{
//    if (dialog == nil || [dialog count] == 0) return ;
    // 消息类型(0.聊天、1.用户进入、2.送礼、3.红包&活动、4.公告，5.点赞)
    YYLog(@"收到的消息--- %@-----内容-%@",dialog.chatType,dialog.chatMsg);
    
    NSDictionary *dict = @{@"dialog":dialog};
    [kNotificationCenter postNotificationName:@"initiateBarrage" object:nil userInfo:dict];

}

// 计算字符串的size
-(CGSize)getTitleSizeByFont:(NSString *)str width:(CGFloat)width font:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}




/**
 点击昵称的事件

 @param sender 昵称对应的按钮
 */
-(void)antesomeone:(UIButton *)sender {
    NSString *str = [sender titleForState:UIControlStateNormal];
    
    NSRange range = [str rangeOfString:@": "];
    if(range.location == NSNotFound) {
        _antename = str;
    } else {
        _antename = [str substringToIndex:range.location];
    }
    
    YYLog(@"str = %@,range = %@,_antename = %@",str,NSStringFromRange(range),_antename);
    
    _anteid = sender.userid;
}

kRemoveCellSeparator

- (void)dealloc{
    [self removeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK: - 取消定时器
- (void)removeTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) viewDidDisappear:(BOOL)animated{
    [self removeTimer];
}



/**
 发送消息接口

 @param params 发送内容
 */
- (void) chatSendMessage:(NSDictionary *)params{
    
    [PVNetTool postDataWithParams:params url:@"sendChatMessage" success:^(id responseObject) {
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dictionary  = responseObject;            // 用户未登录
            if ([[dictionary objectForKey:@"rs"] integerValue] == 401) {
                YYLog(@"未登录 -- result -- %@",[dictionary objectForKey:@"errorMsg"]);
                // 做未登录操作
            }else if([[dictionary objectForKey:@"rs"] integerValue] == 200){
                YYLog(@"消息成功 -- result");
            }else{
                YYLog(@"未知消息 -- result -- %@",[dictionary objectForKey:@"errorMsg"]);
            }
        }else{
            YYLog(@"没有聊天数据-");
        }
    } failure:^(NSError *error) {
        YYLog(@"error -- %@",error);
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
