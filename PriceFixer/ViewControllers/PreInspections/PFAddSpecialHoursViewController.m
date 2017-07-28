//
//  PFAddSpecialHoursViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 08/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFAddSpecialHoursViewController.h"
#import "PFAddSpecialHourTableViewCell.h"
#import "PFAddSpecialHour.h"
#import "Macro.h"

static NSString * PFAddSpecialHourCellId = @"AddSpecialHoursCellId";
static NSString *CellIdentifier = @"Cell";

@interface PFAddSpecialHoursViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    
    NSMutableArray *itemsArray;
    NSMutableArray *itemsCostArray;
    NSInteger textFieldTag;
    long responseArrayCount;
}

@property (weak, nonatomic) IBOutlet UITableView *addSpecialHourTableView;
@property (weak, nonatomic) IBOutlet UILabel *addSpecialHoursLabel;
@property (strong, nonatomic) UITableView  *crewTableView;

@end

@implementation PFAddSpecialHoursViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom method

- (void)initialSetup {
    
    // Register TableView
    [self.addSpecialHourTableView registerNib:[UINib nibWithNibName:@"PFAddSpecialHourTableViewCell" bundle:nil] forCellReuseIdentifier:PFAddSpecialHourCellId];
    
    textFieldTag = -1;
    
    itemsArray = [NSMutableArray array];
    itemsCostArray = [NSMutableArray array];
    [itemsCostArray addObject:@"0"];
    [itemsCostArray addObject:@"112"];

    self.crewTableView = [[UITableView alloc]initWithFrame:CGRectMake(152, 370, 720, 100) style:UITableViewStylePlain];
    self.crewTableView.dataSource=self;
    self.crewTableView.delegate=self;
    self.crewTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];

    self.crewTableView.layer.cornerRadius = 6;
    self.crewTableView.layer.masksToBounds = YES;
    self.crewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.crewTableView.hidden=YES;
    [self.addSpecialHourTableView addSubview:self.crewTableView];

    [self callGetSpecialHoursServiceIntegration];
}


#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.crewTableView]) {
        return itemsCostArray.count;
    }
    else
        return itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.crewTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        }
        cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.textLabel.text = [itemsCostArray objectAtIndex:indexPath.row];
        
        return cell;

    }
    else {
    PFAddSpecialHourTableViewCell * cell = (PFAddSpecialHourTableViewCell *)[self.addSpecialHourTableView dequeueReusableCellWithIdentifier:PFAddSpecialHourCellId];
    
    PFAddSpecialHour *hoursInfo = [itemsArray objectAtIndex:indexPath.row];
    
    if (textFieldTag == indexPath.row) {
        cell.itemTextField.layer.borderColor = KHomeTextFieldBorderColor;
        cell.hoursTextField.layer.borderColor = KHomeTextFieldBorderColor;
    }else {
        cell.itemTextField.layer.borderColor = KHomeTextFieldGrayBorderColor;
        cell.hoursTextField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    }
    
    cell.itemTextField.delegate = self;
    cell.hoursTextField.delegate = self;

    cell.itemTextField.tag = indexPath.row + 600;
    cell.hoursTextField.tag = indexPath.row + 900;
    cell.unitCostTextField.tag = indexPath.row + 1500;
    cell.deleteButton.tag = indexPath.row + 100;
    cell.unitCostButton.tag = indexPath.row + 300;

        cell.itemTextField.userInteractionEnabled = !hoursInfo.isPrefilled;
        cell.unitCostTextField.userInteractionEnabled = !hoursInfo.isPrefilled;
        cell.unitCostButton.userInteractionEnabled = !hoursInfo.isPrefilled;
        cell.hoursTextField.userInteractionEnabled = !hoursInfo.isPrefilled;
        cell.dropDownImage.hidden = hoursInfo.isPrefilled;
        cell.deleteButton.hidden = hoursInfo.isPrefilled;
        
        cell.itemTextField.text = hoursInfo.strItemTitle;
        cell.unitCostTextField.text = hoursInfo.strUnitPrice;
        cell.hoursTextField.text = hoursInfo.strHours;
        
    if (hoursInfo.isPrefilled) {
        cell.itemTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.totalCostLabel.text = [NSString stringWithFormat:@"$%@",hoursInfo.strCost];
    }
    else {
        cell.itemTextField.layer.borderColor = [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.8] CGColor];
        cell.totalCostLabel.text = (hoursInfo.strCost.length)?[NSString stringWithFormat:@"$%@",hoursInfo.strCost]:@"";
    }
    
    [cell.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.unitCostButton addTarget:self action:@selector(unitCostButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.crewTableView]) {
        return 25.0f;
    }
    else
        return 78.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.crewTableView]) {
        
    CGPoint buttonPosition = CGPointMake(self.crewTableView.frame.origin.x, self.crewTableView.frame.origin.y-37);
    NSIndexPath *tappedIP = [self.addSpecialHourTableView indexPathForRowAtPoint:buttonPosition];
        
        
    self.addSpecialHourTableView.contentSize = CGSizeMake(self.addSpecialHourTableView.contentSize.width, self.addSpecialHourTableView.contentSize.height-80);
    PFAddSpecialHour *hoursInfo = [itemsArray objectAtIndex:tappedIP.row];
        hoursInfo.strUnitPrice = [itemsCostArray objectAtIndex:indexPath.row];
        
        if (hoursInfo.strHours.length && hoursInfo.strUnitPrice.length)
            hoursInfo.strCost = [NSString stringWithFormat:@"%.2f",[hoursInfo.strHours floatValue]*[hoursInfo.strUnitPrice floatValue]];
        
        [itemsArray replaceObjectAtIndex:tappedIP.row withObject:hoursInfo];
        self.crewTableView.hidden = YES;
        [self.addSpecialHourTableView reloadData];
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textFieldTag = textField.tag;
    textField.layer.borderColor = KHomeTextFieldBorderColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;

    CGPoint buttonPosition = [textField convertPoint:CGPointZero
                                           toView:self.addSpecialHourTableView];
    NSIndexPath *tappedIP = [self.addSpecialHourTableView indexPathForRowAtPoint:buttonPosition];

    PFAddSpecialHour *hoursInfo = [itemsArray objectAtIndex:tappedIP.row];
    
    if (buttonPosition.x < (windowWidth/2))
        hoursInfo.strItemTitle = textField.text;
    else
        hoursInfo.strHours = textField.text;
    
    if (hoursInfo.strHours.length && hoursInfo.strUnitPrice.length) {
        hoursInfo.strCost = [NSString stringWithFormat:@"%.2f",[hoursInfo.strHours floatValue]*[hoursInfo.strUnitPrice floatValue]];
    }
    [itemsArray replaceObjectAtIndex:tappedIP.row withObject:hoursInfo];
    [self.addSpecialHourTableView reloadData];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - UIButton Action

- (IBAction)addButtonAction:(id)sender {

    PFAddSpecialHour *specialHoursInfo = [[PFAddSpecialHour alloc]init];
    specialHoursInfo.isPrefilled = NO;
    
    specialHoursInfo.strItemTitle = @"item";
    specialHoursInfo.strUnitPrice = @"0";
    specialHoursInfo.strHours = @"0";
    specialHoursInfo.strTotalCost = @"0";

    [itemsArray addObject:specialHoursInfo];

    [self.addSpecialHourTableView reloadData];
}


- (IBAction)dismisButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateButtonAction:(id)sender {
    
    if (responseArrayCount != itemsArray.count)
        [self callAddSpecialHoursServiceIntegration];
     else
        [PFUtility alertWithTitle:@"" andMessage:@"Please add item."  andController:self];
}

#pragma mark - Selector Method

- (void)deleteButtonAction:(UIButton*)sender {
    
    [itemsArray removeObjectAtIndex:sender.tag - 100];
    [self.addSpecialHourTableView reloadData];
}

- (void)unitCostButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    _crewTableView.hidden = NO;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.addSpecialHourTableView];
    
    
    CGRect rect = sender.frame;
    rect.origin.y = buttonPosition.y+sender.frame.size.height;
    rect.size.height = 80;
    
    self.addSpecialHourTableView.contentSize = CGSizeMake(self.addSpecialHourTableView.contentSize.width, self.addSpecialHourTableView.contentSize.height+80);
    
    [self.crewTableView setFrame:rect];
        sender.selected = !sender.selected;
    
        if (sender.selected)
            [self.crewTableView setHidden:NO];
        else
            [self.crewTableView setHidden:YES];
    
    [self.crewTableView reloadData];
}


#pragma mark -

#pragma mark - Service Helper Method
- (void)callGetSpecialHoursServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"specialList" forKey:@"action"];
    [dict setValue:self.orderId forKey:@"order_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [itemsArray removeAllObjects];
                NSArray *hoursArray = [response objectForKeyNotNull:@"responseData" expectedClass:[NSArray class]];
                for (NSMutableDictionary *hoursDict in hoursArray)
                {
                    PFAddSpecialHour *hoursInfo = [PFAddSpecialHour modelAddSpecialHourDict:hoursDict];
                    [itemsArray addObject:hoursInfo];
                }
                responseArrayCount = [itemsArray count];
                [self.addSpecialHourTableView reloadData];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


- (void)callAddSpecialHoursServiceIntegration {

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *itemTempArr = [NSMutableArray array];
    NSMutableArray *costArr = [NSMutableArray array];
    NSMutableArray *hoursArr = [NSMutableArray array];

    for (long itemIndex = responseArrayCount; itemIndex < [itemsArray count]; itemIndex++) {
        
        PFAddSpecialHour *hoursInfo = [itemsArray objectAtIndex:itemIndex];
        [itemTempArr addObject:hoursInfo.strItemTitle];
        [costArr addObject:hoursInfo.strUnitPrice];
        [hoursArr addObject:hoursInfo.strHours];
    }
   
    [dict setValue:@"changeOrderLineItemInstallSpecial" forKey:@"action"];
    [dict setValue:self.orderId forKey:@"order_id"];
    [dict setValue:itemTempArr forKey:@"invoice_item"];
    [dict setValue:costArr forKey:@"invoice_ucost"];
    [dict setValue:hoursArr forKey:@"invoice_units"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [self.delegate callTechCheckApi];
                [self dismissViewControllerAnimated:YES completion:nil];

        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

@end
