//
//  PFInstallsMainTVC.m
//  PriceFixer
//
//  Created by Tejas Pareek on 16/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFInstallsMainTVC.h"
#import "PFOrderDetailTVC.h"
#import "PFInstallModel.h"
#import "PFInstallProductDetailVC.h"
#import "PFInstallVC.h"
#import "PFInstallButtonTVC.h"

@interface PFInstallsMainTVC()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate, orderDelegate>

@end

@implementation PFInstallsMainTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialSetup];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initialSetup{
    
    [self setTableViewDelegate];
    
    [self.tblViewSV registerNib:[UINib nibWithNibName:@"PFOrderDetailTVC" bundle:nil] forCellReuseIdentifier:@"PFOrderDetailTVC"];
    
    [self.tblViewTV registerNib:[UINib nibWithNibName:@"PFInstallButtonTVC" bundle:nil] forCellReuseIdentifier:@"PFInstallButtonTVC"];
    
    self.tblViewSV.alwaysBounceVertical = NO;
    
    [self changeBorderColor:self.viewForCustomerDetails];
    [self changeBorderColor:self.viewForTime];
    [self changeBorderColor:self.viewForOrderDetails];
    
    [self changebuttonRadious:self.btnInRoute];
    [self changebuttonRadious:self.btnApproved];
    [self changebuttonRadious:self.btnComplete];
    [self changebuttonRadious:self.btnInstallDate];
    [self changebuttonRadious:self.btnOrderPlased];
    [self changebuttonRadious:self.btnWalkThrough];
}

-(void)setTableViewDelegate{
    [self.tblViewSV setDelegate:self];
    [self.tblViewSV setDataSource:self];
    [self.tblViewSV setEstimatedRowHeight:90];
    
    [self.tblViewTV setDelegate:self];
    [self.tblViewTV setDataSource:self];
}

-(void)changeBorderColor:(UIView*)view{

    [[view layer] setBorderWidth:1.0f];
    [[view layer] setCornerRadius:5];
    [[view layer] setBorderColor:[UIColor lightGrayColor].CGColor];
}
-(void)changebuttonRadious:(UIButton*)btn{
    [[btn layer] setCornerRadius:25];
}

#pragma Mark - * * * UITableViewDelegate, UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tblViewSV])
    {
        return self.orderArray.count;
    }
    else
    {
        return self.buttonArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tblViewSV])
    {
        PFOrderDetail *obj = [self.orderArray objectAtIndex:indexPath.row];
        PFOrderDetailTVC *cellForSV = [self.tblViewSV dequeueReusableCellWithIdentifier:NSStringFromClass([PFOrderDetailTVC class])];
        
        if (self.orderArray.count <= 3) {
            self.moreItemlabel.hidden = YES;
        }else{
            self.moreItemlabel.hidden = NO;
        }
        
        if ([obj.strIsReturned isEqualToString:@"1"]) 
            cellForSV.returnedLabel.hidden = NO;
        else
            cellForSV.returnedLabel.hidden = YES;
 
        if ([obj.strIsItem isEqualToString:@"1"]) {
        [cellForSV.lblItemName setText:obj.strProductTitle];
        [cellForSV.imgOfItem setImageWithURL:[NSURL URLWithString:obj.strProductImage]];
        [cellForSV.lblQuantityOfItems setText:obj.strProductQty];
        [cellForSV.lblitemsDetail setText:obj.strProductDiscription];
        }else{
            [cellForSV.imgOfItem setImageWithURL:[NSURL URLWithString:obj.strTechImage]];
            [cellForSV.lblItemName setText:obj.strTechTitle];
        }
        return cellForSV;
    }
    else
    {
        PFInstallButtonTVC *cellForTV = [self.tblViewTV dequeueReusableCellWithIdentifier:NSStringFromClass([PFInstallButtonTVC class])];

        if([[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Schedule Time"])
        {
            cellForTV.btnForTV.backgroundColor= [UIColor colorWithRed:128/255.0f green:184/255.0f blue:85/255.0f alpha:1.0];
        }
        else if([[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Cancel & Refund"])
        {
             cellForTV.btnForTV.backgroundColor= [UIColor colorWithRed:222/255.0f green:88/255.0f blue:65/255.0f alpha:1.0];
        }
        else if([[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"In Route"] || [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Approve Equipment"] || [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Set Installation"] || [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Approve Labor"]|| [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Process Final Bill"] || [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"80% Completed"] || [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"100% Completed"] || ([[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Arrived"] /*&& self.fromInstall*/) || [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Finish & Archive"]|| [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Mark Delivered"]|| [[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Claim"]||[[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Warehouse"]||[[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Process Return"]||[[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Set Delivery"]||[[_buttonArray objectAtIndex:indexPath.row] isEqualToString:@"Repair Completed"])
        {
            cellForTV.btnForTV.backgroundColor= [UIColor colorWithRed:98.0/255.0f green:179.0/255.0f blue:53.0/255.0f alpha:1.0];
        }else{
            cellForTV.btnForTV.backgroundColor= [UIColor colorWithRed:15/255.0f green:22/255.0f blue:53/255.0f alpha:1.0];
        }
        
        [cellForTV.btnForTV setTitle:[_buttonArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [cellForTV.btnForTV addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cellForTV;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tblViewSV])
    {
        PFOrderDetail *obj = [self.orderArray objectAtIndex:indexPath.row];
        if([obj.strProductId intValue] > 0){
        if (self && self.delegate && [self.delegate respondsToSelector:@selector(presentProductDetail:)]) {
        [self.delegate presentProductDetail:obj.strProductId];
        }
    }
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger currentOffset = self.tblViewSV.contentOffset.y;
    NSInteger maximumOffset = self.tblViewSV.contentSize.height - self.tblViewSV.frame.size.height;
    if ((maximumOffset - currentOffset <= self.orderArray.count)) {
        
       self.moreItemlabel.hidden = YES;
    }else{
        self.moreItemlabel.hidden = NO;

    }
    if (self.orderArray.count <= 3) {
        self.moreItemlabel.hidden = YES;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tblViewSV])
    {
        return UITableViewAutomaticDimension;
    }
    else{
        return 44;
    }
}

- (void)buttonAction:(UIButton*)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.mainTableView];

    NSIndexPath *tappedIP = [self.mainTableView indexPathForRowAtPoint:buttonPosition];
    
    [self.delegate buttonClick:tappedIP.row btnTitle:sender.titleLabel.text];

}

@end
