//
//  PFAddLineItemVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 08/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFAddLineItemVC.h"

@interface PFAddLineItemVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *categoryDatasourceArray;
    NSMutableArray *productDatasourceArray;
    NSString *strCategoryID;
    NSString *strProductID;

}

@property (strong, nonatomic) IBOutlet UITextField *txtPackageUnit;
@property (strong, nonatomic) IBOutlet UITextField *txtProduct;
@property (strong, nonatomic) IBOutlet UITextField *txtQty;
@property (strong, nonatomic) IBOutlet UITableView *tablCategory;
@property (strong, nonatomic) IBOutlet UITableView *tableProduct;

@end

@implementation PFAddLineItemVC

#pragma mark - View controller life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    categoryDatasourceArray = [[NSMutableArray alloc] init];
    productDatasourceArray  = [[NSMutableArray alloc] init];
    
    
    self.tablCategory.delegate = self;
    self.tablCategory.dataSource = self;
    self.tableProduct.delegate = self;
    self.tableProduct.dataSource = self;


    [self callgetcategoryServiceIntegration];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

}
#pragma mark -

#pragma mark - UITextField delegate method
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self AnimateViewOnKeyboard];
    
    if (textField == self.txtProduct) {
        [self.tablCategory setHidden:YES];
        [self.tableProduct setHidden:YES];
    }
    else if (textField == self.txtQty){
        
        [self.tablCategory setHidden:YES];
        [self.tableProduct setHidden:YES];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtPackageUnit) {
        [self.txtProduct becomeFirstResponder];
        
    }else if (textField == self.txtProduct) {
        [self.txtQty becomeFirstResponder];
        [self.tablCategory setHidden:YES];
        [self.tableProduct setHidden:NO];
        
    }else if (textField == self.txtQty){
        [textField resignFirstResponder];
        [self.tablCategory setHidden:YES];
        [self.tableProduct setHidden:YES];
        [self hideKeyboard];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(string.length > 0 && textField == self.txtQty){
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
        
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        return stringIsValid;
    }else if(textField == self.txtProduct){

        [self callgetSearchNewProductServiceIntegration:strCategoryID keyword:string];
    }
    
    return YES;
}



#pragma mark - UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tablCategory){
        return [categoryDatasourceArray count];
    }
    else if (tableView == self.tableProduct){
        return [productDatasourceArray count];
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    
    cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    
    if (tableView == self.tablCategory){
        PFPreInspectionModel *inspectionInfo = [categoryDatasourceArray objectAtIndex:indexPath.row];
        cell.textLabel.text=inspectionInfo.strCategory_name;
    }
    
    else if (tableView == self.tableProduct){
        PFPreInspectionModel *inspectionInfo = [productDatasourceArray objectAtIndex:indexPath.row];
        cell.textLabel.text=inspectionInfo.strPrductName;
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tablCategory){
        PFPreInspectionModel *inspectionInfo = [categoryDatasourceArray objectAtIndex:indexPath.row];
        self.txtPackageUnit.text=inspectionInfo.strCategory_name;
        strCategoryID = inspectionInfo.strCategory_id;
        [self.tablCategory setHidden:YES];
        [self.tableProduct setHidden:YES];
    }
    else if (tableView == self.tableProduct){
        PFPreInspectionModel *inspectionInfo = [productDatasourceArray objectAtIndex:indexPath.row];
        self.txtProduct.text=inspectionInfo.strPrductName;
        strProductID = inspectionInfo.strPrductId;
        [self.tablCategory setHidden:YES];
        [self.tableProduct setHidden:YES];
    }
}
#pragma mark -


#pragma mark -

-(void)AnimateViewOnKeyboard{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, -150.0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)hideKeyboard{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0.0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void) onKeyboardHide:(NSNotification *)notification{
    [self.tablCategory setHidden:YES];
    [self.tableProduct setHidden:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0.0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - IBActions
- (IBAction)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
- (IBAction)backGroundBtnAction:(UIButton *)sender {
    [self hideKeyboard];
    [self.tablCategory setHidden:YES];
    [self.tableProduct setHidden:YES];
    if ([self.txtPackageUnit isFirstResponder]) {
        [self.txtPackageUnit resignFirstResponder];
    }else if ([self.txtProduct isFirstResponder]){
        [self.txtProduct resignFirstResponder];
    }else if ([self.txtQty isFirstResponder]){
        [self.txtQty resignFirstResponder];
    }
}

- (IBAction)saveBtnAction:(UIButton *)sender {
    
    [self calladdNewProductServiceIntegration:strProductID];
}

- (IBAction)categoryBtnAction:(UIButton *)sender {
    [self.tablCategory setHidden:NO];
    [self.tableProduct setHidden:YES];
}

- (IBAction)upQtyBtnAction:(UIButton *)sender {
    self.txtQty.text = [NSString stringWithFormat:@"%ld",(long)[self.txtQty.text integerValue] + 1];
}

- (IBAction)downQtyBtnAction:(UIButton *)sender {
    if ([self.txtQty.text integerValue] > 0) {
        self.txtQty.text = [NSString stringWithFormat:@"%ld",(long)[self.txtQty.text integerValue] - 1];
    }
}

#pragma mark -

#pragma mark - Service Helper Method
-(void)callgetcategoryServiceIntegration {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"getCategoryList"forKey:@"action"];
    
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {
            [categoryDatasourceArray removeAllObjects];
            NSArray *categoryListArray = [result objectForKeyNotNull:@"categoryData" expectedClass:[NSArray class]];
            for (NSMutableDictionary *categoryDict in categoryListArray) {
                PFPreInspectionModel *inspectionInfo = [PFPreInspectionModel modelCategoryListDict:categoryDict];
                [categoryDatasourceArray addObject:inspectionInfo];
            }
            [self.tablCategory reloadData];
        }
    }];
}

-(void)callgetSearchNewProductServiceIntegration:(NSString*)catId keyword:(NSString*)keyword{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"searchNewProduct" forKey:@"action"];
    [dict setValue:catId forKey:@"categoryId"];
    [dict setValue:keyword forKey:@"keyword"];

 //   "responseMessage":""
    
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressNotShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {
            
            if ([[result objectForKey:@"responseMessage"] isEqualToString:@"No Product Found"]) {
                [self.tableProduct setHidden:YES];
            }else{
                [self.tableProduct setHidden:NO];
            }
            

            
            [productDatasourceArray removeAllObjects];
            NSArray *productListArray = [result objectForKeyNotNull:@"list" expectedClass:[NSArray class]];
            for (NSMutableDictionary *productDict in productListArray) {
                PFPreInspectionModel *inspectionInfo = [PFPreInspectionModel modelProductListDict:productDict];
                [productDatasourceArray addObject:inspectionInfo];
            }
            [self.tableProduct reloadData];
        }
    }];
}


-(void)calladdNewProductServiceIntegration:(NSString*)productId{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"additionalOrder" forKey:@"action"];
    [dict setValue:self.strParentOrderId forKey:@"parentOrderId"];
    [dict setValue:productId forKey:@"productId"];
    [dict setValue:self.txtQty.text forKey:@"qty"];
    
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressNotShown WithComptionBlock:^(id result, NSError *error)
     {
        if (!error)
        {
            [self dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refershPreInspectionList" object:nil];
            }];
        }
    }];
}
#pragma mark -

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

@end
