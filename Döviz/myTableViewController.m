//
//  myTableViewController.m
//  Döviz
//
//  Created by House Apps on 01/06/15.
//  Copyright (c) 2015 House Apps. All rights reserved.
//

#import "myTableViewController.h"

@interface myTableViewController ()

@end

@implementation myTableViewController
@synthesize savingUserDefaultsData;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self requestJSON];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    self.refreshControl = refresh ;
    
    [refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    savingUserDefaultsData = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    moneyClass *rowMoney = [self.JSONArray objectAtIndex:indexPath.row];
    
    UIAlertView *alarmView = [[UIAlertView alloc] initWithTitle:rowMoney.moneyType
                                                        message:@"Para miktarını girin."
                                                       delegate:self
                                              cancelButtonTitle:@"İptal"
                                              otherButtonTitles:@"Hesapla",nil];
    
    [alarmView setTag:indexPath.row];
    [alarmView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *textField = [alarmView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    [alarmView show];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.JSONArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    myCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    moneyClass *rowMoney = [self.JSONArray objectAtIndex:indexPath.row];
    
    cell.paraTuru.text = rowMoney.moneyType;
    
    cell.paraDegeri.text = [@"" stringByAppendingFormat:@"%f %@",rowMoney.valueOfMoney,rowMoney.moneySign];
    
    return cell;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if( buttonIndex == 1 ){
        
        moneyClass *selectedMoney = [self.JSONArray objectAtIndex:alertView.tag];
        
        UITextField *enteredValue = [alertView textFieldAtIndex:0];
        
        if( [enteredValue.text  isEqual: @""] ){
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Hata"
                                                                   message:@"Lütfen boş değer girmeyin"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Tamam"
                                                         otherButtonTitles:nil];
            
            [errorAlert show];
            
        }else{
            
            float valueOfMoney = selectedMoney.valueOfMoney;
            
            NSString *processResultsString = [@"" stringByAppendingFormat:@"%f %@",valueOfMoney * [enteredValue.text floatValue],selectedMoney.moneySign];
            
            UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:@"Sonuç"
                                                                   message:processResultsString
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Tamam"
                                                         otherButtonTitles:nil];
            
            [resultAlert show];
            
            //Add to array
            [savingUserDefaultsData insertObject:processResultsString atIndex:0];
            
            NSLog(@"Data saved");
            
        }
        
    }
    
}

-(void)refreshData{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"hh : mm : ss "];
    
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
    
    NSLog(@"Son güncelleme : %@",str);

}

-(void)requestJSON
{
    
    NSString *URLstring = @"http://www.json-generator.com/api/json/get/clirYYQGKW?indent=2";
    NSURL *url = [NSURL URLWithString:URLstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *) responseObject;
        
        
        moneyClass *dolar = [[moneyClass alloc] init];
        
        dolar.valueOfMoney = [[dic objectForKey:@"ddolar"] floatValue];
        dolar.moneyType = @"Dolar(USD)";
        dolar.moneySign = @"$";
        
        moneyClass *euro = [[moneyClass alloc] init];
        
        euro.valueOfMoney = [[dic objectForKey:@"deuro"] floatValue];
        euro.moneyType = @"Euro(EUR)";
        euro.moneySign = @"€";
        
        
        NSArray *array = [NSArray arrayWithObjects:dolar,euro, nil];
        
        self.JSONArray = array;
        [self.tableView reloadData];
        
        NSLog(@"%@",dic);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bir hata oluştu!"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Tamam"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    

    [operation start];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    userDefaultLog *udl = [segue destinationViewController];
    
    udl.defaultArray = savingUserDefaultsData;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:savingUserDefaultsData];
    [defaults setObject:data forKey:@"myKey"];
    
}


- (IBAction)refreshTap:(id)sender {
    [self refreshData];
}


@end
