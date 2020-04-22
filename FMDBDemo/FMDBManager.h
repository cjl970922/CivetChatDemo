//
//  FMDBManager.h
//  FMDBDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Contact;

@interface FMDBManager : NSObject

+(instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
