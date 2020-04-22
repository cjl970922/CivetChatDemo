//
//  CommonMethods.h
//  FMDBDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CommonMethods : NSObject
+ (NSString *)generateTradeNO;

+ (NSString *)firstCharactorWithString:(NSString *)string;

+ (CGSize)labelAutoCalculateRectWith:(NSString *)text Font:(UIFont *)textFont MaxSize:(CGSize)maxSize;

//+ (CGSize)imageShowSize;

@end

NS_ASSUME_NONNULL_END
