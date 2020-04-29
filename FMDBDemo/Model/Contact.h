//
//  Contact.h
//  FMDBDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Contact : NSObject

@property (nonatomic, assign) int sex;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
