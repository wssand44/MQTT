//
//  SWMessage+Parser.h
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-15.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import "Message.h"

@interface Message (Parser)

+ (Message *)parseMessage:(NSData *)json;

@end
