#import <Foundation/Foundation.h>

@interface SVDiskCache : NSObject

-(instancetype)initWithFileURL:(NSURL *)fileURL;

-(NSData*)dataForKey:(NSString*)key error:(NSError **)error;
-(BOOL)writeData:(NSData*)data forKey:(NSString*)key error:(NSError **)error;

@end
