/*
 Copyright (c) 2014 eBay Software Foundation
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 Neither the name of eBay or any of its subsidiaries or affiliates nor the names
 of its contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SVRemoteResource.h"
#import "SVRemoteResourceDiskCache.h"

@interface SVRemoteResourceDiskCache ()
{
@private
    NSURL *_fileURL;
}

@end

@implementation SVRemoteResourceDiskCache

-(instancetype)initWithFileURL:(NSURL *)fileURL
{
    self = [self init];
    
    if (self)
    {
        _fileURL = fileURL;
        
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:fileURL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (success == NO)
        {
            NSLog(@"Error creating cache directory: %@", error);
        }
        
        _IOQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    return self;
}

-(void)dataForResource:(SVRemoteResource *)remoteResource
            completion:(SVRemoteResourceCacheReadCompletionBlock)completion
               failure:(SVRemoteResourceCacheFailureBlock)failure
{
    NSURL *fileURL = [_fileURL URLByAppendingPathComponent:remoteResource.uniqueKeyHash isDirectory:NO];
    
    dispatch_async(_IOQueue, ^{
        NSError *error = nil;
        NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL options:NSDataReadingUncached error:&error];
        
        if (data)
        {
            if (completion)
            {
                completion(data);
            }
        }
        else
        {
            if (failure)
            {
                failure(error);
            }
        }
    });
}

-(void)writeData:(NSData*)data
     forResource:(SVRemoteResource *)remoteResource
      completion:(SVRemoteResourceCacheWriteCompletionBlock)completion
         failure:(SVRemoteResourceCacheFailureBlock)failure;
{
    NSURL *fileURL = [_fileURL URLByAppendingPathComponent:remoteResource.uniqueKeyHash isDirectory:NO];
    
    dispatch_async(_IOQueue, ^{
        NSError *error = nil;
        BOOL success = [data writeToURL:fileURL options:(NSDataWritingAtomic|NSDataWritingFileProtectionComplete) error:&error];
        
        if (success)
        {
            if (completion)
            {
                completion();
            }
        }
        else
        {
            if (failure)
            {
                failure(error);
            }
        }
    });
}

@end
