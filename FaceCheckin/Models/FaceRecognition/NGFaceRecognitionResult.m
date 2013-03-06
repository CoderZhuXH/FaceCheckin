//
//  NGFaceRecognitionResult.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/4/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGFaceRecognitionResult.h"
#import "NGFaceRecognitionAlbum.h"

#import "NGImageRecognizer.h"
#import "AFJSONRequestOperation.h"

@implementation NGFaceRecognitionResult

+ (void)getRecognitionResulsForImageData:(NSData *)imageData forNameSpace:(NSString *)nameSpace withResult:(NGFaceRecognitionCallback)cblk {
    
    NSMutableDictionary * postArguments = [
  @{@"uids"    : @"all",
    @"namespace" : nameSpace,
    @"detector" : @"Aggressive"} mutableCopy];
    
    [postArguments addEntriesFromDictionary:[NGImageRecognizer baseArgs]];
    
    NGImageRecognizer * api = [NGImageRecognizer sharedClient];
    
    NSMutableURLRequest * request = [api multipartFormRequestWithMethod:@"POST" path:@"/fc/faces/recognize.json" parameters:postArguments constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"files" fileName:@"img.png" mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation * op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"I have: %@",[JSON description]);
        cblk(nil,nil);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        cblk(nil,error);
    }];
    
    [op start];
}

@end

@implementation NGFaceRecognitionUUID

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        
        _confidence = [[dictionary valueForKey:@"confidence"] floatValue];
        _predictedPictureId = [dictionary objectForKey:@"prediction"];
        _imageUUID = [dictionary objectForKey:@"uid"];
    }
    return self;
}

@end

@implementation NGFaceRecognitionPhotoResult

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _width = [[dictionary objectForKey:@"width"] integerValue];
        _height = [[dictionary objectForKey:@"height"] integerValue];
        _imgUrlString = [dictionary objectForKey:@"url"];
        _tags = [dictionary objectForKey:@"tags"];
    }
    return self;
}

- (NSArray *)ngFaceRecognitionUUIDs {
    
    NSArray * uids = nil;
    
    // get from Tag Array
    for (NSDictionary * tag in self.tags) {
        
        id obj = [tag objectForKey:@"uids"];
        if (obj && [obj isKindOfClass:[NSArray class]]){
            uids = obj;
            break;
        }
    }
    
    NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:uids.count];
    
    // parse into NGFaceRecognitionUUIDs
    for (NSDictionary * uid in uids) {
        NGFaceRecognitionUUID * uuid = [[NGFaceRecognitionUUID alloc] initWithDictionary:uid];
        [resultArray addObject:uuid];
    }
    
    return [NSArray arrayWithArray:resultArray];
}


@end
