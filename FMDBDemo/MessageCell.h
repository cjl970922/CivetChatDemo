//
//  MessageCell.h
//  FMDBDemo
//
//  Created by Civet on 2020/4/18.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MessageModel;


@interface MessageCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(MessageModel *)model;

@property (nonatomic, strong) UIImageView *imageImageView;

@property (nonatomic,strong) MessageModel *messageModel;

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *bubbleImageView;
//@property (nonatomic, strong) UIImageView *voiceImageView;
@property (nonatomic, strong) UILabel     *messageLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIFont      *textFont;
@end

NS_ASSUME_NONNULL_END
