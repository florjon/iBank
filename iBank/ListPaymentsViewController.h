//
//  ListPaymentsViewController.h
//  sqliteTutorial
//
//  Created by Florjon Koci on 3/4/13.
//  Copyright (c) 2013 iffytheperfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"

@interface ListPaymentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *paymentsTableView;

@end
