//
//  Utils.h
//  SEZB
//
//  Created by 寕小陌 on 2016/12/15.
//  Copyright © 2016年 寜小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

/***************************************************************************
 *
 * 工具类
 *
 ***************************************************************************/
@interface Utils : NSObject

/**
 *  加载tabelViewCell
 *
 *  @param tableViewCell tableViewCell
 *  @param index         第几个视图
 */
+ (UITableViewCell *) loadCellNib:(UITableViewCell *) tableViewCell objectAtIndex:(NSUInteger)index;

/**
 *  设置UILabel北背景透明
 *
 *  @param label 当前label
 *
 *  @return 设置后的label
 */
+ (UILabel *) setLabelTransparent:(UILabel *) label;

#pragma mark - 读取plist的文件数据
//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSArray *) loadLocalResources :(NSString *) fileName;

#pragma mark --- 清除tableView多余分割线
//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (UITableView *)setExtraCellLineHidden: (UITableView *)tableView;

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *
 *  @return 生成的图片
 */
+ (UIImage *) imageWithColor:(UIColor *)color;

/**
 *  设置公共按钮背景图
 *
 *  @param button 需要设置的按钮
 *
 *  @return 返回已经设置好的内容
 */
+ (UIButton *) setButtonWithBGImage :(UIButton *) button;


/**
 *  11. 将十六进制颜色转换为 UIColor 对象
 *
 *  @param color 颜色值
 *
 *  @return 将十六进制颜色转换为 UIColor 对象
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  设置公共按钮背景图
 *
 *  @param text 文字内容
 *  @param font 文字字体
 *  @param maxW 最大宽度
 *
 *  @return 返回已经设置好的内容
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  时间戳转换为时间
 *
 *  @param timeString 时间戳
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
/**
 *  获取当前系统时间
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)getCurrentTime;

/**
 *  获取当前系统日期
 *
 *  @return 返回字符串格式时间
 */
+ (NSString*)getCurrentDate;

/**
 *  获取当前时间的时间戳
 *
 *  @return 返回字符串格式时间
 */
+ (NSString*)getCurrentTimestamp;

/**
 *  据图片名将图片保存到ImageFile文件夹中
 *
 *  @param imageName 图片名称
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)imageSavedPath :(NSString *) imageName;

/**
 *  解析编码格式
 *
 *  @param responseObject 解析的数据
 *
 *  @return 返回字符串格式
 */
+ (NSString *) dataWithJSONObject:(NSDictionary *) responseObject;

/**
 *  将数字转换为 时、分、秒、
 *
 *  @param totalSecond 时间转换
 *
 *  @return 返回字符串格式
 */
+ (NSString *)timeFormatted:(int) totalSecond;

/**
 *  设置searchBar的背景色使用的
 *
 *  @param size searchBar 的size
 *
 *  @return 返回设置好的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  银行卡字符串格式化
 *  参数 str 银行卡号
 */
+ (NSString *)backCardOrFormatString:(NSString *) string;

/**
 *  银行卡字符串格式化星号显示
 *  参数 bankCard 银行卡号
 */
+ (NSString*) bankCardToAsterisk:(NSString *) bankCard;

/** 随机数生成 */
+ (int) getRandomNumber:(int)from to:(int)to;
/** 以逗号隔开 */
+ (NSString *)seperateNumberByComma:(NSInteger)number;
/**
 *  两个时间差
 *
 *  @param startTime 开始时间
 *  @param endTime 结束时间
 *  @return 时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */
+ (BOOL)judgeTimeByStartTime:(NSString *)startTime endTime:(NSString *)expireTime;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
