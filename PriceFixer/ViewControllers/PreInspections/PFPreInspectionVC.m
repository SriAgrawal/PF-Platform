//
//  PFPreInspectionVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 03/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFPreInspectionVC.h"
static NSString * cellIdentifier = @"PFPreinspectionCell";


@interface PFPreInspectionVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate>{
    NSMutableArray *preInspectionDatasourceArray;
}
@property (weak, nonatomic) IBOutlet UITableView *inspectionTableView;


@end

@implementation PFPreInspectionVC


#pragma mark - View Controller life cycle method
- (void)viewDidLoad{
    [super viewDidLoad];
    [_inspectionTableView registerNib:[UINib nibWithNibName:@"PFPreinspectionCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    preInspectionDatasourceArray = [[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refershPreInspectioList:)
                                                 name:@"refershPreInspectionList" object:nil];
    
    [self callgetPreInspectionServiceIntegration];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return preInspectionDatasourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFPreinspectionCell * cell = (PFPreinspectionCell *)[self.inspectionTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFPreInspectionModel *inspectionInfo = [preInspectionDatasourceArray objectAtIndex:indexPath.row];
    [cell.lblUserName setText:inspectionInfo.strShippingName];
    [cell.lblContactNumber setText:inspectionInfo.strShippingPhone];
    [cell.lblAddress setText:[NSString stringWithFormat:@"%@ , %@ , %@, %@",inspectionInfo.strShippingAddress1,inspectionInfo.strShippingCity,inspectionInfo.strShippingState,inspectionInfo.strShippingZip]];
    [cell.lblInspectionStatus setText:inspectionInfo.strOrderStatus];
    [cell.lblOrderId setText:inspectionInfo.strOrderCode];
    [cell.productCollectionView setTag:indexPath.row];
    [cell.productCollectionView setDataSource:self];
    [cell.productCollectionView setDelegate:self];
    
    [cell.productCollectionView reloadData];
    
    cell.productCollectionView.contentOffset = inspectionInfo.collectionViewContentOffset;
    
    if (inspectionInfo.strAptId == nil || [inspectionInfo.strAptId isEqualToString:@""]){
        [cell.lblApointmentID setHidden:YES];
        [cell.btnClickPreInspection setHidden:NO];
        [cell.viewSingleButton setHidden:NO];
        [cell.viewShowContrct setHidden:YES];

    }else{
        [cell.lblApointmentID setText:inspectionInfo.strAptDate];
        [cell.lblApointmentID setHidden:NO];
        [cell.btnClickPreInspection setHidden:YES];
        [cell.viewSingleButton setHidden:YES];
        [cell.viewShowContrct setHidden:NO];
    }
    
    [cell.btnClickPreInspection addTarget:self action:@selector(preInspectionBtnAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCreateAppoinment addTarget:self action:@selector(createBtnAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnViewContract addTarget:self action:@selector(btnViewContractAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btncancelAndRefund addTarget:self action:@selector(btncancelAndRefundAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCommunication addTarget:self action:@selector(btnCommunicationAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEditAddress addTarget:self action:@selector(btnEditAddressAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEditAppoinment addTarget:self action:@selector(btnEditAppoinmentAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addNewProductBtn addTarget:self action:@selector(addNewProductBtnAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 395.f;
}



-(void)tableView:(UITableView *)tableView willDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFPreinspectionCell * productCell =  (PFPreinspectionCell*)cell;
    [productCell.productCollectionView reloadData];
}

#pragma mark -

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PFPreInspectionModel *inspectionInfo = [preInspectionDatasourceArray objectAtIndex:collectionView.tag];
    return inspectionInfo.arrayItems.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PFProdeuctCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PFProdeuctCell" forIndexPath:indexPath];
    
    cell.btnDelete.indexPath = indexPath;
    cell.btnDelete.collectionView = collectionView;
    cell.btnEdit.indexPath = indexPath;
    cell.btnEdit.collectionView = collectionView;
    
    PFPreInspectionModel *inspectionInfo = [preInspectionDatasourceArray objectAtIndex:collectionView.tag];
    
    PFPreInspectionModel *inspectionInfoObj = [inspectionInfo.arrayItems objectAtIndex:indexPath.row];
    
    if (indexPath.item+1==inspectionInfo.arrayItems.count) {
        
        [cell.imgProduct setImageWithURL:[NSURL URLWithString:inspectionInfoObj.strInstallImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.lblProductName setText:@"Installation"];
        
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Hours : %@",inspectionInfoObj.strInstallHour]];
        [strAttributed addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:14.0]
                      range:NSMakeRange(0, 6)];
        
        [cell.lblQty setAttributedText:strAttributed];
        [cell.btnDelete setHidden:YES];
        
        if (inspectionInfo.strAptId == nil || [inspectionInfo.strAptId isEqualToString:@""]){
            [cell.btnEdit setHidden:YES];

        }else{
            [cell.btnEdit setHidden:NO];

        }
        

        [cell.btnEdit addTarget:self action:@selector(editBtnAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        
        [cell.imgProduct setImageWithURL:[NSURL URLWithString:inspectionInfoObj.strProductImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.lblProductName setText:inspectionInfoObj.strProductTitle];
        
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Qty: %@",inspectionInfoObj.strQty]];
        [strAttributed addAttribute:NSFontAttributeName
                              value:[UIFont boldSystemFontOfSize:14.0]
                              range:NSMakeRange(0, 3)];
        
        if (inspectionInfo.arrayItems.count <= 2) {
            [cell.btnDelete setHidden:YES];
        }else{
            [cell.btnDelete setHidden:NO];
        }
        [cell.btnEdit setHidden:YES];


        [cell.lblQty setAttributedText:strAttributed];
        [cell.btnDelete addTarget:self action:@selector(deleteBtnAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }

    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(280, 270);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath=%@",indexPath);
}

#pragma mark - ScrollView delegete
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     if ([scrollView isKindOfClass:[UICollectionView class]]) {
         UICollectionView *coln = (UICollectionView *)scrollView;
         PFPreInspectionModel *inspectionInfo = [preInspectionDatasourceArray objectAtIndex:coln.tag];
         inspectionInfo.collectionViewContentOffset = coln.contentOffset;
     }
}
#pragma mark -

#pragma mark - IBActions
- (IBAction)menuButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.sidePanelController toggleLeftPanel:nil];
}

- (void)refershPreInspectioList:(NSNotification *)note {
    [self callgetPreInspectionServiceIntegration];
}


- (IBAction)navBtnQueryAction:(UIButton *)sender {
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress." onController:self];
}

- (IBAction)navBtnAction:(UIButton *)sender {
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress." onController:self];
}

- (IBAction)btnChangePasswordAction:(UIButton *)sender {
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress." onController:self];
}

-(void)editBtnAction:(TAIndexPathButton *)button withEvent:(UIEvent *)event{
    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:button.collectionView.tag];
  
    PFChangeInstallationHourVC *objVC = [[PFChangeInstallationHourVC alloc]initWithNibName:@"PFChangeInstallationHourVC" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];

    
    
}

- (void)deleteBtnAction:(TAIndexPathButton *)button withEvent:(UIEvent *)event{

    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:button.collectionView.tag];
    PFPreInspectionModel *inspectionInfoObj = [obj.arrayItems objectAtIndex:button.indexPath.row];
    
    [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Are you sure you want to remove this record?" andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callDeleteProductServiceIntegration:inspectionInfoObj.strDeletedId];
        }
    }];
  

}


- (void)addNewProductBtnAction:(UIButton *)button withEvent:(UIEvent *)event{
    NSIndexPath * indexPath = [self.inspectionTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.inspectionTableView]];
    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:indexPath.row];

    PFAddLineItemVC *objVC = [[PFAddLineItemVC alloc]initWithNibName:@"PFAddLineItemVC" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.strParentOrderId = obj.strParentOrderId;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];

}


- (void)preInspectionBtnAction:(UIButton *)button withEvent:(UIEvent *)event
{
    
    NSIndexPath * indexPath = [self.inspectionTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.inspectionTableView]];
    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:indexPath.row];
    
    createAppointmentViewController *objVC = [[createAppointmentViewController alloc]initWithNibName:@"createAppointmentViewController" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.isFromCreateAppointmentBtn = NO;
    objVC.strScreenIndicator=@"preinspection";
    objVC.strAppOrderCode = obj.strOrderCode;
    objVC.strAppCustomerId = obj.strCustomerId;
    objVC.strAppShopId = obj.strShopId;
    objVC.strAppOrderId = obj.strOrderId;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (void)createBtnAction:(UIButton *)button withEvent:(UIEvent *)event{
    
    NSIndexPath * indexPath = [self.inspectionTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.inspectionTableView]];
    
    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:indexPath.row];
    communicationQuoteViewController *objVC = [[communicationQuoteViewController alloc]initWithNibName:@"communicationQuoteViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.strEmployeId = obj.strCustomerId;
    objVC.strOrderCode = obj.strOrderCode;
    
    
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (void)btnViewContractAction:(UIButton *)button withEvent:(UIEvent *)event{
    NSIndexPath * indexPath = [self.inspectionTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.inspectionTableView]];
    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:indexPath.row];
    PFOrderInvoiceVC *objVC = [[PFOrderInvoiceVC alloc]initWithNibName:@"PFOrderInvoiceVC" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.strOrderId = obj.strOrderId;
    objVC.strAppoinmentId = obj.strAptId;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];

}



- (void)btncancelAndRefundAction:(UIButton *)button withEvent:(UIEvent *)event{
    NSIndexPath * indexPath = [self.inspectionTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.inspectionTableView]];
    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:indexPath.row];
    
    [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Are you sure you want to cancel this order?" andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callCancelOrderServiceIntegration:obj.strParentOrderId customerId:obj.strCustomerId];

        }
    }];
}

- (void)btnCommunicationAction:(UIButton *)button withEvent:(UIEvent *)event
{
    NSIndexPath * indexPath = [self.inspectionTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.inspectionTableView]];
    
    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:indexPath.row];
    communicationQuoteViewController *objVC = [[communicationQuoteViewController alloc]initWithNibName:@"communicationQuoteViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.strEmployeId = obj.strCustomerId;
    objVC.strOrderCode = obj.strOrderCode;
    
    
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (void)btnEditAddressAction:(UIButton *)button withEvent:(UIEvent *)event{
        NSIndexPath * indexPath = [self.inspectionTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.inspectionTableView]];

    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:indexPath.row];
    ViewController *objVC = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (void)btnEditAppoinmentAction:(UIButton *)button withEvent:(UIEvent *)event{
    NSIndexPath * indexPath = [self.inspectionTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.inspectionTableView]];
    
    PFPreInspectionModel *obj = [preInspectionDatasourceArray objectAtIndex:indexPath.row];
    
    editAppointmentViewController *objVC = [[editAppointmentViewController alloc]initWithNibName:@"editAppointmentViewController" bundle:nil];
    objVC.strScreenIndicator=@"preinspection";
    objVC.strAppoinmentId = obj.strAptId;
    objVC.strAppoinmentDate = obj.strAptDate;

    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

-(void)refershPreInspectionList{
    [self callgetPreInspectionServiceIntegration];
}
#pragma mark -

#pragma mark - Service Helper Method
-(void)callgetPreInspectionServiceIntegration {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"preInspectionList"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {
            [preInspectionDatasourceArray removeAllObjects];
            NSArray *inspectionListArray = [result objectForKeyNotNull:@"list" expectedClass:[NSArray class]];
            for (NSMutableDictionary *inspectionDict in inspectionListArray) {
                PFPreInspectionModel *inspectionInfo = [PFPreInspectionModel modelPreInspectionListDict:inspectionDict];
                [preInspectionDatasourceArray addObject:inspectionInfo];
            }
         [self.inspectionTableView reloadData];
        }
    }];
}

-(void)callDeleteProductServiceIntegration :(NSString*)deletedId{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"deleteAdditionalOrder"forKey:@"action"];
    [dict setValue:deletedId forKey:@"deleteId"];
    
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {

            [self callgetPreInspectionServiceIntegration];
        }
    }];
}


-(void)callCancelOrderServiceIntegration :(NSString*)parentOrderId customerId:(NSString*)customerID{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"cancelOrder"forKey:@"action"];
    [dict setValue:parentOrderId forKey:@"parentOrderId"];
    [dict setValue:customerID forKey:@"customerId"];

    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {
            
            [self callgetPreInspectionServiceIntegration];
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
