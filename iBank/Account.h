//
//  Account.h
//  sqliteTutorial
//
//  Created by Florjon Koci on 3/5/13.
//  Copyright (c) 2013 iffytheperfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property(nonatomic,strong)NSString *accountNumber;
@property(nonatomic,strong)NSString *retailAccountNumber;
@property(nonatomic,strong)NSString *iban;
@property(nonatomic,strong)NSString *accountProduct;
@property(nonatomic,strong)NSString *currency;
@property(nonatomic,strong)NSString *frequency;
@property(nonatomic,strong)NSString *accountCode;
@property(nonatomic,strong)NSString *branchCode;
@property(nonatomic,strong)NSString *customerNumber;
@property(nonatomic,strong)NSString *balance;
@property(nonatomic,strong)NSString *status;

@end
