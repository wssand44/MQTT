//
//  SWChatBubbleCell.h
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-16.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Message.h"

typedef enum SWChatBubbleCellType{
    SWChatBubbleCellMe,
    SWChatBubbleCellOthers
}SWChatBubbleCellType;

typedef NSInteger ChatBubbleCellType;

@interface SWChatBubbleCell : UITableViewCell

@property (strong, nonatomic) Message *message;

+ (CGFloat)hightOfCellOfText:(NSString *)text;

@end
