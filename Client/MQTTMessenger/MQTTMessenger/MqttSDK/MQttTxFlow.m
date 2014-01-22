//
// MQtttTxFlow.m
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

#import "MQttTxFlow.h"

@implementation MQttTxFlow

+ (id)flowWithMsg:(MQTTMessage*)msg
         deadline:(unsigned int)deadline {
   return [[MQttTxFlow alloc] initWithMsg:msg deadline:deadline];
}

- (id)initWithMsg:(MQTTMessage*)aMsg
         deadline:(unsigned int)aDeadline {
   msg = aMsg;
   deadline = aDeadline;
   return self;
}

- (void)setMsg:(MQTTMessage*)aMsg {
    msg = aMsg;
}

- (void)setDeadline:(unsigned int)newDeadline {
    deadline = newDeadline;
}

- (MQTTMessage*)msg {
    return msg;
}

- (unsigned int) deadline {
    return deadline;
}


@end
