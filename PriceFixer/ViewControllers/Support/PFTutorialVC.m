//
//  PFTutorialVC.m
//  PriceFixer
//
//  Created by Shridhar Agarwal on 11/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFTutorialVC.h"
#import "Macro.h"
#import "PFVideoPlayerViewController.h"

@interface PFTutorialVC (){

    NSMutableArray *dataSourceArray, *arrOfCount;
    
    BOOL isLoading;

}
@property(strong,nonatomic) IBOutlet UICollectionView   *collectionView;
@property(strong,nonatomic) IBOutlet UIView *bottomView;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint *collectionWidthConstraints;
@property(strong,nonatomic) Pagination *pagination;
@end

@implementation PFTutorialVC

#pragma mark - UIViewController Life Cycle Method

-(void) viewDidLoad {
    [super viewDidLoad];
    dataSourceArray = [[NSMutableArray alloc] init];

    [self initialMethod];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self callTutorialServiceIntegration:@"1" :@""];
    
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other Helper Method

- (void)initialMethod {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PFTutorialCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PFTutorialCollectionCell"];
    
    //Adding the notification observer for getting the height
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchNotificationService:)
                                                 name:@"searchNotification"
                                               object:nil];

}

- (void)afterSomeTime{

    float height = self.collectionView.contentSize.height+60;
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:[NSString stringWithFormat:@"%d",3] forKey:@"Type"];
    [userInfo setValue:[NSString stringWithFormat:@"%f",height] forKey:@"Height"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"viewHeightNotification"
     object:userInfo];
}

-(void)searchNotificationService :(NSNotification *)notification {
    
    NSMutableDictionary *dic = notification.object;
    
    [self callTutorialServiceIntegration:[dic objectForKey:@"ID"] :[dic objectForKey:@"search"]];

}

#pragma mark - UICollectionview DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFTutorialCollectionCell *cell = (PFTutorialCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PFTutorialCollectionCell" forIndexPath:indexPath];
    PFTutorialInfo *obj = [dataSourceArray objectAtIndex:indexPath.row];
    cell.dateLbl.text = obj.strDate;
    cell.titleLbl.text = obj.strTitle;
    cell.imageTagLineLbl.text = obj.strTitle;
    [cell.vedioTumpNailImageView setImageWithURL:[NSURL URLWithString:obj.strThumbImage] placeholderImage:[UIImage imageNamed:@""]];
    cell.clikedBtn.tag = indexPath.row +1000;
    [cell.clikedBtn addTarget:self action:@selector(cellClickedButton:) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [obj.strDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
   cell.textView.attributedText = attributedString;
    return cell;
}

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.collectionView.frame.size.width/2)-60, 170);;
}


-(void)cellClickedButton :(UIButton *) sender {
    [self.view endEditing:YES];
    
    PFTutorialInfo *obj = [dataSourceArray objectAtIndex:sender.tag - 1000];
    
    PFVideoPlayerViewController *objVC = [[PFVideoPlayerViewController alloc]initWithNibName:@"PFVideoPlayerViewController" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.obj_tutorial = obj;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];

    
}

-(void)callTutorialServiceIntegration :(NSString *)sortBy :(NSString *)searchText {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"supportTutorials"forKey:@"action"];
    [dict setValue:sortBy forKey:kSortBy];
    [dict setValue:searchText forKey:@"serach"];
    [dict setValue:[NSUSERDEFAULTS valueForKey:kUserId]  forKey:@"user_id"];
    [dict setValue:@"" forKey:@"is_new"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [dataSourceArray removeAllObjects];
                if (response && [response isKindOfClass:[NSDictionary class]]) {
                    NSArray *arrayImage = [response objectForKeyNotNull:@"responseData" expectedClass:[NSArray class]];
                    if (arrayImage && [arrayImage isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dict_imageDetail in arrayImage) {
                            [dataSourceArray addObject:[PFTutorialInfo parseDataforTutorial:dict_imageDetail]];
                        }
                        isLoading =YES;
                        
                    }
                }
                [self.collectionView reloadData];
                
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:1.0];
               
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



@end
