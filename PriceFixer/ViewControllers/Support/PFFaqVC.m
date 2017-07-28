//
//  PFFaqVC.m
//  PriceFixer
//
//  Created by Shridhar Agarwal on 15/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFFaqVC.h"
#import "Macro.h"
#import "PFFaqInfo.h"
#import "PFFaqTableViewCell.h"

static NSString *cellIdentifier = @"PFFaqTableViewCell";

@interface PFFaqVC (){
    float height;
    
    NSMutableArray *dataSourceArray;
    BOOL isLoading;

}
@property (weak, nonatomic) IBOutlet UIView *faqView;
@property (weak, nonatomic) IBOutlet UILabel *faqTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UILabel *faqDescriptionLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property (weak, nonatomic) IBOutlet UITableView *faqTableView;


@end

@implementation PFFaqVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)initialSetUp {
    
    self.heightConstraints.constant = 130;
    height = 130;
    
    self.faqTableView.estimatedRowHeight = 150;
    self.faqTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.faqTableView registerNib:[UINib nibWithNibName:@"PFFaqTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    //Adding the notification observer for getting the height
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchNotificationServiceForFaq:)
                                                 name:@"searchNotificationForFAQ"
                                               object:nil];
     [self afterSomeTime];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initialSetUp];
    dataSourceArray = [[NSMutableArray alloc] init];
    
    dataSourceArray = [[NSMutableArray alloc]init];
    
    [self callFAQServiceIntegration:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Helper Method

- (void)afterSomeTime{
    
    
    NSLog(@"Height %f",self.faqTableView.contentSize.height);
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:[NSString stringWithFormat:@"%d",2] forKey:@"Type"];
    [userInfo setValue:[NSString stringWithFormat:@"%f",self.faqTableView.contentSize.height + 100] forKey:@"Height"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"viewHeightNotification"
     object:userInfo];
}

-(void)searchNotificationServiceForFaq :(NSNotification *)notification {
    NSDictionary *dict = notification.object;
    
    [self callFAQServiceIntegration:[dict objectForKey:@"search"]];
}

- (void)expandButtonAction:(UIButton *)sender {
   
    PFFaqInfo *obj = [dataSourceArray objectAtIndex:sender.tag - 500];
    
    if (obj.isExpand) {
        obj.isExpand = NO;
    }else  {
        obj.isExpand = YES;

    }
    [self.faqTableView reloadData];
    [self afterSomeTime];
}


#pragma mark - UITableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFFaqInfo *obj = [dataSourceArray objectAtIndex:indexPath.row];
    
    if (obj.isExpand) {
        return self.faqTableView.rowHeight;
    }else {
        return 130;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PFFaqTableViewCell *cell = (PFFaqTableViewCell *) [self.faqTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFFaqInfo *obj = [dataSourceArray objectAtIndex:indexPath.row];

    cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.faqTitleLbl.text = obj.strTitle;
    cell.faqDescriptionLbl.text = obj.strDescription;
    cell.dropDownBtn.tag = indexPath.row+500;
    [cell.dropDownBtn addTarget:self action:@selector(expandButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (obj.isExpand) {
        [cell.upImageView setImage:[UIImage imageNamed:@"minus-circle-outline"]];
    }
    else
        [cell.upImageView setImage:[UIImage imageNamed:@"plus-circle-outline"]];
    return cell;
}


-(void)callFAQServiceIntegration: (NSString *)searchText {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"supportFaq"forKey:@"action"];
    [dict setValue:searchText forKey:@"search"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [dataSourceArray removeAllObjects];
                NSMutableArray *responseData = [response objectForKeyNotNull:kResponseData expectedClass:[NSArray class]];
                for (NSMutableDictionary *dic in responseData) {
                    PFFaqInfo *obj = [[PFFaqInfo alloc] init];
                    obj.strId = [dic objectForKeyNotNull:@"id" expectedClass:[NSString class]];
                    obj.strTitle = [dic objectForKeyNotNull:@"question" expectedClass:[NSString class]];
                    obj.strDescription = [dic objectForKeyNotNull:@"answer" expectedClass:[NSString class]];
                    [dataSourceArray addObject:obj];
                }

                [self.faqTableView reloadData];
                [self afterSomeTime];

            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



@end
