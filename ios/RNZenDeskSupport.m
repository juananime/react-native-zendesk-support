//
//  RNZenDeskSupport.m
//
//  Created by Patrick O'Connor on 8/30/17.
//

// RN < 0.40 suppoert
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTConvert.h>
#else
#import "RCTConvert.h"
#endif

#import "RNZenDeskSupport.h"
#import <ZendeskSDK/ZendeskSDK.h>

@implementation RNZenDeskSupport

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initialize:(NSDictionary *)config){
    NSString *appId = [RCTConvert NSString:config[@"appId"]];
    NSString *zendeskUrl = [RCTConvert NSString:config[@"zendeskUrl"]];
    NSString *clientId = [RCTConvert NSString:config[@"clientId"]];
    [[ZDKConfig instance]
     initializeWithAppId:appId
     zendeskUrl:zendeskUrl
     clientId:clientId];
}

RCT_EXPORT_METHOD(setupIdentity:(NSDictionary *)identity){
    dispatch_async(dispatch_get_main_queue(), ^{
        ZDKAnonymousIdentity *zdIdentity = [ZDKAnonymousIdentity new];
        NSString *email = [RCTConvert NSString:identity[@"customerEmail"]];
        NSString *name = [RCTConvert NSString:identity[@"customerName"]];
        if (email != nil) {
            zdIdentity.email = email;
        }
        if (name != nil) {
            zdIdentity.name = name;
        }
        [ZDKConfig instance].userIdentity = zdIdentity;

    });
}

RCT_EXPORT_METHOD(showHelpCenterWithStyle:(NSDictionary *)style) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        [ZDKTheme currentAppliedTheme].primaryBackgroundColor = [self getUIColorObjectFromHexString:style[@"primaryBackgroundColor"] alpha:1.0];
        [ZDKTheme currentAppliedTheme].secondaryBackgroundColor = [self getUIColorObjectFromHexString:style[@"secondaryBackgroundColor"] alpha:1.0];
        [ZDKTheme currentAppliedTheme].emptyBackgroundColor = [self getUIColorObjectFromHexString:style[@"emptyBackgroundColor"] alpha:1.0];
        
        [ZDKTheme currentAppliedTheme].separatorColor = [self getUIColorObjectFromHexString:style[@"separatorColor"] alpha:1.0];
        [ZDKTheme currentAppliedTheme].inputFieldTextColor = [self getUIColorObjectFromHexString:style[@"inputFieldTextColor"] alpha:1.0];
        [ZDKTheme currentAppliedTheme].primaryTextColor = [self getUIColorObjectFromHexString:style[@"primaryTextColor"] alpha:1.0];
        [ZDKTheme currentAppliedTheme].secondaryTextColor =  [self getUIColorObjectFromHexString:style[@"secondaryTextColor"] alpha:1.0];
       
        [ZDKTheme currentAppliedTheme].fontName = style[@"fontFamily"];
        [ZDKTheme currentAppliedTheme].boldFontName = style[@"boldFontName"];
     

        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.hideContactSupport = NO;
        [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(showHelpCenterWithOptions:(NSDictionary *)options) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
       [ZDKTheme currentAppliedTheme].primaryBackgroundColor = [UIColor blackColor];
        [ZDKTheme currentAppliedTheme].fontName = @"GoogleSans-Medium";
        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.hideContactSupport = [RCTConvert BOOL:options[@"hideContactSupport"]];
        if (helpCenterContentModel.hideContactSupport) {
            [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        }
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(showCategoriesWithOptions:(NSArray *)categories options:(NSDictionary *)options) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.groupType = ZDKHelpCenterOverviewGroupTypeCategory;
        helpCenterContentModel.groupIds = categories;
        helpCenterContentModel.hideContactSupport = [RCTConvert BOOL:options[@"hideContactSupport"]];
        if (helpCenterContentModel.hideContactSupport) {
            [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        }
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(showSectionsWithOptions:(NSArray *)sections options:(NSDictionary *)options) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.groupType = ZDKHelpCenterOverviewGroupTypeSection;
        helpCenterContentModel.groupIds = sections;
        helpCenterContentModel.hideContactSupport = [RCTConvert BOOL:options[@"hideContactSupport"]];
        if (helpCenterContentModel.hideContactSupport) {
            [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        }
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(showLabelsWithOptions:(NSArray *)labels options:(NSDictionary *)options) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.labels = labels;
        helpCenterContentModel.hideContactSupport = [RCTConvert BOOL:options[@"hideContactSupport"]];
        if (helpCenterContentModel.hideContactSupport) {
            [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        }
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(showHelpCenter) {
    [self showHelpCenterWithOptions:nil];
}

RCT_EXPORT_METHOD(showCategories:(NSArray *)categories) {
    [self showCategoriesWithOptions:categories options:nil];
}

RCT_EXPORT_METHOD(showSections:(NSArray *)sections) {
    [self showSectionsWithOptions:sections options:nil];
}

RCT_EXPORT_METHOD(showLabels:(NSArray *)labels) {
    [self showLabelsWithOptions:labels options:nil];
}

RCT_EXPORT_METHOD(callSupport:(NSDictionary *)customFields) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        NSMutableArray *fields = [[NSMutableArray alloc] init];
        for (NSString* key in customFields) {
            id value = [customFields objectForKey:key];
            [fields addObject: [[ZDKCustomField alloc] initWithFieldId:@(key.integerValue) andValue:value]];
        }
        [ZDKConfig instance].customTicketFields = fields;
        [ZDKRequests presentRequestCreationWithViewController:vc];
    });
}

RCT_EXPORT_METHOD(supportHistory){
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        [ZDKRequests presentRequestListWithViewController:vc];
    });
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
  // Convert hex string to an integer
  unsigned int hexint = [self intFromHexString:hexStr];

  // Create a color object, specifying alpha as well
  UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
    blue:((CGFloat) (hexint & 0xFF))/255
    alpha:alpha];

  return color;
}
- (unsigned int)intFromHexString:(NSString *)hexStr
{
  unsigned int hexInt = 0;

  // Create scanner
  NSScanner *scanner = [NSScanner scannerWithString:hexStr];

  // Tell scanner to skip the # character
  [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];

  // Scan hex value
  [scanner scanHexInt:&hexInt];

  return hexInt;
}
@end
