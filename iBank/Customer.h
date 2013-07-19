//
//  Customer.h
//  iBank
//
//  Created by Florjon Koci on 4/25/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property(nonatomic,strong)NSString *CustomerID;
@property(nonatomic,strong)NSString *IdentifierNumber;
@property(nonatomic,strong)NSString *FirstName;
@property(nonatomic,strong)NSString *Surname;
@property(nonatomic,strong)NSString *Gender;
@property(nonatomic,strong)NSString *Address;
@property(nonatomic,strong)NSString *Telephone;
@property(nonatomic,strong)NSString *HomePhone;
@property(nonatomic,strong)NSString *WorkPhone;
@property(nonatomic,strong)NSString *Exists;
@property(nonatomic,strong)NSString *BirthDate;
@property(nonatomic,strong)NSString *FatherName;

@end
