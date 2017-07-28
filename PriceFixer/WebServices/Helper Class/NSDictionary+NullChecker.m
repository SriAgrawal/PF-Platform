#import "NSDictionary+NullChecker.h"

@implementation NSDictionary (NullChecker)

-(id)objectForKeyNotNull:(id)key expectedClass:(Class)className {
    
    id object = [self objectForKey:key];
    
    // added helper to check if in case we are getting number from server but we want a string from it
    if ([object isKindOfClass:[NSNumber class]] && (className == [NSString class])) {
        return [object stringValue];
    }
    
    // checking if object is of desired class
    if (![object isKindOfClass:className])
        return [className new];
    
    // checking if in case object is nil
    if (object == nil || object == [NSNull null])
        return [className new];
    
    // checking if in case object if of string type and we are getting nil inside quotes
   	if ([object isKindOfClass:[NSString class]]){
        if ([object isEqualToString:@"<null>"]||[object isEqualToString:@"(null)"]) {
            return [className new];
        }
    }
   
    
    return object;
}

@end
