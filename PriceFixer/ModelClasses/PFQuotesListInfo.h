//
//  PFQuotesListInfo.h
//  PriceFixer
//
//  Created by Tejas Pareek on 17/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFQuotesListInfo : NSObject

@property (strong, nonatomic) NSString *strId;
@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strPhoneNumber;
@property (strong, nonatomic) NSString *strQuote;
@property (strong, nonatomic) NSString *strEmail;
@property (strong, nonatomic) NSString *strStatus;
@property (strong, nonatomic) NSString *strRegisteredUser;
@property (strong, nonatomic) NSString *strRange;
@property (strong, nonatomic) NSString *strTodate;
@property (strong, nonatomic) NSString *strFromDate;
@property (strong, nonatomic) NSString *strPrintUrl;

@property (strong, nonatomic) NSString *strDescription;
@property (strong, nonatomic) NSString *strIncludeEmail;




// For paging
@property(nonatomic,assign) NSInteger  strCount;
@property (assign,nonatomic) BOOL isSelected;

// Edit Quotes
@property (strong, nonatomic) NSString *strCustomer_phone;
@property (strong, nonatomic) NSString *strCustomer_email;
@property (strong, nonatomic) NSString *strCustomer_name;
@property (strong, nonatomic) NSString *strFranchise;
@property (strong, nonatomic) NSString *strOwner;
@property (strong, nonatomic) NSString *strWebsite_phone;
@property (strong, nonatomic) NSString *strDistance;
@property (strong, nonatomic) NSString *strProduct_id;
@property (strong, nonatomic) NSString *strProduct_detail_url;
@property (strong, nonatomic) NSString *strProduct_image_urlEmail;
@property (strong, nonatomic) NSString *strProduct_name;
@property (strong, nonatomic) NSString *strDesc;

@property (strong, nonatomic) NSString *strCheck_title;
@property (strong, nonatomic) NSString *strPrice;
@property (strong, nonatomic) NSString *strPer_month;
@property (strong, nonatomic) NSString *strPlus_minue;
@property (strong, nonatomic) NSString *strQty;
@property (strong, nonatomic) NSString *strSub_total;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strIsInstall;
@property (strong, nonatomic) NSString *strFigure;
@property (strong, nonatomic) NSString *strCatTitle;
@property (strong, nonatomic) NSString *strCatText;
@property (strong, nonatomic) NSString *strCatProductsAr;

//METHODS
+(PFQuotesListInfo *)getQuotesList:(NSDictionary *)dict;
+(PFQuotesListInfo *)getItemsForEdit:(NSDictionary *)dict;
+(PFQuotesListInfo *)getColSpamList:(NSDictionary *)dict;

+(PFQuotesListInfo *)getNotesList:(NSDictionary *)dict;

@end

@interface PFQuotesProductListInfo : NSObject

@property (strong, nonatomic) NSString * strTitleID;
@property (strong, nonatomic) NSString * strTitleLable;
@property (strong, nonatomic) NSString * strTitleHTML;
@property (strong, nonatomic) NSString * strPdfUrl;


+(PFQuotesProductListInfo*)modelProductListDict:(id)dict;
@end
