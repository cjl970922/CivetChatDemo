//
//  MessageModel.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/18.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "MessageModel.h"
#import "CommonMethods.h"
#import "Constant.h"
#import "UIImage+ShowSize.h"
@implementation MessageModel


- (CGRect)timeFrame
{
    CGRect rect = CGRectZero;
    
    if (self.showMessageTime) {
        CGSize size = [CommonMethods labelAutoCalculateRectWith:self.messageTime Font:[UIFont fontWithName:@"PingFangSC-Regular" size:10] MaxSize:CGSizeMake(MAXFLOAT, 17)];
        rect = CGRectMake((ScreenWidth - size.width)/2.0, 0, size.width+10, 17);
        
    }
    
    return rect;
}

- (CGRect)logoFrame
{
    CGRect timeRect = [self timeFrame];
    
    CGRect rect = CGRectZero;
    
    if(self.messageSenderType == MessageSenderTypeMe)
    {
        rect =  CGRectMake(ScreenWidth - 50,timeRect.size.height + 10, 40, 40);
    }
    else
    {
        rect = CGRectMake(10, timeRect.size.height + 10, 40, 40);
    }
    return rect;
}

- (CGRect)messageFrame{
    CGRect timeRect = [self timeFrame];
    CGRect rect = CGRectZero;
    CGFloat maxWith = ScreenWidth * 0.7 - 60;
     CGSize size = [CommonMethods labelAutoCalculateRectWith:self.messageText Font:[UIFont fontWithName:FONT_REGULAR size:16] MaxSize:CGSizeMake(maxWith, MAXFLOAT)];
    
    if (self.messageText == nil)
    {
        return rect;
    }
    if (self.messageSenderType == MessageSenderTypeMe)
    {
        rect = CGRectMake(ScreenWidth * 0.3, timeRect.size.height + 10, maxWith - 5, size.height > 44 ? size.height : 44);;
    }
    else
    {
        rect = CGRectMake(65 , timeRect.size.height + 10 , maxWith, size.height > 44 ? size.height : 44);
    }
    return rect;
}

- (CGRect)imageFrame
{
    CGRect timeRect = [self timeFrame];
    CGFloat timeLabelHeight = timeRect.size.height;
    CGRect rect = CGRectZero;
    
    CGSize imageSize = [self.imageSmall imageShowSize];
    
    if (self.imageSmall == nil)
    {
        return rect;
    }
    
    if (self.messageSenderType == MessageSenderTypeMe)
    {
        rect = CGRectMake(ScreenWidth - imageSize.width - 50, timeLabelHeight + 10, imageSize.width, imageSize.height);
    }
    else
    {
        rect = CGRectMake(50, timeLabelHeight + 10, imageSize.width, imageSize.height);
    }
    return rect;
}

- (CGRect)bubbleFrame
{
    CGRect rect = CGRectZero;
    switch (self.messageType)
    {
        case MessageTypeText:
            rect = [self messageFrame];
            rect.origin.x =  rect.origin.x + (self.messageSenderType == MessageSenderTypeMe? -10 : -15);
            rect.size.width =  rect.size.width + 25;
            break;
//        case MessageTypeVoice:
//            rect = [self voiceFrame];
            break;
        case MessageTypeImage:
            rect = [self imageFrame];
            
            break;
        default:
            break;
    }
    
    return rect;
}

- (CGFloat)cellHeight
{
    return [self timeFrame].size.height + [self messageFrame].size.height + [self imageFrame].size.height + 15;
}
@end
