//
//  SWChatBubbleCell.m
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-16.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import "SWChatBubbleCell.h"

#import "UIImageView+AFNetworking.h"

@interface SWChatBubbleCell ()

@property (strong, nonatomic) IBOutlet UIImageView *messageBgView;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet UIImageView *headerView;

@property (nonatomic) SWChatBubbleCellType cellType;

@end

@implementation SWChatBubbleCell

- (void)setMessage:(Message *)message
{
    _message = message;
    
    self.messageLabel.text = message.message;
    [self.messageLabel setBounds:CGRectMake(0.f, 0.f, 160.f, 20.f)];
    [self.messageLabel sizeToFit];
    
    self.cellType = [message.from isEqual:[SWAppDelegate shareInstance].currentUser] ? SWChatBubbleCellMe : SWChatBubbleCellOthers;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.messageBgView.frame;
    rect.size.height = self.messageLabel.frame.size.height + 30.f;
    rect.size.width = self.messageLabel.frame.size.width + 35.f;
    self.messageBgView.frame = rect;
    
    switch (self.cellType) {
        case SWChatBubbleCellOthers:
        {
            CGRect rect = self.headerView.frame;
            rect.origin.x = 5.f;
            self.headerView.frame = rect;
            rect = self.messageBgView.frame;
            self.messageBgView.image = [UIImage imageNamed:@"ReceiverTextNodeBkg_ios7.png"];
            rect.origin.x = CGRectGetMaxX(self.headerView.frame) + 10.f;
            self.messageBgView.frame = rect;
            [self.headerView setImageWithURL:[NSURL URLWithString:@"http://tp2.sinaimg.cn/1894383393/180/5627275880/1"] placeholderImage:[UIImage imageNamed:@"Default_user_avatar.png"]];
        }
            break;
        case SWChatBubbleCellMe:
        {
            CGRect rect = self.headerView.frame;
            rect.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(rect) - 5.f;
            self.headerView.frame = rect;
            rect = self.messageBgView.frame;
            self.messageBgView.image = [UIImage imageNamed:@"SenderTextNodeBkg_ios7.png"];
            rect.origin.x = CGRectGetWidth(self.frame) - (CGRectGetWidth(self.headerView.frame) + CGRectGetWidth(rect) + 15.f);
            self.messageBgView.frame = rect;
            [self.headerView setImageWithURL:[NSURL URLWithString:@"http://tp1.sinaimg.cn/1985180764/180/5609469743/1"] placeholderImage:[UIImage imageNamed:@"Default_user_avatar.png"]];
        }
            break;
        default:
            break;
    }
    [self reLayoutMessageLableCenter];
}

- (void)reLayoutMessageLableCenter
{
    CGPoint center = self.messageBgView.center;
    center.y -= 4.f;
    self.messageLabel.center = center;
}

+ (CGFloat)hightOfCellOfText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.0f, 160.f, 20.f)];
    label.numberOfLines = 0;
    label.text = text;
    [label sizeToFit];
    return label.frame.size.height;
}

@end
