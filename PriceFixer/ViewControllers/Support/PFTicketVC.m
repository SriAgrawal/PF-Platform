//
//  PFTicketVC.m
//  PriceFixer
//
//  Created by Shridhar Agarwal on 11/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFTicketVC.h"
#import "Macro.h"
#import "PFTicketTableCell.h"
#import "PFTicketInfo.h"

static NSString * cellIdentifier = @"PFTicketTableCell";
@interface PFTicketVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate, PFBuildQuoteVCDelegate> {
    
    NSMutableArray      *arrOfCount, *dataSourceArray;
    BOOL                isAnimated;
    PFOrderInvoiceModel *modelObj;
    NSString *searchString;
    int fromOrToDatePickerValue;
    
}
@end
@implementation PFTicketVC {
    
    __weak IBOutlet UICollectionView *ticketCollectionView;
    __weak IBOutlet UITableView *ticketTableView;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet NSLayoutConstraint *collectionWidthConstraints;
    __strong Pagination *pagination;
    
}

#pragma mark:- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self customInit];
}

-(void)viewWillAppear:(BOOL)animated{
    dataSourceArray = [[NSMutableArray alloc] init];
    ticketTableView.hidden = YES;
    //Adding the notification observer for getting the height
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchNotificationService:)
                                                 name:@"searchNotification"
                                               object:nil];
    
    [self callSupportTicketServiceIntegration:1 searchText:@""];
    
}

- (void)afterSomeTime{
    
    NSLog(@"Height Table %f",ticketTableView.contentSize.height);
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:[NSString stringWithFormat:@"%d",4] forKey:@"Type"];
    [userInfo setValue:[NSString stringWithFormat:@"%f",ticketTableView.contentSize.height+150] forKey:@"Height"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"viewHeightNotification"
     object:userInfo];
}

-(void)searchNotificationService :(NSNotification *)notification {
    
    NSMutableDictionary *dic = notification.object;
    searchString = [dic objectForKey:@"search"];
    [self callSupportTicketServiceIntegration:1 searchText:[dic objectForKey:@"search"]];
    
}

#pragma mark * * * DELEGATE METHOD * * *
-(void)dismissControllerWith:(NSString *)quoteID
{
    PFQuotesBuildViewController *vc = [[PFQuotesBuildViewController alloc]initWithNibName:@"PFQuotesBuildViewController" bundle:nil];
    vc.strQuoteId = quoteID;
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:vc animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}


#pragma mark - Memory Management Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{

}


#pragma mark -

#pragma mark :- Helper Methods
-(void) customInit{
    
    [self.navigationController setNavigationBarHidden:YES];
    [ticketTableView registerNib:[UINib nibWithNibName:@"PFTicketTableCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    // Alloc Model Class
    pagination = [[Pagination alloc] init];
    
    [self methodForSetupCollectionview];
}


-(void)methodForSetupCollectionview{
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [ticketCollectionView registerNib:[UINib nibWithNibName:@"PFCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    ticketCollectionView.layer.cornerRadius = 5.0f;
    ticketCollectionView.layer.borderColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1.f].CGColor;
    ticketCollectionView.layer.borderWidth = 1.0f;
    ticketCollectionView.layer.masksToBounds = YES;
}

#pragma mark -

#pragma mark - UICollectionView  delegate and dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [arrOfCount count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PFCollectionCell * cell = (PFCollectionCell * )[ticketCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    PFDispatchModel * modalObj = [arrOfCount objectAtIndex:indexPath.item];
    cell.cellCountLabel.tag = indexPath.item;
    cell.cellCountLabel.text = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    
    if (modalObj.isSelected) {
        cell.cellCountLabel.textColor = [UIColor whiteColor];
        cell.cellCountLabel.backgroundColor = [UIColor colorWithRed:114/255.0f green:189/255.0f blue:37/255.0f alpha:1.0f];
    }
    else{
        cell.cellCountLabel.textColor = [UIColor colorWithRed:22/255.0f green:45/255.0f blue:84/255.0f alpha:1.0f];
        cell.cellCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(45,45);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [arrOfCount enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PFDispatchModel * modalObj = (PFDispatchModel *)obj;
        modalObj.isSelected = idx==indexPath.item  ? !modalObj.isSelected : NO;
        
    }];
        [self callSupportTicketServiceIntegration:indexPath.item + 1 searchText:searchString];
    
    [ticketCollectionView reloadData];
}

#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        PFTicketTableCell * cell = (PFTicketTableCell *)[ticketTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFTicketInfo *obj = [dataSourceArray objectAtIndex:indexPath.row];

    
    cell.idLabel.text = obj.strIndex;
    cell.dateLabel.text = obj.strDate;
    cell.assignToLabel.text = obj.strAssignTo;
    cell.titleLabel.text = obj.strTitle;
    cell.messageLabel.text = obj.strMessage;
    cell.statusLabel.text = obj.strStatus;
    cell.priortyLabel.text = obj.strPriorty;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    //Manage the Color of Status
    
    if ([obj.strStatus isEqualToString:@"Pending"]) {
        cell.statusLabel.backgroundColor = RGBCOLOR( 217, 83, 79, 1.0);
    }
    else if ([obj.strStatus isEqualToString:@"Working"]){
        cell.statusLabel.backgroundColor = RGBCOLOR( 240, 173, 78, 1.0);
    }
    else
        cell.statusLabel.backgroundColor = RGBCOLOR( 92, 184, 92, 1.0);
    
    //Manage the Color of Priority
    if ([obj.strPriorty isEqualToString:@"Urgent"]) {
        cell.priortyLabel.backgroundColor = RGBCOLOR( 217, 83, 79, 1.0);
    }
    else if ([obj.strPriorty isEqualToString:@"Medium"]){
        cell.priortyLabel.backgroundColor = RGBCOLOR( 240, 173, 78, 1.0);
    }
    else
        cell.priortyLabel.backgroundColor = RGBCOLOR( 21, 122, 183, 1.0);
    
    cell.viewButton.tag = indexPath.row + 200;
    [cell.viewButton addTarget:self action:@selector(viewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 59;
}

- (void)viewButtonAction:(UIButton*)sender {

    PFTicketInfo *obj = [dataSourceArray objectAtIndex:sender.tag%200];
    PFTicketDetailsVC *objVC = [[PFTicketDetailsVC alloc] initWithNibName:@"PFTicketDetailsVC" bundle:nil];
    objVC.ticketId = obj.strId;
    objVC.tickeTitle = obj.strTitle;
    [self.navigationController pushViewController:objVC animated:YES];
    
    
}

- (IBAction)prevButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    NSInteger currentIndex = 0;
    
    for (int i=0; i<[arrOfCount count]; i++) {
        PFDispatchModel *obj = [arrOfCount objectAtIndex:i];
        if (obj.isSelected) {
            currentIndex = --i;
            break;
        }else{
            continue;
        }
    }
    if (currentIndex >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self collectionView:ticketCollectionView didSelectItemAtIndexPath:indexPath];
        if(!(ticketCollectionView.contentOffset.x <= 0))
            [ticketCollectionView setContentOffset:CGPointMake(ticketCollectionView.contentOffset.x -45, 0)];
    }
    
}

- (IBAction)nextPageButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    NSInteger currentIndex = 0;
    
    for (int i=0; i<[arrOfCount count]; i++) {
        PFDispatchModel *obj = [arrOfCount objectAtIndex:i];
        if (obj.isSelected) {
            currentIndex = ++i;
            break;
        }else{
            continue;
        }
    }
    if (currentIndex <= [pagination.maxPageNo integerValue] -1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self collectionView:ticketCollectionView didSelectItemAtIndexPath:indexPath];
        if(!(ticketCollectionView.contentOffset.x >= 270) && [pagination.maxPageNo integerValue] > 4)
            [ticketCollectionView setContentOffset:CGPointMake(ticketCollectionView.contentOffset.x + 45, 0)];
    }
}


#pragma mark - Service Helper Method
- (void)callSupportTicketServiceIntegration: (NSInteger) pageNumber searchText:(NSString *)search{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"supportTickets"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kShop_id] forKey:@"shop_id"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)pageNumber]forKey:@"page_no"];
    [dict setValue:search forKey:@"search"];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [dataSourceArray removeAllObjects];
                dataSourceArray = [PFTicketInfo getTicketList:[response objectForKeyNotNull:kResponseData expectedClass:[NSArray class]]];
                ticketTableView.hidden = NO;
                pagination = [Pagination getPaginationInfoFromDict:[response objectForKeyNotNull:@"pagination" expectedClass:[NSDictionary class]]];
                if ([pagination.maxPageNo intValue] > 1) {
                    bottomView.hidden = NO;
                }
                else {
                    bottomView.hidden = YES;
                }
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:1.0];
                ticketTableView.delegate = self;
                ticketTableView.dataSource = self;
                
                arrOfCount = [[NSMutableArray alloc] init];
                if ([pagination.maxPageNo integerValue] < 3)
                    collectionWidthConstraints.constant = 100;
                else
                    collectionWidthConstraints.constant = 184;
                
                for (int i =1; i<=[pagination.maxPageNo integerValue]; i++) {
                    PFDispatchModel * modalObj = [[PFDispatchModel alloc]init];
                    modalObj.strCount = i;
                    if (i == pageNumber) {
                        modalObj.isSelected = YES;
                    }
                    else{
                        modalObj.isSelected = NO;
                    }
                    [arrOfCount addObject:modalObj];
                }
                [ticketCollectionView reloadData];
                [ticketTableView reloadData];
            }
            else{
                ticketTableView.hidden = YES;
                bottomView.hidden = YES;
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


@end
