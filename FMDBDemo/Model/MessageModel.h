//
//  MessageModel.h
//  FMDBDemo
//
//  Created by Civet on 2020/4/18.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
//，需要值同时存在的时候就要用NS_OPTIONS， 不需要时用NS_ENUM就能满足需求了。

// 消息类型
typedef NS_OPTIONS(NSUInteger,MessageType){
    MessageTypeText = 1,
    MessageTypeVoice,
    MessageTypeImage
};

// 消息发送方
typedef NS_OPTIONS(NSUInteger, MessageSenderType) {
    MessageSenderTypeMe=1,
    MessageSenderTypeOther
};



@interface MessageModel : NSObject

@property (nonatomic,assign) MessageType messageType;
@property (nonatomic, assign) MessageSenderType messageSenderType;

//是否显示小时的时间
@property (nonatomic,assign) BOOL   showMessageTime;
//消息时间  2017-09-11 11:11
@property (nonatomic,retain) NSString    *messageTime;
//图像url
@property (nonatomic,retain) NSString    *logoUrl;
//消息文本内容
@property (nonatomic,retain) NSString    *messageText;
//图片文件
@property (nonatomic, retain) NSString    *imageUrl;
@property (nonatomic, strong) UIImage     *imageSmall;


//为了第三个页面新加的
@property (nonatomic,retain) NSString    *sender;
@property (nonatomic,assign) NSInteger    ID;


- (CGRect)timeFrame;
- (CGRect)logoFrame;
- (CGRect)messageFrame;
- (CGRect)bubbleFrame;
- (CGRect)imageFrame;
- (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
