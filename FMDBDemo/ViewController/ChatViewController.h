//
//  ChatViewController.h
//  FMDBDemo
//
//  Created by Civet on 2020/4/18.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger talkerID;
@end

NS_ASSUME_NONNULL_END
