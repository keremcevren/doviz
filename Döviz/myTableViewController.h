//
//  myTableViewController.h
//  Döviz
//
//  Created by House Apps on 01/06/15.
//  Copyright (c) 2015 House Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "myCell.h"
#import "moneyClass.h"
#import "userDefaultLog.h"
@interface myTableViewController : UITableViewController <UITableViewDataSource,UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *JSONArray;
@property (strong, nonatomic) NSMutableArray *savingUserDefaultsData;

- (IBAction)refreshTap:(id)sender;

@end
