//
//  Deposit.h
//  iBank
//
//  Created by Florjon Koci on 4/25/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deposit : NSObject

@property(nonatomic,strong)NSString *ProductName;
@property(nonatomic,strong)NSString *MidasDealNumber;
@property(nonatomic,strong)NSString *AccountDebitValue;
@property(nonatomic,strong)NSString *AccountCreditValue;
@property(nonatomic,strong)NSString *DepositAmount;
@property(nonatomic,strong)NSString *CurrencyCode;
@property(nonatomic,strong)NSString *DepositStatus;

@end
