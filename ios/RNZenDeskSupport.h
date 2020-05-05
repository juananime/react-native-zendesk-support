
//
//  RNZenDeskSupport.h
//
//  Created by Patrick O'Connor on 8/30/17.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RNZenDeskSupport : NSObject <RCTBridgeModule>
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end
