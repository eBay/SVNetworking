#import <Foundation/Foundation.h>

@interface SVDiskCache : NSObject

-(id)initWithPath:(NSString*)path;

-(NSData*)dataForKey:(NSString*)key;
-(void)writeData:(NSData*)data forKey:(NSString*)key;

-(BOOL)hasDataForKey:(NSString*)key;

@end
