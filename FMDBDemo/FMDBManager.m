//
//  FMDBManager.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "FMDBManager.h"
#import <FMDB/FMDB.h>

static FMDBManager *_instance = nil;

@interface FMDBManager()

@property (strong , nonatomic) FMDatabaseQueue * dbQueue;

@end

@implementation FMDBManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FMDBManager alloc]init];
        [_instance initial];
    });
    return _instance;
}

-(void)initial{
//    BOOL result = [self initDatabase];
//    NSAssert(result, @"Init Database fail");
}

//-(BOOL)initDatabase{
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *path = [docPath stringByAppendingPathComponent:@"contact.sqlite"];
//    NSLog(@"path = %@",path);
//    
//    //创建数据库
//    FMDatabase *db = [FMDatabase databaseWithPath:path];
//    
//    if ([db open]) {
//        //性别这里只能为0和1 待改
//        NSString *sql = @"CREATE TABLE IF NOT EXISTS T_contact(id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL  sex integer NOT NULL)";
//        
//        
//    }
//    else{
//        NSLog(@"fail to open database");
//    }
//}
@end
