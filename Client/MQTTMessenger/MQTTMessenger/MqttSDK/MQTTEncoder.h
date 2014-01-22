//
// MQTTEncoder.h
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

@interface MQTTEncoder : NSObject <NSStreamDelegate> {
    NSInteger       status;
    NSOutputStream* stream;
    NSRunLoop*      runLoop;
    NSString*       runLoopMode;
    NSMutableData*  buffer;
    NSInteger       byteIndex;
    id              delegate;
}

typedef enum {
    MQTTEncoderEventReady,
    MQTTEncoderEventErrorOccurred
} MQTTEncoderEvent;

typedef enum {
    MQTTEncoderStatusInitializing,
    MQTTEncoderStatusReady,
    MQTTEncoderStatusSending,
    MQTTEncoderStatusEndEncountered,
    MQTTEncoderStatusError
} MQTTEncoderStatus;

- (id)initWithStream:(NSOutputStream*)aStream
             runLoop:(NSRunLoop*)aRunLoop
         runLoopMode:(NSString*)aMode;
- (void)setDelegate:(id)aDelegate;
- (void)open;
- (void)close;
- (MQTTEncoderStatus)status;
- (void)stream:(NSStream*)sender handleEvent:(NSStreamEvent)eventCode;
- (void)encodeMessage:(MQTTMessage*)msg;

@end

@interface NSObject (MQTTEncoderDelegate)
- (void)encoder:(MQTTEncoder*)sender handleEvent:(MQTTEncoderEvent)eventCode;

@end
