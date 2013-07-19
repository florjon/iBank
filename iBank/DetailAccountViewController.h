//
//  DetailAccountViewController.h
//  iBank
//
//  Created by Florjon Koci on 5/7/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface DetailAccountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Account *account;


@property (strong, nonatomic) IBOutlet UILabel *accountNumber;
@property (strong, nonatomic) IBOutlet UILabel *retail;
@property (strong, nonatomic) IBOutlet UILabel *iban;
@property (strong, nonatomic) IBOutlet UILabel *accountProduct;
@property (strong, nonatomic) IBOutlet UILabel *currency;
@property (strong, nonatomic) IBOutlet UILabel *frequency;
@property (strong, nonatomic) IBOutlet UILabel *accountCode;
@property (strong, nonatomic) IBOutlet UILabel *branchCode;
@property (strong, nonatomic) IBOutlet UILabel *customerNumber;
@property (strong, nonatomic) IBOutlet UILabel *balance;
@property (strong, nonatomic) IBOutlet UILabel *status;

@end
