//
//  MessageCell.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/18.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "MessageCell.h"

#import "MessageModel.h"
#import "Constant.h"
#import "CommonMethods.h"
#import "UIImage+ShowSize.h"

@implementation MessageCell

+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(MessageModel *)model{
    
    static NSString *identifier = @"WeChatCell";
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell ==nil)
    {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.messageModel = model;
    
    return cell;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //初始化subViews
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self creatSubViewTime];
        [self creatSubViewBubble];
        [self creatSubViewLogo];
        [self creatSubViewMessage];
    //    [self creatSubViewVoice];
   //     [self creatSubViewAnimationVoice];
        [self creatSubViewImage];
        
    }
    return self;
}


#pragma mark - 创建子视图

-(void)creatSubViewMessage
{
    _messageLabel  = [[UILabel alloc]init];
    _messageLabel.hidden = YES;
    [self.contentView addSubview:_messageLabel];
    _textFont = [UIFont fontWithName:FONT_REGULAR size:16];
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.font = _textFont;
    _messageLabel.textColor = COLOR_444444;
}


- (void)creatSubViewTime
{
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.hidden = YES;
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = [UIFont fontWithName:FONT_REGULAR size:10];
    _timeLabel.backgroundColor=COLOR_cecece;
    _timeLabel.textColor = COLOR_ffffff;
    _timeLabel.textAlignment=NSTextAlignmentCenter;
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.layer.cornerRadius = 4;
    _timeLabel.layer.borderColor = [COLOR_cecece CGColor];
    _timeLabel.layer.borderWidth = 1;
}

- (void)creatSubViewLogo
{
    _logoImageView    = [[UIImageView alloc] init];
    _logoImageView.hidden    = YES;
    [self.contentView addSubview:_logoImageView];
}

- (void)creatSubViewBubble
{
    _bubbleImageView = [[UIImageView alloc]init];
    _bubbleImageView.hidden = YES;
    [self.contentView addSubview:_bubbleImageView];
    
}

- (void)creatSubViewImage
{
    _imageImageView   = [[UIImageView alloc] init];
    _imageImageView.hidden   = YES;
    [self.contentView addSubview:_imageImageView];
}

- (void)setMessageModel:(MessageModel *)messageModel {
    
    _messageModel = messageModel;
    
    _timeLabel.hidden = !messageModel.showMessageTime;
    _timeLabel.frame = [messageModel timeFrame];
    _timeLabel.text = messageModel.messageTime;
    
    _logoImageView.hidden = NO;
    _logoImageView.frame = [messageModel logoFrame];
    
    _bubbleImageView.hidden = NO;
    _bubbleImageView.frame = [messageModel bubbleFrame];
    
    if (messageModel.messageSenderType == MessageSenderTypeMe)
    {
        _logoImageView.image = [UIImage imageNamed:@"w"];
        _bubbleImageView.image = [[UIImage imageNamed:@"me"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
    }//UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。
    else
    {
        _logoImageView.image = [UIImage imageNamed:@"m"];
        _bubbleImageView.image = [[UIImage imageNamed:@"other"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
    }
    
    switch (messageModel.messageType) {
        case MessageTypeText:
            _messageLabel.hidden = NO;
            _messageLabel.frame = [messageModel messageFrame];
            _messageLabel.text = messageModel.messageText;
            _messageLabel.textAlignment = NSTextAlignmentLeft;
            break;
        
        case MessageTypeVoice:
            NSLog(@"haimeikaifa");
            break;
        case MessageTypeImage:
            _imageImageView.hidden = NO;
            _imageImageView.frame = [messageModel imageFrame];
            _imageImageView.image = messageModel.imageSmall;
            CGSize imageSize = [messageModel.imageSmall imageShowSize];
            UIImageView *imageViewMask = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:_messageModel.messageSenderType == MessageSenderTypeMe ? @"me" :@"other"]stretchableImageWithLeftCapWidth:20 topCapHeight:40]];
            imageViewMask.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
            _imageImageView.layer.mask = imageViewMask.layer;
      
//        default:
            break;
    }
    
    
    
}

- (void)prepareForReuse {
    [super prepareForReuse];

    //text voice image
    self.frame = CGRectMake(0, 0, AppFrameWidth, 44);
    _logoImageView.hidden = YES;
    _bubbleImageView.hidden = YES;
   // _voiceImageView.hidden = YES;
    _messageLabel.hidden = YES;
    _timeLabel.hidden = YES;
    _imageImageView.hidden = YES;



}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
