//
// MQTTSession.h
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
#import "MQTTDecoder.h"
#import "MQTTEncoder.h"

typedef enum {
    MQTTSessionStatusCreated,
    MQTTSessionStatusConnecting,
    MQTTSessionStatusConnected,
    MQTTSessionStatusError
} MQTTSessionStatus;

typedef enum {
    MQTTSessionEventConnected,
    MQTTSessionEventConnectionRefused,
    MQTTSessionEventConnectionClosed,
    MQTTSessionEventConnectionError,
    MQTTSessionEventProtocolError
} MQTTSessionEvent;

@interface MQTTSession : NSObject {
    MQTTSessionStatus    status;
    NSString*            clientId;
    //NSString*            userName;
    //NSString*            password;
    UInt16               keepAliveInterval;
    BOOL                 cleanSessionFlag;
    MQTTMessage*         connectMessage;
    NSRunLoop*           runLoop;
    NSString*            runLoopMode;
    NSTimer*             timer;
    NSInteger            idleTimer;
    MQTTEncoder*         encoder;
    MQTTDecoder*         decoder;
    UInt16               txMsgId;
    id                   delegate;
    NSMutableDictionary* txFlows;
    NSMutableDictionary* rxFlows;
    unsigned int         ticks;
}

- (id)initWithClientId:(NSString*)theClientId;
- (id)initWithClientId:(NSString*)theClientId runLoop:(NSRunLoop*)theRunLoop
               forMode:(NSString*)theRunLoopMode;
- (id)initWithClientId:(NSString*)theClientId
              userName:(NSString*)theUsername
              password:(NSString*)thePassword;
- (id)initWithClientId:(NSString*)theClientId
              userName:(NSString*)theUserName
              password:(NSString*)thePassword
               runLoop:(NSRunLoop*)theRunLoop
               forMode:(NSString*)theRunLoopMode;
- (id)initWithClientId:(NSString*)theClientId
              userName:(NSString*)theUsername
              password:(NSString*)thePassword
             keepAlive:(UInt16)theKeepAliveInterval
          cleanSession:(BOOL)cleanSessionFlag;
- (id)initWithClientId:(NSString*)theClientId
              userName:(NSString*)theUsername
              password:(NSString*)thePassword
             keepAlive:(UInt16)theKeepAlive
          cleanSession:(BOOL)theCleanSessionFlag
               runLoop:(NSRunLoop*)theRunLoop
               forMode:(NSString*)theMode;
- (id)initWithClientId:(NSString*)theClientId
              userName:(NSString*)theUserName
              password:(NSString*)thePassword
             keepAlive:(UInt16)theKeepAliveInterval
          cleanSession:(BOOL)theCleanSessionFlag
             willTopic:(NSString*)willTopic
               willMsg:(NSData*)willMsg
               willQoS:(UInt8)willQoS
        willRetainFlag:(BOOL)willRetainFlag;
- (id)initWithClientId:(NSString*)theClientId
              userName:(NSString*)theUserName
              password:(NSString*)thePassword
             keepAlive:(UInt16)theKeepAliveInterval
          cleanSession:(BOOL)theCleanSessionFlag
             willTopic:(NSString*)willTopic
               willMsg:(NSData*)willMsg
               willQoS:(UInt8)willQoS
        willRetainFlag:(BOOL)willRetainFlag
               runLoop:(NSRunLoop*)theRunLoop
               forMode:(NSString*)theRunLoopMode;
- (id)initWithClientId:(NSString*)theClientId
             keepAlive:(UInt16)theKeepAliveInterval
        connectMessage:(MQTTMessage*)theConnectMessage
               runLoop:(NSRunLoop*)theRunLoop
               forMode:(NSString*)theRunLoopMode;

- (void)dealloc;
- (void)close;
- (void)setDelegate:aDelegate;
- (void)connectToHost:(NSString*)ip port:(UInt32)port;
- (void)connectToHost:(NSString*)ip port:(UInt32)port usingSSL:(BOOL)usingSSL;
- (void)subscribeTopic:(NSString*)theTopic;
- (void)subscribeToTopic:(NSString*)topic atLevel:(UInt8)qosLevel;
- (void)unsubscribeTopic:(NSString*)theTopic;
- (void)publishData:(NSData*)theData onTopic:(NSString*)theTopic;
- (void)publishDataAtLeastOnce:(NSData*)theData onTopic:(NSString*)theTopic;
- (void)publishDataAtLeastOnce:(NSData*)theData onTopic:(NSString*)theTopic retain:(BOOL)retainFlag;
- (void)publishDataAtMostOnce:(NSData*)theData onTopic:(NSString*)theTopic;
- (void)publishDataAtMostOnce:(NSData*)theData onTopic:(NSString*)theTopic retain:(BOOL)retainFlag;
- (void)publishDataExactlyOnce:(NSData*)theData onTopic:(NSString*)theTopic;
- (void)publishDataExactlyOnce:(NSData*)theData onTopic:(NSString*)theTopic retain:(BOOL)retainFlag;
- (void)publishJson:(id)payload onTopic:(NSString*)theTopic;
- (void)timerHandler:(NSTimer*)theTimer;
- (void)encoder:(MQTTEncoder*)sender handleEvent:(MQTTEncoderEvent) eventCode;
- (void)decoder:(MQTTDecoder*)sender handleEvent:(MQTTDecoderEvent) eventCode;
- (void)decoder:(MQTTDecoder*)sender newMessage:(MQTTMessage*) msg;

// private methods
- (void)newMessage:(MQTTMessage*)msg;
- (void)error:(MQTTSessionEvent)event;
- (void)handlePublish:(MQTTMessage*)msg;
- (void)handlePuback:(MQTTMessage*)msg;
- (void)handlePubrec:(MQTTMessage*)msg;
- (void)handlePubrel:(MQTTMessage*)msg;
- (void)handlePubcomp:(MQTTMessage*)msg;
- (void)send:(MQTTMessage*)msg;
- (UInt16)nextMsgId;

@property (strong,atomic) NSMutableArray* queue;
@property (strong,atomic) NSMutableArray* timerRing;

@end

@interface NSObject (MQTTSessionDelegate)
- (void)session:(MQTTSession*)session handleEvent:(MQTTSessionEvent)eventCode;
- (void)session:(MQTTSession*)session newMessage:(NSData*)data onTopic:(NSString*)topic;

@end
