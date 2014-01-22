//
// MQttTxFlow.h
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

@interface MQttTxFlow : NSObject {
    MQTTMessage *   msg;
    unsigned int    deadline;
}

+ (id)flowWithMsg:(MQTTMessage*)aMsg
         deadline:(unsigned int)aDeadline;

- (id)initWithMsg:(MQTTMessage*)aMsg deadline:(unsigned int)aDeadline;

- (void)setMsg:(MQTTMessage*)aMsg;
- (void)setDeadline:(unsigned int)newValue;
- (MQTTMessage*)msg;
- (unsigned int)deadline;

@end

