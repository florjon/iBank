//
//  DetailPaymentViewController.h
//  iBank
//
//  Created by Florjon Koci on 4/29/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"

@interface DetailPaymentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Payment  *payment;





@property (strong, nonatomic) IBOutlet UILabel *MidasPaymentReference;
@property (strong, nonatomic) IBOutlet UILabel *PaymentSegment;
@property (strong, nonatomic) IBOutlet UILabel *CustomerNumber;
@property (strong, nonatomic) IBOutlet UILabel *DebitAccount;
@property (strong, nonatomic) IBOutlet UILabel *DebitAmount;
@property (strong, nonatomic) IBOutlet UILabel *DebitCCY;
@property (strong, nonatomic) IBOutlet UILabel *CreditAccount;
@property (strong, nonatomic) IBOutlet UILabel *CreditAmount;
@property (strong, nonatomic) IBOutlet UILabel *CreditCCY;
@property (strong, nonatomic) IBOutlet UILabel *PaymentDate;
@property (strong, nonatomic) IBOutlet UILabel *PaymentStatus;
@end
