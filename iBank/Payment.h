//
//  Payment.h
//  sqliteTutorial
//
//  Created by Florjon Koci on 2/19/13.
//  Copyright (c) 2013 iffytheperfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment : NSObject

@property(nonatomic,strong)NSString *MidasPaymentReference;
@property(nonatomic,strong)NSString *PaymentSegment;
@property(nonatomic,strong)NSString *CustomerNumber;
@property(nonatomic,strong)NSString *DebitAccount;
@property(nonatomic,strong)NSString *DebitAmount;
@property(nonatomic,strong)NSString *DebitCCY;
@property(nonatomic,strong)NSString *CreditAccount;
@property(nonatomic,strong)NSString *CreditAmount;
@property(nonatomic,strong)NSString *CreditCCY;
@property(nonatomic,strong)NSString *PaymentDate;
@property(nonatomic,strong)NSString *PaymentStatus;

@end
