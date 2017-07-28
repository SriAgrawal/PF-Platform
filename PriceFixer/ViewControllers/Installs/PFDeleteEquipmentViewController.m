//
//  PFDeleteEquipmentViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 03/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFDeleteEquipmentViewController.h"
#import "PFDeleteEquipmentCellTableViewCell.h"
#import "PFEquipmentModelInfo.h"
#import "Macro.h"

static NSString * PFDeleteEquipmentCellId = @"deleteEquipmentCellId";

@interface PFDeleteEquipmentViewController () <UITextFieldDelegate>{
    
    PFEquipmentModelInfo *equipmentInfo;
    NSMutableArray *equipmentArray;
    int quantityCount;
}

@property (weak, nonatomic) IBOutlet UITableView *deleteEquipmentTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PFDeleteEquipmentViewController

#pragma mark - View Controller life cycle method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialMethod];
}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Initial Method
- (void)initialMethod {
    
    [self.deleteEquipmentTableView registerNib:[UINib nibWithNibName:@"PFDeleteEquipmentCellTableViewCell" bundle:nil] forCellReuseIdentifier:PFDeleteEquipmentCellId];
    
    // Alloc Model Class
    equipmentInfo = [[PFEquipmentModelInfo alloc] init];
    
    // Alloc Array
    equipmentArray = [NSMutableArray array];
    
    [self callDeleteEquipmentListServiceIntegration];

}


#pragma mark - UITableView Delegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return equipmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFDeleteEquipmentCellTableViewCell * cell = (PFDeleteEquipmentCellTableViewCell *)[self.deleteEquipmentTableView dequeueReusableCellWithIdentifier:PFDeleteEquipmentCellId];
    cell.unitTextField.delegate = self;
    
    cell.downButton.tag = indexPath.row+100;
    cell.upButton.tag = indexPath.row+400;
    cell.unitTextField.tag = indexPath.row+600;
    cell.textFieldLabel.tag = indexPath.row+800;

    equipmentInfo = [equipmentArray objectAtIndex:indexPath.row];
 
    cell.equipmentNameLabel.text = equipmentInfo.strItem_title;
    cell.equipmentDetailLabel.text = equipmentInfo.strItem_desc;
    cell.unitTextField.text = [NSString stringWithFormat:@"%ld",(long)equipmentInfo.strQty];

    [cell.downButton addTarget:self action:@selector(downButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.upButton addTarget:self action:@selector(upButtonAction:) forControlEvents:UIControlEventTouchUpInside];


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0;
}


#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSInteger index = textField.tag+200;
    for (long ind = index; ind<equipmentArray.count+index; ind++) {
        UILabel *lbl = [self.view viewWithTag:ind];
        lbl.layer.borderColor = KHomeTextFieldGrayBorderColor;
    }
    
    UILabel *lbl = [self.view viewWithTag:index];
    lbl.layer.borderColor = KHomeTextFieldBorderColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    equipmentInfo = [equipmentArray objectAtIndex:textField.tag-600];
    UILabel *label = [self.view viewWithTag:textField.tag+200];
    label.layer.borderColor = KHomeTextFieldGrayBorderColor;
    equipmentInfo.strQty = [textField.text intValue];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length > 3)
        return NO;
    
    return YES;
}

#pragma mark - Selector Method
- (void)downButtonAction :(UIButton*)sender {
    
    [self.view endEditing:YES];
    equipmentInfo = [equipmentArray objectAtIndex:sender.tag-100];
    
    if (equipmentInfo.strQty != 0) {
        equipmentInfo.strQty = equipmentInfo.strQty - 1;
        [self.deleteEquipmentTableView reloadData];
    }
}

- (void)upButtonAction :(UIButton*)sender {
    
    [self.view endEditing:YES];
    equipmentInfo = [equipmentArray objectAtIndex:sender.tag-400];
    
    if (equipmentInfo.strQty < 999) {
        equipmentInfo.strQty = equipmentInfo.strQty + 1;
        [self.deleteEquipmentTableView reloadData];
  }
}


#pragma mark - UIButton Action
- (IBAction)dismissButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self callUpdateEquipmentListServiceIntegration];
}

#pragma mark - Service Helper Method
- (void) callDeleteEquipmentListServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setValue:@"deleteEquipmentList"forKey:@"action"];
    [dict setValue:self.installModel.strParentOrderId forKey:@"parent_order_id"];
    
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {

            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                NSArray *deleteEquipmentList = [response objectForKeyNotNull:@"equipment_list" expectedClass:[NSArray class]];
                
                for (NSDictionary *equipmentDict in deleteEquipmentList) {
                    
                    [equipmentArray addObject:[PFEquipmentModelInfo modelDeleteEquipmentListDict:equipmentDict]];
                }
                
                [self.deleteEquipmentTableView reloadData];
            }
            else if([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 0) {
                [self.deleteEquipmentTableView reloadData];
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


- (void) callUpdateEquipmentListServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *equipmentIdArray = [NSMutableArray array];
    NSMutableArray *quantityArray = [NSMutableArray array];;

    for (int index=0; index<equipmentArray.count; index++) {
        equipmentInfo = [equipmentArray objectAtIndex:index];
        [equipmentIdArray addObject:equipmentInfo.strId];
        [quantityArray addObject:[NSString stringWithFormat:@"%ld",equipmentInfo.strQty]];
    }
    
    [dict setValue:@"changeOrderQty"forKey:@"action"];
    [dict setValue:self.installModel.strParentOrderId forKey:@"parent_order_id"];
    [dict setValue:quantityArray forKey:@"qty"];
    [dict setValue:equipmentIdArray forKey:@"ids"];

    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate callTechCheckApi];
                }];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



@end
