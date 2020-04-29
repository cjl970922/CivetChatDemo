//
//  ChatRecordTableViewCell.h
//  FMDBDemo
//
//  Created by Civet on 2020/4/24.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRecordTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,strong) MessageModel *messageModel;

@end

NS_ASSUME_NONNULL_END
