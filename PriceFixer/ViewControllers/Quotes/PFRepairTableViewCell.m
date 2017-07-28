//
//  PFRepairTableViewCell.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 20/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFRepairTableViewCell.h"
#import "PFRepairClientTableViewCell.h"

static NSString * cellIdentifier = @"repairClientId";

@interface PFRepairTableViewCell()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *repairMainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repairMainViewHeightConstraint;

@end


@implementation PFRepairTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialMethod];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - Initial Method

- (void)initialMethod {
    
    // Register TableView
    self.repairTableView.delegate = self;
    self.repairTableView.dataSource = self;
    [self.repairTableView registerNib:[UINib nibWithNibName:@"PFRepairClientTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
}


#pragma mark - UITableView Delegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFRepairClientTableViewCell * cell = (PFRepairClientTableViewCell *)[self.repairTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell.repairImageView setImageWithURL:[NSURL URLWithString:self.repairInfo.strProductImageUrl] placeholderImage:[UIImage imageNamed:@""]];
    cell.anyRepairLabel.text = self.repairInfo.strItemTitle;
    cell.quantitylabel.text = [NSString stringWithFormat:@"Qty: %@",self.repairInfo.strQuantity];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122.0;
}


#pragma mark - Selector Method

-(void)afterSomeTime {
    
    self.repairMainViewHeightConstraint.constant = self.repairTableView.contentSize.height;
}


@end
