//
//  CommonMethods.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods


+ (NSString *)generateTradeNO
{
    static int kNumber = 3;
    
    NSString *sourceStr =   @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber;   i++)
    {
        unsigned index = rand() %   [sourceStr length];
        NSString *oneStr = [sourceStr   substringWithRange:NSMakeRange(index, 1)];
        [resultStr   appendString:oneStr];
    }
    return resultStr;
}

+ (NSString *)firstCharactorWithString:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
    
}

+ (CGSize)labelAutoCalculateRectWith:(NSString *)text Font:(UIFont *)textFont MaxSize:(CGSize)maxSize
{
    NSDictionary *attributes = @{NSFontAttributeName:textFont};
    CGRect rect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size;
}

+ (NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    
    NSDate *date = [NSDate date];
    NSString *datestr = [formatter stringFromDate:date];
    NSLog(@"当前时间是：%@",datestr);
    return datestr;
}


@end
