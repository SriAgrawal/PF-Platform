//
//  PFLeftMenuVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFLeftMenuVC.h"
#import "Macro.h"
static NSString *CellIdentifier = @"PFLeftMenuCell";

@interface PFLeftMenuVC ()
{
    NSMutableArray *menuItemsArray;
    NSMutableArray *menuImageArray;
    NSString * techcheckCount;
    NSString * installCount;
    NSString * equipmentCount;
    NSString * repairCount;

    
}

@property (weak, nonatomic)   IBOutlet UITableView *menuTableView;


@end

@implementation PFLeftMenuVC


#pragma mark - View life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"PFLeftMenuCell" bundle:nil];
    [self.menuTableView registerNib:cellNib forCellReuseIdentifier:@"PFLeftMenuCell"];
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    menuItemsArray = [NSMutableArray arrayWithObjects:@"Dispatch Central",@"Clients",@"TechCheck",@"Installs",@"Repair",@"Orders",@"Quotes",@"Equipment",@"Support", nil];
    menuImageArray = [NSMutableArray arrayWithObjects:@"dispatch",@"clients",@"installs",@"installs",@"repairs",@"repairs",@"repairs",@"repairs",@"support_icon", nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refershMenuList:)
                                                 name:@"refershMenuList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callAPIForCount) name:@"refreshSidePanel" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self callAPIForCount];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.menuTableView.frame = CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT);
        self.menuTableView.contentOffset = CGPointMake(0, 0);
    });
}



#pragma mark -


#pragma mark - Memory managemrnt method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -


#pragma mark - TableView Delegates and data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuItemsArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"PFLeftMenuCell";
    PFLeftMenuCell *Cell = (PFLeftMenuCell *) [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (Cell == nil) {
        
        Cell = [[PFLeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [Cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    if (indexPath.row == 2)
    {
        
        Cell.lblItem.text = (techcheckCount.length)?[[menuItemsArray objectAtIndex:indexPath.row]stringByAppendingString:[NSString stringWithFormat:@" (%@)",techcheckCount]]:[menuItemsArray objectAtIndex:indexPath.row];

    }
    else if (indexPath.row == 3)
    {
        
        Cell.lblItem.text = (installCount.length)?[[menuItemsArray objectAtIndex:indexPath.row]stringByAppendingString:[NSString stringWithFormat:@" (%@)",installCount]]:[menuItemsArray objectAtIndex:indexPath.row];

    }
    else if (indexPath.row == 4)
    {
        
        Cell.lblItem.text = (repairCount.length)?[[menuItemsArray objectAtIndex:indexPath.row]stringByAppendingString:[NSString stringWithFormat:@" (%@)",repairCount]]:[menuItemsArray objectAtIndex:indexPath.row];
        
    }
    else if (indexPath.row == 7)
    {
        
        Cell.lblItem.text = (equipmentCount.length)?[[menuItemsArray objectAtIndex:indexPath.row]stringByAppendingString:[NSString stringWithFormat:@" (%@)",equipmentCount]]:[menuItemsArray objectAtIndex:indexPath.row];

    }
    else
    {
        [Cell.lblItem setText:[menuItemsArray objectAtIndex:indexPath.row]];
    }
    [Cell.imgViewItem setImage:[UIImage imageNamed:[menuImageArray objectAtIndex:indexPath.row]]];
    
    UIView *bgColorView = [[UIView alloc]init];
    bgColorView.backgroundColor = [UIColor colorWithRed:28.f/255.f green:44.f/255.f blue:86.f/255.f alpha:1.f];
    [Cell setSelectedBackgroundView:bgColorView];
    return Cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{

            PFDispatchVC *obj = [[PFDispatchVC  alloc] initWithNibName:@"PFDispatchVC" bundle:nil];
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];


        }
            break;
        case 1:{

            PFClientVC *obj = [[PFClientVC  alloc] initWithNibName:@"PFClientVC" bundle:nil];
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];

        }
            break;
        case 2:{
            
            PFInstallVC *obj = [[PFInstallVC  alloc] initWithNibName:@"PFInstallVC" bundle:nil];
            obj.viewType = RepeatViewType_TypeCheck;
           [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];
        }
            break;
            
        case 3:{
            
            PFInstallVC *obj = [[PFInstallVC  alloc] initWithNibName:@"PFInstallVC" bundle:nil];
             obj.viewType = RepeatViewType_Install;
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];
        }
            break;
            
        case 4:{
            
            PFInstallVC *obj = [[PFInstallVC  alloc] initWithNibName:@"PFInstallVC" bundle:nil];
            obj.viewType = RepeatViewType_Repair;
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];

        }
            break;
            
        case 6:{
            
            PFQuotesVC *obj = [[PFQuotesVC  alloc] initWithNibName:@"PFQuotesVC" bundle:nil];
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];
            
        }
            break;
            
        case 7:{
            
            PFInstallVC *obj = [[PFInstallVC  alloc] initWithNibName:@"PFInstallVC" bundle:nil];
            obj.viewType = RepeatViewType_Equipment;
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];
            
        }
            break;
            
        case 5:{
            
            PFOrderViewController *obj = [[PFOrderViewController  alloc] initWithNibName:@"PFOrderViewController" bundle:nil];
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];
            
        }
            break;
        case 8:{
            
            PFSupportViewController *obj = [[PFSupportViewController  alloc] initWithNibName:@"PFSupportViewController" bundle:nil];
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:obj]];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -



#pragma mark - Scroll view delegate method

- (void)refershMenuList:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
                self.menuTableView.frame = CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT);
                self.menuTableView.contentOffset = CGPointMake(0, 0);
    });
}

#pragma mark - * * * SERVICE HELPER * * * 
-(void)callAPIForCount{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"menuCount"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {

        if (suceeded) {

            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                NSDictionary *dict = [response valueForKey:@"countData"];
                techcheckCount = [dict objectForKeyNotNull:@"total_tech" expectedClass:[NSString class]];
                installCount = [dict objectForKeyNotNull:@"total_installs" expectedClass:[NSString class]];
                equipmentCount = [dict objectForKeyNotNull:@"total_equipments" expectedClass:[NSString class]];
                repairCount = [dict objectForKeyNotNull:@"total_repairs" expectedClass:[NSString class]];

                [self.menuTableView reloadData];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


@end
