//
//  PFQuotesBuildViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 18/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFQuotesBuildViewController.h"
#import "PFQuotesBuildTableViewCell.h"
#import "JDFSequentialTooltipManager.h"
#import "Macro.h"
#import "PFQuotesListInfo.h"
#import "UIImageView+AFNetworking.h"
#import "PFSquareFootTableViewCell.h"


static NSString * cellIdentifier = @"quotesBuildQuoteCellId";
static NSString * quoteEditCellIdentifier = @"quotesEditCellId";

@interface PFQuotesBuildViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UITextViewDelegate>{

    __weak IBOutlet UILabel *lblEmail;
    __weak IBOutlet UILabel *lblCallBack;
    __weak IBOutlet UILabel *lblName;
    
    
    __weak IBOutlet UITextField *txtAddressField;
    __weak IBOutlet UITextField *txtSquareField;
    
    __weak IBOutlet UILabel *lblFranchuseName;
    __weak IBOutlet UILabel *lblOwnerName;
    __weak IBOutlet UILabel *lblPhoneNumber;
    __weak IBOutlet UILabel *lblDistance;
    __weak IBOutlet UITextView *txtViewNotes;

    __weak IBOutlet UITextField *txtFieldForSearch;
    __weak IBOutlet UIView *viewOnScroll;

    //FOOTER VIEW

    __weak IBOutlet UILabel *lblEquipment;
    __weak IBOutlet UILabel *lblInstallationKit;
    __weak IBOutlet UILabel *lblLabour;
    __weak IBOutlet UILabel *lblTotal;
    __weak IBOutlet UILabel *lblSaveAmountText;
    
    
    __weak IBOutlet UILabel *lblEquipmentForHide;
    __weak IBOutlet UILabel *lblInstallationKitForHide;
    __weak IBOutlet UILabel *lblLabourForHide;
    __weak IBOutlet UILabel *lblTotleForHide;

    
    __weak IBOutlet UIImageView *imgCard1;
    __weak IBOutlet UIImageView *imgCard2;
    __weak IBOutlet UIImageView *imgCard3;
    __weak IBOutlet UIImageView *imgCard4;
    __weak IBOutlet UIButton *btnFirst;
    __weak IBOutlet UIButton *buttonSecond;
    __weak IBOutlet UIView *viewTechCheck;
    
    __weak IBOutlet UIView *viewSelectQuotes;
    NSMutableArray   *itemArray;
    NSMutableArray   *colSpamArray;
    NSMutableArray   *noteArray;
    NSMutableArray   *productDatasourceArray;
    NSMutableArray   *squareFootDatasourceArray;

    NSString         *productIdForAdd;
    NSDictionary     *stepsDict;
    BOOL                isAnimated;
    float           viewheight;
    float           bottomButtonViewheight;


    
    PFQuotesProductListInfo *quoteObject;
    
}

@property (nonatomic, strong) JDFSequentialTooltipManager *tooltipManager;


@property (strong, nonatomic)   IBOutlet UIView *tableFooterView;
@property (weak, nonatomic)     IBOutlet UITableView *tableView;
@property (weak, nonatomic)     IBOutlet NSLayoutConstraint *tableHeight;
@property (strong, nonatomic)   IBOutlet UITableView *tableProduct;
@property (weak, nonatomic)     IBOutlet UITableView *tblViewForNote;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *logOutView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonFirstHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonSecondHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonThirdHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
- (IBAction)btnSaveAction:(id)sender;
@property (weak, nonatomic) IBOutlet TextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *buttonThird;

@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeightTopconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *techViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quoteHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *techCheckYesButton;
@property (weak, nonatomic) IBOutlet UIButton *techCheckNoButton;
@property (weak, nonatomic) IBOutlet UIButton *quotesCouponButton;
@property (weak, nonatomic) IBOutlet UIButton *quotesButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMainViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *techCheckLabel;
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *squareFootLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *squareFootTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *squareTableView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UIView *footerOptionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notesHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *callBacklabel;
@property (weak, nonatomic) IBOutlet UILabel *emailBasicLabel;
@property (weak, nonatomic) IBOutlet UITextView *txtViewEmail;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintView;
@end

@implementation PFQuotesBuildViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
}

#pragma mark - Initial method
- (void)initialMethod {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.callBacklabel.hidden = YES;
    self.emailBasicLabel.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PFQuotesBuildTableViewCell" bundle:nil]forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PFQuotesStepsTVC" bundle:nil] forCellReuseIdentifier:@"PFQuotesStepsTVC"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PFQuotesStepForTVC" bundle:nil] forCellReuseIdentifier:@"PFQuotesStepForTVC"];
    [self.tblViewForNote registerNib:[UINib nibWithNibName:@"PFQuotesNotesTVC" bundle:nil] forCellReuseIdentifier:@"PFQuotesNotesTVC"];
    
    [self.squareTableView registerNib:[UINib nibWithNibName:@"PFSquareFootTableViewCell" bundle:nil]forCellReuseIdentifier:quoteEditCellIdentifier];

    self.squareTableView.estimatedRowHeight = 35.0;
    self.tblViewForNote.estimatedRowHeight = 44.0;
    
    self.tableView.estimatedRowHeight = 143.0;

    
    itemArray = [NSMutableArray array];
    colSpamArray = [NSMutableArray new];
    productDatasourceArray  = [NSMutableArray array];
    noteArray = [NSMutableArray new];
    squareFootDatasourceArray = [NSMutableArray array];
    
    self.squareTableView.hidden = YES;
    
    // Alloc Model Class
    quoteObject = [[PFQuotesProductListInfo alloc] init];
    
    // Set logout view
    self.logOutView.hidden = YES;
    [self.logOutViewHeightConstraint setConstant:0];
    
    // Set Table View
    self.tableProduct=[[UITableView alloc]initWithFrame:CGRectMake(40,120,txtFieldForSearch.frame.size.width, 175) style:UITableViewStylePlain];
    self.tableProduct.borderColor = [UIColor lightGrayColor];
    self.tableProduct.dataSource=self;
    self.tableProduct.delegate=self;
    [viewOnScroll addSubview:self.tableProduct];
    
    // TableView Border
    self.tblViewForNote.layer.borderColor = KHomeTextFieldGrayBorderColor;
    self.tblViewForNote.layer.borderWidth = 1.0;
    self.tblViewForNote.hidden = YES;
    
    self.tableView.layer.borderColor = KHomeTextFieldGrayBorderColor;
    self.tableView.layer.borderWidth = 1.0;
    
    txtSquareField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    txtSquareField.layer.borderWidth = 1.0;
    
    txtAddressField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    txtAddressField.layer.borderWidth = 1.0;
    
    _zipCodeTextField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    _zipCodeTextField.layer.borderWidth = 1.0;
    
    txtFieldForSearch.layer.borderColor = KHomeTextFieldGrayBorderColor;
    txtFieldForSearch.layer.borderWidth = 1.0;
    
    _emailTextfield.layer.borderColor = KHomeTextFieldGrayBorderColor;
    _emailTextfield.layer.borderWidth = 1.0;
    
    _phoneTextField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    _phoneTextField.layer.borderWidth = 1.0;
    
    _addressTextField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    _addressTextField.layer.borderWidth = 1.0;
    
    _footerOptionView.layer.borderColor = KHomeTextFieldGrayBorderColor;
    _footerOptionView.layer.borderWidth = 1.0;
    
    txtViewNotes.layer.borderColor = KHomeTextFieldGrayBorderColor;
    txtViewNotes.layer.borderWidth = 1.0;
    
    _txtViewEmail.layer.borderColor = KHomeTextFieldGrayBorderColor;
    _txtViewEmail.layer.borderWidth = 1.0;

    self.tableProduct.layer.cornerRadius = 6;
    self.tableProduct.layer.masksToBounds = YES;
    self.tableProduct.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableProduct.hidden=YES;
    
    // Set userImage corner radius
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;

    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];

    //For hint
    self.tooltipManager = [[JDFSequentialTooltipManager alloc] initWithHostView:self.view];
    
    [self callAPIForGetQuotesList];
    
    //For search Product
    
    self.tableProduct.delegate = self;
    self.tableProduct.dataSource = self;
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.tableView){
        if ([[stepsDict allKeys] count]) {
            return 3;
        }
        else
        {
            return 1;
        }
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableProduct) {
        return [productDatasourceArray count];
    }
    else if (tableView == self.tblViewForNote)
    {
        return [noteArray count];
    }
    else if (tableView == self.squareTableView) {
        return [squareFootDatasourceArray count];
    }
    else {
        if (section == 0) {
            return itemArray.count;
        }else if (section == 1) {
            return 1;
        }else {
            return colSpamArray.count;
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableProduct)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        }
      
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, txtFieldForSearch.frame.size.width-10, cell.frame.size.height)];
        cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
        cell.textLabel.font=[UIFont systemFontOfSize:13];

        PFQuotesProductListInfo *modelObject = [productDatasourceArray objectAtIndex:indexPath.row];
        if ([modelObject.strTitleID isEqualToString:@"#"]) {
            lbl.textColor = KAppGreenColor;
            lbl.text = [NSString stringWithFormat:@"%@",modelObject.strTitleLable];
        }
        else {
            lbl.textColor = [UIColor blackColor];
            lbl.text = [NSString stringWithFormat:@"%@",modelObject.strTitleHTML];
        }
        
        [cell.contentView addSubview:lbl];
        return cell;
        
        return cell;
    }
    else if (tableView == self.tblViewForNote){
    PFQuotesNotesTVC *noteCell = (PFQuotesNotesTVC *)[self.tblViewForNote dequeueReusableCellWithIdentifier:@"PFQuotesNotesTVC"];
        
        PFQuotesListInfo *quotesInfo = [noteArray objectAtIndex:indexPath.row];

        if ([quotesInfo.strIncludeEmail isEqualToString:@"1"]) {
            noteCell.backGroundView.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:232.0/255.0 blue:244.0/255.0 alpha:1.0];
            noteCell.lblForNote.textColor = [UIColor colorWithRed:43.0/255.0 green:95.0/255.0 blue:174.0/255.0 alpha:1.0];
        }
        else {
            noteCell.backGroundView.backgroundColor = [UIColor whiteColor];
            noteCell.lblForNote.textColor = [UIColor blackColor];
        }
        noteCell.lblForNote.text = quotesInfo.strDescription;

        return noteCell;
    }
    else if (tableView == self.squareTableView){
        PFSquareFootTableViewCell *quoteCell = (PFSquareFootTableViewCell *)[self.squareTableView dequeueReusableCellWithIdentifier:quoteEditCellIdentifier];
        quoteCell.squareFootLabel.text = [squareFootDatasourceArray objectAtIndex:indexPath.row];
        return quoteCell;
    }

    else
    {
        PFQuotesBuildTableViewCell *cell = (PFQuotesBuildTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        PFQuotesStepsTVC *cell2 = (PFQuotesStepsTVC *)[self.tableView dequeueReusableCellWithIdentifier:@"PFQuotesStepsTVC"];
        PFQuotesStepForTVC*cell1 = (PFQuotesStepForTVC *)[self.tableView dequeueReusableCellWithIdentifier:@"PFQuotesStepForTVC"];
        if (indexPath.section == 0)
        {
            PFQuotesListInfo *obj = [itemArray objectAtIndex:indexPath.row];
            cell.lblProductDesc.text = obj.strDesc;
            [cell.btnTitle setTitle:obj.strProduct_name forState:UIControlStateNormal];
            cell.lblSubTotal.text = obj.strSub_total;
            cell.lblAmount.text = obj.strPrice;
            [cell.productImageView setImageWithURL:[NSURL URLWithString:obj.strProduct_image_urlEmail] placeholderImage:[UIImage imageNamed:@""]];
            
            [cell.lblPerMonth setTitle:obj.strPer_month forState:UIControlStateNormal];
            [cell.txtQty setText:obj.strQty];
            cell.btnForDecreaseQty.tag = indexPath.row;
            cell.btnForIncreaseQty.tag = indexPath.row;
            
            
            cell.btnTitle.tag = indexPath.row + 600;
            cell.btnImage.tag = indexPath.row + 600;
            cell.btnRemoveItem.tag = indexPath.row;

            cell.txtQty.tag = indexPath.row;
            if ([obj.strPlus_minue isEqualToString:@"1"]) {
                [cell.btnForIncreaseQty addTarget:self action:@selector(addQty:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnForDecreaseQty addTarget:self action:@selector(subQty:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [cell.btnForIncreaseQty setHidden : YES];
                [cell.btnForDecreaseQty setHidden : YES];
            }

            
            cell.btnRemoveItem.hidden = ([obj.strProduct_id isEqualToString:@""])? YES:NO;
            [cell.btnRemoveItem addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btnImage addTarget:self action:@selector(productDetailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnTitle addTarget:self action:@selector(productDetailButtonAction:) forControlEvents:UIControlEventTouchUpInside];

            
            return cell;
        }
        else if(indexPath.section == 1)
        {
            cell1.lblTitleForStep.text = [stepsDict objectForKeyNotNull:@"title" expectedClass:[NSString class]];
            cell1.lblForStep.text = [stepsDict objectForKeyNotNull:@"desc" expectedClass:[NSString class]];
//            cell1.btnForStep = [stepsDict objectForKeyNotNull:@"title" expectedClass:[NSString class]];
            return cell1;
        }
        else{
            PFQuotesListInfo *obj = [colSpamArray objectAtIndex:indexPath.row];
            
            cell2.btnTitle.tag = indexPath.row + 600;
            cell2.btnImage.tag = indexPath.row + 600;
            cell2.btnForTitle.tag = indexPath.row + 800;

            
            [cell.btnTitle setTitle:obj.strProduct_name forState:UIControlStateNormal];
            cell2.lblPrice.text = obj.strPrice;
            cell2.lblProductDesc.text = obj.strDesc;
            [cell2.btnPerMonth setTitle:obj.strPer_month forState:UIControlStateNormal];
            cell2.lblTitleAndFigure.text = [NSString stringWithFormat:@"%@ \n %@",obj.strTitle,obj.strFigure];
            [cell2.btnForText setTitle:obj.strCatText forState:UIControlStateNormal];
            [cell2.stepTwoProductImageView setImageWithURL:[NSURL URLWithString:obj.strProduct_image_urlEmail] placeholderImage:[UIImage imageNamed:@""]];

            [cell2.btnForTitle addTarget:self action:@selector(AddCartButtonAction:) forControlEvents:UIControlEventTouchUpInside];

            [cell2.btnImage addTarget:self action:@selector(productDetailSectionTwoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell2.btnTitle addTarget:self action:@selector(productDetailSectionTwoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell2.btnForText setTag:indexPath.row];
            [cell2.btnForText addTarget:self action:@selector(decline:) forControlEvents:UIControlEventTouchUpInside];
            
        return cell2;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableProduct)
    {
         return 35;
    }
    else if(tableView == self.tableView)
    {
  
       if (indexPath.section == 1)
       {
            return 120;
        }
       else
        {
            return UITableViewAutomaticDimension;
        }
    }
    else if(tableView == self.tblViewForNote){
    
        return UITableViewAutomaticDimension;
    }
    else if (tableView == self.squareTableView) {
        return UITableViewAutomaticDimension;
    }

    else
    {
        return 0;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.view endEditing:YES];
    if ([tableView isEqual:self.tableProduct]){
       PFQuotesProductListInfo *modelObject = [productDatasourceArray objectAtIndex:indexPath.row];
        if (![modelObject.strTitleID isEqualToString:@"#"]) {
            txtFieldForSearch.text = [NSString stringWithFormat:@"%@",modelObject.strTitleLable];
            productIdForAdd = modelObject.strTitleID;
            self.tableProduct.hidden = YES;
            [self.tableProduct reloadData];
        }
    }
}

#pragma mark - * * * TEXT FIELD DELEGATE METHOD * * * 
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];

    if ((str.length > 20 || !stringIsValid) && textField.tag == 300)
        return NO;

    if (textField == txtFieldForSearch)
    {
        productIdForAdd = @"";
        [self callAPIForProduct :str];
    }
    else if (textField.tag == 501) {
        NSString *newString = [_phoneTextField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        NSString *decimalString = [components componentsJoinedByString:@""];
        
        if (newString.length>14) {
            return NO;
        }
        
        NSUInteger length = decimalString.length;
        BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
        
        if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
            textField.text = decimalString;
            return NO;
        }
        
        NSUInteger index = 0;
        NSMutableString *formattedString = [NSMutableString string];
        
        //    if (hasLeadingOne) {
        //        [formattedString appendString:@"1 "];
        //        index += 1;
        //    }
        
        if (length - index > 3) {
            NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"(%@) ",areaCode];
            index += 3;
        }
        
        if (length - index > 3) {
            NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"%@-",prefix];
            index += 3;
        }
        
        NSString *remainder = [decimalString substringFromIndex:index];
        [formattedString appendString:remainder];
        
        textField.text = formattedString;
        
        return NO;
    }
   else if (textField.tag == 500 && str.length > 60)
    {
        return NO;
    }
   else if (textField.tag == 502 && str.length > 100)
   {
       return NO;
   }

    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    if (textField.tag == 300)
        textField.layer.borderColor = KHomeTextFieldBorderColor;
    //  textField.inputAccessoryView = toolBarForNumberPad(self,@"Done");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
//    if (textField.tag == 300) {
        textField.layer.borderColor = KHomeTextFieldGrayBorderColor;
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - * * * TEXT VIEW DELEGATE METHOD * * *

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    textView.layer.borderColor = KHomeTextFieldBorderColor;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    textView.layer.borderColor = KHomeTextFieldGrayBorderColor;
}


#pragma mark - Selector Method

- (void)productDetailButtonAction:(UIButton*)sender {
    
    PFQuotesListInfo *obj = [itemArray objectAtIndex:sender.tag-600];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.strProduct_detail_url]];

}

- (void)productDetailSectionTwoButtonAction:(UIButton*)sender {
    
    PFQuotesListInfo *obj = [colSpamArray objectAtIndex:sender.tag-600];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.strProduct_detail_url]];
    
}

- (void)AddCartButtonAction:(UIButton*)sender {
    
    PFQuotesListInfo *obj = [colSpamArray objectAtIndex:sender.tag-800];
    
    [self callAPIForAddCart:obj.strProduct_id];
}


-(void)afterSomeTime
{
    float height = self.tableFooterView.layer.frame.size.height - (viewheight+200-bottomButtonViewheight);
    NSLog(@"%f",viewheight);
    NSLog(@"%f",self.tableView.contentSize.height);

    if (viewheight == 0) {
        self.tableHeight.constant = self.tableView.contentSize.height;
        [self.tableFooterView setFrame:CGRectMake(0, 0,0,0)];
        self.tableView.tableFooterView = self.tableFooterView;
        self.tableView.tableFooterView = nil;
//        self.tableView.borderColor = [UIColor clearColor];

    }else{
        self.tableHeight.constant = self.tableView.contentSize.height-height+10;
        [self.tableFooterView setFrame:CGRectMake(0, 0, self.tableView.layer.frame.size.width,self.tableFooterView.layer.frame.size.height-height)];
        self.tableView.tableFooterView =self.tableFooterView;
    }
    
    self.notesHeightConstraint.constant = self.tblViewForNote.contentSize.height;

    float scrollViewHeightOfLeftTableView = self.tableView.contentSize.height + + self.tableView.frame.origin.y;
    float scrollViewHeightOfRightTableView = self.tblViewForNote.contentSize.height + self.tblViewForNote.frame.origin.y;
    
    float scrollHeight = MAX(scrollViewHeightOfLeftTableView, scrollViewHeightOfRightTableView);
    
    [self.heightConstraintView setConstant:scrollHeight - windowHeight + 90];
}


- (void)afterSomeTimeForSquareFoot {
    
    if (self.squareTableView.contentSize.height <= 150) {
        self.squareFootTableViewHeightConstraint.constant = self.squareTableView.contentSize.height + 70;
    }else
        self.squareFootTableViewHeightConstraint.constant = 150;
}


- (void)viewDidLayoutSubviews {
    
    self.notesHeightConstraint.constant = self.tblViewForNote.contentSize.height;

}

-(IBAction)addQty:(UIButton *)sender
{
    [self.view endEditing:YES];
    PFQuotesListInfo *obj = [itemArray objectAtIndex:sender.tag];
    NSString *xyz = [NSString stringWithFormat:@"%ld",[obj.strQty integerValue] + 1];
    obj.strQty = xyz;
    [self callAPIForPluseORMinusItemsQtys ];
   // [self.tableView reloadData];
}

-(IBAction)subQty:(UIButton *)sender
{
    [self.view endEditing:YES];
    PFQuotesListInfo *obj = [itemArray objectAtIndex:sender.tag];
 if ([obj.strQty integerValue] > 1)
 {
    NSString *xyz = [NSString stringWithFormat:@"%ld",[obj.strQty integerValue] - 1];
    obj.strQty = xyz;
     [self callAPIForPluseORMinusItemsQtys ];
   // [self.tableView reloadData];
 }
}

-(IBAction)removeItem:(UIButton *)sender{
    [self.view endEditing:YES];
    PFQuotesListInfo *obj = [itemArray objectAtIndex:sender.tag];
    [self callAPIForRemoveItem:obj.strProduct_id];
}
-(IBAction)decline:(UIButton *)sender{
    PFQuotesListInfo *obj = [colSpamArray objectAtIndex:sender.tag];
    [self callAPIForDeclineItem: obj.strProduct_id :obj.strCatProductsAr];
    
}


-(void)hideShowLogoutView {
    
    isAnimated = NO;
    [self.logOutViewHeightConstraint setConstant:0];
    [self.logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
}

#pragma mark - * * * BUTTON ACTION * * *

- (IBAction)btnForAddAction:(id)sender
{
    [self.view endEditing:YES];
    if (productIdForAdd.length)
    {
        [self callAPIForAddItem];
    }
    else
    {
          [PFUtility alertWithTitle:@"" andMessage:@"Please select a product."  andController:self];
    }
}
- (IBAction)menuButtonACtion:(id)sender
{
    [self.view endEditing:YES];
//    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}
- (IBAction)btnSaveAction:(id)sender {
    [self.view endEditing:YES];
    if (txtViewNotes.text.length){
        [self callAPIForAddNotes:@"0"];
    }
    else{
        [PFUtility alertWithTitle:@"" andMessage:@"Please enter notes." andController:self];
    }
}

- (IBAction)btnSaveEmailAction:(id)sender {
    
    [self.view endEditing:YES];
    if (_txtViewEmail.text.length){
        [self callAPIForAddNotes:@"1"];
    }
    else{
        [PFUtility alertWithTitle:@"" andMessage:@"Please enter notes." andController:self];
    }
}





- (IBAction)btnSearchAddressAction:(id)sender {

    [self.view endEditing:YES];
    if (!txtAddressField.text.length && !txtSquareField.text.length)
    {
        [PFUtility alertWithTitle:@"" andMessage:@"Please enter square footage or address." andController:self];
    }
    else
    {
        [self callAPIForSqrFootage];
    }
}

- (IBAction)signOutButtonAction:(id)sender {
    
    [UIView transitionWithView:self.view duration:0.1 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        if (isAnimated == NO) {
                            isAnimated = YES;
                            [self.logOutViewHeightConstraint setConstant:69];
                            [self.logOutView setHidden:NO];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }else{
                            isAnimated = NO;
                            [self.logOutViewHeightConstraint setConstant:0];
                            [self.logOutView setHidden:YES];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }
                    }
                    completion:^(BOOL finished) {
                    }];
}


- (IBAction)logOutButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callLogoutServiceIntegration];
        }
    }];
}

- (IBAction)changePasswordButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)buildQuoteButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    
    if (!self.zipCodeTextField.text.length) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
    }
    else if (self.zipCodeTextField.text.length < 4) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
    }
    else {
        
        [self.view endEditing:YES];
        
        if (!self.zipCodeTextField.text.length) {
            
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
        }
        else if (self.zipCodeTextField.text.length < 4) {
            
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
        }
        else {
            PFBuildQuoteVC *objVC = [[PFBuildQuoteVC alloc]initWithNibName:@"PFBuildQuoteVC" bundle:nil];
            objVC.providesPresentationContextTransitionStyle = YES;
            objVC.definesPresentationContext = YES;
            objVC.zipCode = self.zipCodeTextField.text;
            objVC.delegate = self;
            [objVC setModalPresentationStyle:
             UIModalPresentationOverCurrentContext];
            [self.navigationController presentViewController:objVC animated:NO completion:nil];
        }
    }
}


- (IBAction)createPdfButtonAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:quoteObject.strPdfUrl]];

}

- (IBAction)sendEmailButtonAction:(id)sender {
    
    [self callAPIForSendCartQuote];
}

- (IBAction)sendQuoteButtonAction:(id)sender {
    
    PFSendQuoteFromEditViewController *sendQuotesVC = [[PFSendQuoteFromEditViewController alloc] initWithNibName:@"PFSendQuoteFromEditViewController" bundle:nil];
    sendQuotesVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:sendQuotesVC animated:YES completion:nil];
}


- (IBAction)techCheckSuggestionButtonAction:(UIButton *)sender {
    
    [self.tooltipManager addTooltipWithTargetView:sender hostView:self.view tooltipText:@"This will autoload the TechCheck Verification into the customers cart." arrowDirection:JDFTooltipViewArrowDirectionUp width:200.0f];
    
    [self.tooltipManager showNextTooltip];

}

- (IBAction)quotesSuggestionButtonAction:(UIButton *)sender {
    
    [self.tooltipManager addTooltipWithTargetView:sender hostView:self.view tooltipText:@"Select coupon if the user is NOT expecting a quote from you." arrowDirection:JDFTooltipViewArrowDirectionUp width:200.0f];
    
    
    [self.tooltipManager showNextTooltip];
}


- (IBAction)techCheckNoButtonAction:(id)sender {
    
    self.techCheckNoButton.selected = YES;
    self.techCheckYesButton.selected = NO;

}

- (IBAction)techCheckYesButtonAction:(id)sender {
    
    self.techCheckNoButton.selected = NO;
    self.techCheckYesButton.selected = YES;
}

- (IBAction)quoteCouponButtonAction:(id)sender {
    
    self.quotesCouponButton.selected = YES;
    self.quotesButton.selected = NO;
}

- (IBAction)quotesButtonAction:(id)sender {
    
    self.quotesButton.selected = YES;
    self.quotesCouponButton.selected = NO;
}


#pragma mark - Service Helper Method

//SEARCH PRODUCT

-(void)callAPIForProduct:(NSString*)searchText{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"productQuickLookup"forKey:@"action"];
    [dict setValue:searchText forKey:@"term"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {

                [productDatasourceArray removeAllObjects];
                NSArray *customerList = [response objectForKeyNotNull:@"product" expectedClass:[NSArray class]];
                
                for (NSMutableDictionary *productDict in customerList)
                {
                    PFQuotesProductListInfo *inspectionInfo = [PFQuotesProductListInfo modelProductListDict:productDict];
                    [productDatasourceArray addObject:inspectionInfo];
                }
                if (productDatasourceArray.count) {
                    self.tableProduct.hidden=NO;
                    self.tableProduct.dataSource = self;
                    self.tableProduct.delegate = self;
                    [self.tableProduct reloadData];
                }
            }
            else {
                [productDatasourceArray removeAllObjects];
                self.tableProduct.hidden = YES;
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

//ADD PRODUCT
-(void)callAPIForAddItem{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"addCart"forKey:@"action"];
    [dict setValue:productIdForAdd forKey:@"product_id"];
    [dict setValue:_strQuoteId forKey:@"quote_id"];
    [dict setValue:@"" forKey:@"is_install"];

    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                txtFieldForSearch.text = @"";
                productIdForAdd = @"";
                [self callAPIForGetQuotesList];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:kResponseMessage  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

-(void)callAPIForGetQuotesList
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"editQuote" forKey:@"action"];
    [dict setObject:self.strQuoteId forKey:@"quote_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {

        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {

                [itemArray removeAllObjects];
                [colSpamArray removeAllObjects];
                NSDictionary *ListInfo = [response objectForKeyNotNull:@"responssData" expectedClass:[NSDictionary class]];
//BASIC INFORMATION
                
                
                if ([[ListInfo objectForKeyNotNull:@"customer_name" expectedClass:[NSString class]] isEqualToString:@""] || [[ListInfo objectForKeyNotNull:@"customer_email" expectedClass:[NSString class]] isEqualToString:@""] || [[ListInfo objectForKeyNotNull:@"customer_phone" expectedClass:[NSString class]] isEqualToString:@""]) {
                    
                }else{
                    self.callBacklabel.hidden = NO;
                    self.emailBasicLabel.hidden = NO;
                    lblName.text = [ListInfo objectForKeyNotNull:@"customer_name" expectedClass:[NSString class]];
                    lblEmail.text = [ListInfo objectForKeyNotNull:@"customer_email" expectedClass:[NSString class]];
                    lblCallBack.text = [ListInfo objectForKeyNotNull:@"customer_phone" expectedClass:[NSString class]];
            }
            
                lblDistance.text = [ListInfo objectForKeyNotNull:@"distance" expectedClass:[NSString class]];
                lblFranchuseName.text = [ListInfo objectForKeyNotNull:@"franchise" expectedClass:[NSString class]];
                lblOwnerName.text = [ListInfo objectForKeyNotNull:@"owner" expectedClass:[NSString class]];
                lblPhoneNumber.text = [ListInfo objectForKeyNotNull:@"website_phone" expectedClass:[NSString class]];
//ITEMS ARRAY
                NSArray *quotesArray = [ListInfo objectForKeyNotNull:@"item" expectedClass:[NSArray class]];
                for (NSDictionary *quotesDict in quotesArray)
                {
                    PFQuotesListInfo *quotesInfo = [PFQuotesListInfo getItemsForEdit:quotesDict];
                    [itemArray addObject:quotesInfo];
                }
//COLSPAMS ARRAY
                NSArray *colSpam = [ListInfo objectForKeyNotNull:@"colspans" expectedClass:[NSArray class]];
                for (NSDictionary *quotesDict in colSpam)
                {
                    PFQuotesListInfo *quotesInfo = [PFQuotesListInfo getColSpamList:quotesDict];
                    [colSpamArray addObject:quotesInfo];
                }
//STEP DICTIONARY
                stepsDict = [ListInfo objectForKeyNotNull:@"steps" expectedClass:[NSDictionary class]];
//AMOUNTS DICTIONARY
                NSDictionary *amount = [ListInfo objectForKeyNotNull:@"amounts" expectedClass:[NSDictionary class]];
                lblEquipment.text = [amount objectForKeyNotNull:@"equipment" expectedClass:[NSString class]];
                lblInstallationKit.text = [amount objectForKeyNotNull:@"installation_kits" expectedClass:[NSString class]];
                lblLabour.text = [amount objectForKeyNotNull:@"labor" expectedClass:[NSString class]];
                lblTotal.text = [amount objectForKeyNotNull:@"total" expectedClass:[NSString class]];
                lblSaveAmountText.text = [amount objectForKeyNotNull:@"saving_amount" expectedClass:[NSString class]];

                if ([amount allKeys].count)
                {
                    lblTotleForHide.hidden = NO;
                    lblLabourForHide.hidden = NO;
                    lblInstallationKitForHide.hidden = NO;
                    lblEquipmentForHide.hidden = NO;
                }
//CARD
                NSDictionary *card = [ListInfo objectForKeyNotNull:@"cards" expectedClass:[NSDictionary class]];
                [imgCard1 setImageWithURL:[NSURL URLWithString:[card objectForKeyNotNull:@"card1" expectedClass:[NSString class]]]];
                [imgCard2 setImageWithURL: [NSURL URLWithString:[card objectForKeyNotNull:@"card2" expectedClass:[NSString class]]]];
                [imgCard3 setImageWithURL :[NSURL URLWithString:[card objectForKeyNotNull:@"card3" expectedClass:[NSString class]]]];
                [imgCard4 setImageWithURL :[NSURL URLWithString:[card objectForKeyNotNull:@"card4" expectedClass:[NSString class]]]];
//Bottom View
                NSDictionary *optionsDict = [ListInfo objectForKeyNotNull:@"options" expectedClass:[NSDictionary class]];
                
                if ([optionsDict count]) {
                    self.tableView.tableFooterView = self.tableFooterView;
                    self.optionLabel.hidden = NO;
                    self.footerOptionView.hidden = NO;
                }else {
                    
                    self.optionLabel.hidden = YES;
                    self.footerOptionView.hidden = YES;
                    btnFirst.hidden = YES;
                    [self.tableFooterView setFrame:CGRectMake(0, 0,0,0)];
                    self.tableView.tableFooterView = self.tableFooterView;
                    self.tableView.tableFooterView = nil;
                }
                
                if (![[optionsDict objectForKeyNotNull:@"create_pdf" expectedClass:[NSString class]] isEqualToString:@""]) {
                    self.buttonThird.hidden = NO;
                    quoteObject.strPdfUrl = [optionsDict objectForKeyNotNull:@"create_pdf" expectedClass:[NSString class]];
                }
                else{
                    bottomButtonViewheight = bottomButtonViewheight + 40.0;
                    self.buttonThirdHeightConstraint.constant = 0.0;
                    self.buttonThird.hidden = YES;
                }
                
                viewheight = 0.0;
                bottomButtonViewheight = 0.0;

                if (![[optionsDict objectForKeyNotNull:@"title1" expectedClass:[NSString class]] isEqualToString:@""] && ![[optionsDict objectForKeyNotNull:@"title2" expectedClass:[NSString class]] isEqualToString:@""]) {
                    
                    viewTechCheck.hidden = NO;
                    viewSelectQuotes.hidden = NO;
                    viewheight = viewheight + 150.0;
                    self.techCheckLabel.text = [optionsDict objectForKeyNotNull:@"title1" expectedClass:[NSString class]];
                    self.quoteLabel.text = [optionsDict objectForKeyNotNull:@"title2" expectedClass:[NSString class]];
                    
                    if ([[optionsDict objectForKeyNotNull:@"checked1_yes" expectedClass:[NSString class]] isEqualToString:@"1"]) {
                        self.techCheckYesButton.selected = YES;
                        self.techCheckNoButton.selected = NO;
                    }
                    else{
                        self.techCheckNoButton.selected = YES;
                        self.techCheckYesButton.selected = NO;
                    }

                    if ([[optionsDict objectForKeyNotNull:@"checked2_coupon" expectedClass:[NSString class]] isEqualToString:@"1"]){
                        self.quotesCouponButton.selected = YES;
                        self.quotesButton.selected = NO;
                    }
                    else{
                        self.quotesButton.selected = YES;
                        self.quotesCouponButton.selected = NO;
                    }
                }
                else {
                    if (![[optionsDict objectForKeyNotNull:@"title1" expectedClass:[NSString class]] isEqualToString:@""]) {
                        
                       // self.bottomMainViewHeightConstraint.constant = 205.0;
                        self.quoteHeightConstraint.constant = 0.0;
                        viewheight = viewheight + 80.0;
                        self.techCheckLabel.text = [optionsDict objectForKeyNotNull:@"title1" expectedClass:[NSString class]];
                        
                        if ([[optionsDict objectForKeyNotNull:@"checked1_yes" expectedClass:[NSString class]] isEqualToString:@"1"]) {
                            self.techCheckYesButton.selected = YES;
                            self.techCheckNoButton.selected = NO;
                        }
                        else{
                            self.techCheckNoButton.selected = YES;
                            self.techCheckYesButton.selected = NO;
                        }

                        
                        viewTechCheck.hidden = NO;
                        viewSelectQuotes.hidden = YES;
                    }
                    else if (![[optionsDict objectForKeyNotNull:@"title2" expectedClass:[NSString class]] isEqualToString:@""]) {
                        
                        viewheight = viewheight + 80.0;
                        self.techViewHeightConstraint.constant = 0.0;

                        self.quoteLabel.text = [optionsDict objectForKeyNotNull:@"title2" expectedClass:[NSString class]];
                        
                        if ([[optionsDict objectForKeyNotNull:@"checked2_coupon" expectedClass:[NSString class]] isEqualToString:@"1"]){
                            self.quotesCouponButton.selected = YES;
                            self.quotesButton.selected = NO;
                        }
                        else{
                            self.quotesButton.selected = YES;
                            self.quotesCouponButton.selected = NO;
                        }

                        viewTechCheck.hidden = YES;
                        viewSelectQuotes.hidden = NO;
                    }
                }
                
                if (![[optionsDict objectForKeyNotNull:@"address" expectedClass:[NSString class]] isEqualToString:@""]) {
                    
                    viewheight = viewheight + 45.0;
                    self.addressTextField.hidden = NO;
                    self.addressTextField.text = [optionsDict objectForKeyNotNull:@"address" expectedClass:[NSString class]];
                }else
                    self.addressHeightConstraint.constant = 0.0;
                
                
                if (![[optionsDict objectForKeyNotNull:@"email" expectedClass:[NSString class]] isEqualToString:@""] && ![[optionsDict objectForKeyNotNull:@"phone" expectedClass:[NSString class]] isEqualToString:@""]) {
                    self.emailTextfield.text = [optionsDict objectForKeyNotNull:@"email" expectedClass:[NSString class]];
                    self.phoneTextField.text = [optionsDict objectForKeyNotNull:@"phone" expectedClass:[NSString class]];
                    viewheight = viewheight + 76.0;
                    self.emailTextfield.hidden = NO;
                    self.phoneTextField.hidden = NO;
                }
                else if ([[optionsDict objectForKeyNotNull:@"email" expectedClass:[NSString class]] isEqualToString:@""] && ![[optionsDict objectForKeyNotNull:@"phone" expectedClass:[NSString class]] isEqualToString:@""]) {
                    
                    self.phoneTextField.text = [optionsDict objectForKeyNotNull:@"phone" expectedClass:[NSString class]];
                    self.emailHeightConstraint.constant = 0.0;

                    viewheight = viewheight + 40.0;

                    self.emailTextfield.hidden = YES;
                    self.phoneTextField.hidden = NO;
                }
                else if (![[optionsDict objectForKeyNotNull:@"email" expectedClass:[NSString class]] isEqualToString:@""] && [[optionsDict objectForKeyNotNull:@"phone" expectedClass:[NSString class]] isEqualToString:@""]) {
                    
                    self.emailTextfield.text = [optionsDict objectForKeyNotNull:@"email" expectedClass:[NSString class]];
                    self.phoneHeightTopconstraint.constant = 0.0;
                    viewheight = viewheight + 40.0;
                    self.emailTextfield.hidden = NO;
                    self.phoneTextField.hidden = YES;
                }else {
                    self.phoneHeightTopconstraint.constant = 0.0;
                    self.emailHeightConstraint.constant = 0.0;
                    self.emailTextfield.hidden = YES;
                    self.phoneTextField.hidden = YES;
                }
                
                if (![[optionsDict objectForKeyNotNull:@"action_btn" expectedClass:[NSString class]] isEqualToString:@""]) {
                    
                    buttonSecond.hidden = NO;
                    self.optionLabel.hidden = YES;
                    self.footerOptionView.borderColor = [UIColor clearColor];
                    btnFirst.hidden = YES;
                    
                    self.emailTextfield.userInteractionEnabled = NO;
                    [buttonSecond setTitle:[optionsDict objectForKeyNotNull:@"action_btn" expectedClass:[NSString class]] forState:UIControlStateNormal];
                }else{
                    if ([optionsDict count]) {
                        btnFirst.hidden = NO;
                    }
                    else {
                        btnFirst.hidden = YES;
                        bottomButtonViewheight = bottomButtonViewheight + 40.0;
                    }
                    
                    self.footerOptionView.layer.borderColor = KHomeTextFieldGrayBorderColor;
                    self.footerOptionView.layer.borderWidth = 1.0;
                    bottomButtonViewheight = bottomButtonViewheight + 40.0;
                    self.buttonSecondHeightConstraint.constant = 0.0;
                    
                    self.emailTextfield.userInteractionEnabled = YES;
                }
                
                self.bottomMainViewHeightConstraint.constant = viewheight+20;
                self.footerViewHeightConstraint.constant = viewheight+120;

//NOTE ARRAY
                [noteArray removeAllObjects];
                NSArray *notesTempArray = [ListInfo objectForKeyNotNull:@"notes" expectedClass:[NSArray class]];
                
                for (NSDictionary *dict in notesTempArray) {

                    PFQuotesListInfo *quotesInfo = [PFQuotesListInfo getNotesList:dict];
                    [noteArray addObject:quotesInfo];
                    
                }
                
                if ([noteArray count])
                    self.tblViewForNote.hidden = NO;

                [self.tableView reloadData];
                [self.tblViewForNote reloadData];
                
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:kResponseMessage  andController:self];

            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

-(void)callAPIForPluseORMinusItemsQtys{
    {
        NSMutableArray * productIds = [NSMutableArray new];
        NSMutableArray * qts = [NSMutableArray new];
        NSMutableDictionary *dict = [NSMutableDictionary new];
        for (int i = 0; i < itemArray.count ; i++)
        {
            PFQuotesListInfo *obj = [itemArray objectAtIndex:i];
            [productIds addObject:obj.strProduct_id];
            [qts addObject:obj.strQty];
        }

        [dict setObject:@"updateCartItems" forKey:@"action"];
        [dict setObject:self.strQuoteId forKey:@"quote_id"];
        [dict setObject:productIds forKey:@"product_ids"];
        [dict setObject:qts forKey:@"qtys"];

        [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {

            if (suceeded)
            {
                if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
                {
                    [self callAPIForGetQuotesList];
                }
                else
                {
                    
                }
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }];
    }
}

-(void)callAPIForRemoveItem :(NSString *)productId{
    {

        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:@"removeCart" forKey:@"action"];
        [dict setObject:self.strQuoteId forKey:@"quote_id"];
        [dict setObject:productId forKey:@"product_id"];

        [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
            
            if (suceeded)
            {
                if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
                {
                    [self callAPIForGetQuotesList];
                }
                else
                {
                    [PFUtility alertWithTitle:@"" andMessage:kResponseMessage  andController:self];
                }
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }];
    }
}

-(void)callAPIForAddNotes:(NSString*)status
{
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:@"saveQuoteNotes" forKey:@"action"];
        [dict setObject:self.strQuoteId forKey:@"quote_id"];
        [dict setObject:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
        if ([status isEqualToString:@"1"])
            [dict setObject:_txtViewEmail.text forKey:@"notes"];
        else
            [dict setObject:txtViewNotes.text forKey:@"notes"];
    
        [dict setObject:status forKey:@"include_in_email"];
    
        [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {

            if (suceeded)
            {
                if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
                {
                    [txtViewNotes setText : @""];
                    [_txtViewEmail setText : @""];

                    [self callAPIForGetQuotesList];
                }
                else
                {

                }
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }];
}


-(void)callLogoutServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"userLogout"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    [dict setValue:@"ios" forKey:@"deviceType"];
    if ([NSUSERDEFAULTS objectForKey:kDeviceToken] == nil) {
        [dict setValue:@"" forKey:@"deviceToken"];
    }else{
        [dict setValue:[NSUSERDEFAULTS objectForKey:kDeviceToken] forKey:@"deviceToken"];
    }
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                [APPDELEGATE  navigateToLoginVC];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
    }];
}


-(void)callAPIForSqrFootage
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"getBySqrFootage" forKey:@"action"];
    [dict setObject:self.strQuoteId forKey:@"quote_id"];
    [dict setObject:txtAddressField.text forKey:@"address"];
    [dict setObject:txtSquareField.text forKey:@"sq_footage"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {

        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [squareFootDatasourceArray removeAllObjects];
                [squareFootDatasourceArray addObjectsFromArray:[response objectForKeyNotNull:@"responseData" expectedClass:[NSArray class]]];
                
                if (squareFootDatasourceArray.count) {
                    self.squareTableView.hidden = NO;
                }
                else
                    self.squareTableView.hidden = YES;

                [self.squareTableView reloadData];
                [self performSelector:@selector(afterSomeTimeForSquareFoot) withObject:self afterDelay:0.1];
            }
            else
            {
                [squareFootDatasourceArray removeAllObjects];
                [self performSelector:@selector(afterSomeTimeForSquareFoot) withObject:self afterDelay:0.1];
                [self.squareTableView reloadData];
                [PFUtility alertWithTitle:@"" andMessage:kResponseMessage  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

-(void)callAPIForDeclineItem:(NSString *)productId :(NSString *)productAr
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"declineOptionalComp" forKey:@"action"];
    [dict setObject:self.strQuoteId forKey:@"quote_id"];
    [dict setObject:productAr forKey:@"cat_products_ar"];
    [dict setObject:@"1" forKey:@"just_once"];
    [dict setObject:productId forKey:@"product_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [self callAPIForGetQuotesList];
            }
            else
            {

            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


-(void)callAPIForAddCart:(NSString *)productId
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"addCart" forKey:@"action"];
    [dict setObject:_strQuoteId forKey:@"quote_id"];
    [dict setObject:productId forKey:@"product_id"];
    [dict setObject:@"0" forKey:@"is_install"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [self callAPIForGetQuotesList];
            }
            else
            {
                
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



-(void)callAPIForSendCartQuote
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setObject:@"sendCartQuote" forKey:@"action"];
    [dict setObject:_strQuoteId forKey:@"quote_id"];
    [dict setObject:self.emailTextfield.text forKey:@"options_email"];
    [dict setObject:self.phoneTextField.text forKey:@"options_phone"];
    [dict setObject:self.addressTextField.text forKey:@"options_address"];
    [dict setObject:(self.quotesCouponButton.selected)?@"1":@"0" forKey:@"checked2_coupon"];
    [dict setObject:(self.techCheckYesButton.selected)?@"1":@"0" forKey:@"is_onsite_review"];


    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:kResponseMessage andController:self];

            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

#pragma mark - Memory Management method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
