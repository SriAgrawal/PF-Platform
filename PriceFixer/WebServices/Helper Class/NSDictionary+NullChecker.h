#import <Foundation/Foundation.h>

@interface NSDictionary (NullChecker)

-(id)objectForKeyNotNull:(id)key expectedClass:(Class)className;

@end
