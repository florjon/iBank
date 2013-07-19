//
//  ListDepositsViewController.h
//  iBank
//
//  Created by Florjon Koci on 4/26/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deposit.h"

@interface ListDepositsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *depositsTableView;


@end
