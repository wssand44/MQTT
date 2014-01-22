//
// MQTTDecoder.h
// MQtt Client
// 
// Copyright (c) 2011, 2013, 2lemetry LLC
// 
// All rights reserved. This program and the accompanying materials
// are made available under the terms of the Eclipse Public License v1.0
// which accompanies this distribution, and is available at
// http://www.eclipse.org/legal/epl-v10.html
// 
// Contributors:
//    Kyle Roche - initial API and implementation and/or initial documentation
// 

#import <Foundation/Foundation.h>
#import "MQTTMessage.h"

@interface MQTTDecoder : NSObject <NSStreamDelegate> {
    NSInteger       status;
    NSInputStream*  stream;
    NSRunLoop*      runLoop;
    NSString*       runLoopMode;
    id              delegate;
    UInt8           header;
    UInt32          length;
    UInt32          lengthMultiplier;
    NSMutableData*  dataBuffer;
}

typedef enum {
    MQTTDecoderEventProtocolError,
    MQTTDecoderEventConnectionClosed,
    MQTTDecoderEventConnectionError
} MQTTDecoderEvent;

enum {
    MQTTDecoderStatusInitializing,
    MQTTDecoderStatusDecodingHeader,
    MQTTDecoderStatusDecodingLength,
    MQTTDecoderStatusDecodingData,
    MQTTDecoderStatusConnectionClosed,
    MQTTDecoderStatusConnectionError,
    MQTTDecoderStatusProtocolError
};

- (id)initWithStream:(NSInputStream*)aStream
             runLoop:(NSRunLoop*)aRunLoop
         runLoopMode:(NSString*)aMode;
- (void)setDelegate:(id)aDelegate;
- (void)open;
- (void)close;
- (void)stream:(NSStream*)sender handleEvent:(NSStreamEvent)eventCode;
@end

@interface NSObject (MQTTDecoderDelegate)
- (void)decoder:(MQTTDecoder*)sender newMessage:(MQTTMessage*)msg;
- (void)decoder:(MQTTDecoder*)sender handleEvent:(MQTTDecoderEvent)eventCode;

@end
