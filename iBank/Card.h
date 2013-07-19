//
//  Card.h
//  iBank
//
//  Created by Florjon Koci on 4/25/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property(nonatomic,strong)NSString *AccountNumber;
@property(nonatomic,strong)NSString *CustomerNumber;
@property(nonatomic,strong)NSString *CardID;
@property(nonatomic,strong)NSString *RetailAccountNumber;
@property(nonatomic,strong)NSString *CardType;
@property(nonatomic,strong)NSString *CardStatus;
@property(nonatomic,strong)NSString *CardLimit;
@property(nonatomic,strong)NSString *CardCcy;
@property(nonatomic,strong)NSString *AcountCode;
@property(nonatomic,strong)NSString *ExpireDate;
@property(nonatomic,strong)NSString *CardHolderName;
@property(nonatomic,strong)NSString *Nrp;
@end
