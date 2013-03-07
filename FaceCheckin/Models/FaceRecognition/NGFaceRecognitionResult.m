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



#ifdef DEBUG

+ (NSDictionary *)mockedData {
    NSString * pathOfMock = [[NSBundle mainBundle] pathForResource:@"MockResponse" ofType:@"json"];
    NSData * stringData = [[NSString stringWithContentsOfFile:pathOfMock encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    id JSON = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
    return (NSDictionary *)JSON;
}

#endif

+ (void)getRecognitionResulsForImageData:(NSData *)imageData forNameSpace:(NSString *)nameSpace withResult:(NGFaceRecognitionCallback)cblk {
    
    /*
    
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
        
        NSLog(@"Got data: %@", JSON);
        NGFaceRecognitionResult * result = [[NGFaceRecognitionResult alloc] initWithDictionary:JSON withUserData:nameSpace];
        cblk(result, nil);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        cblk(nil,error);
    }];
    
    [op start];
     
     */
    
    id JSON = [[self class] mockedData];
    NSLog(@"Got data: %@", JSON);
    NGFaceRecognitionResult * result = [[NGFaceRecognitionResult alloc] initWithDictionary:JSON withUserData:nameSpace];
    
    double delayInSeconds = 1.0f + arc4random_uniform(120)/60.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        cblk(result, nil);
    });
}

- (id)initWithDictionary:(NSDictionary *)dictionary withUserData:(id)object {
    self = [self initWithDictionary:dictionary];
    if (self) {
        _nameSpace = (NSString *)object;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        _result = [dictionary objectForKey:jkSkyBiometryResultField];
        _usage = [dictionary objectForKey:jkSkyBiometryUsageField];
        NSArray * array = [dictionary objectForKey:jkSkyBiometryPhotosField];
        
        // @array MUST HAVE a count == 1. I'm sending just one picture anyway.
        NSAssert(array.count == 1, @"I didn't send more than one picture, DAFUQ here?");
        
        _photos = [[self class] parsePhotosToFields:array];
    }
    
    return self;
}

// Private
+ (NSArray *)parsePhotosToFields:(id)photosObject {
    
    NSAssert(photosObject != nil, @"Photos object must exist here.");
    NSAssert([photosObject isKindOfClass:[NSArray class]], @"Passed object must be a NSArray, and not a %@", NSStringFromClass([photosObject class]));
    
    NSMutableArray * results = [NSMutableArray arrayWithCapacity:[photosObject count]];
    
    for (NSDictionary * jsonElement in photosObject) {
        NGFaceRecognitionPhotoResult * result = [[NGFaceRecognitionPhotoResult alloc] initWithDictionary:jsonElement];
        [results addObject:result];
    }
    
    return (results);
}

@end

@interface NGFaceRecognitionPhotoResult ()

@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSArray * uuidsInPicture;

@end

@implementation NGFaceRecognitionPhotoResult

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _width = [[dictionary objectForKey:@"width"] integerValue];
        _height = [[dictionary objectForKey:@"height"] integerValue];
        _imgUrlString = [dictionary objectForKey:@"url"];
        self.tags = [dictionary objectForKey:@"tags"];
        
        _facesOnPicture = self.tags.count;
        
        self.uuidsInPicture = [self ngFaceRecognitionUUIDs];
        
    }
    return self;
}

- (NSArray *)ngFaceRecognitionUUIDs {
    
    NSMutableArray * allUids = [NSMutableArray array];
    
    // get from Tag Array
    for (NSDictionary * tag in self.tags) {
        
        NSArray * arraysOfUids = [tag objectForKey:@"uids"];
        for (NSDictionary * dict in arraysOfUids) {
            [allUids addObject:dict];
        }
    }
    
    NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:allUids.count];
    
    // parse into NGFaceRecognitionUUIDs
    for (NSDictionary * uid in allUids) {
        NGFaceRecognitionUUID * uuid = [[NGFaceRecognitionUUID alloc] initWithDictionary:uid];
        [resultArray addObject:uuid];
    }
    
    return [NSArray arrayWithArray:resultArray];
}

-(NSArray *)getUUIDsForNamespace:(NSString *)nameSpace {
    NSMutableArray * newArray = [NSMutableArray array];
    
    for (NGFaceRecognitionUUID * uuid in self.uuidsInPicture) {
        
        if([uuid.uid hasSuffix:nameSpace]) {
            [newArray addObject:uuid];
        }
        
    }
    
    // always return immutable sh1te
    return [NSArray arrayWithArray:[newArray sortedArrayUsingSelector:@selector(compareByConfidence:)]];
}

@end

@implementation NGFaceRecognitionUUID {
    NSString * strippedUuidCache;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        
        _confidence = [[dictionary objectForKey:@"confidence"] integerValue];
        _uid = [dictionary objectForKey:@"uid"];

        NSArray * stringArray = [_uid componentsSeparatedByString:@"@"];
        strippedUuidCache = [stringArray objectAtIndex:0];
        _nameSpace = [stringArray objectAtIndex:1];
    }
    
    return self;
}

- (NSString *)strippedUid {
    return strippedUuidCache;
}

- (NSComparisonResult)compareByConfidence:(NGFaceRecognitionUUID *)otherObject {
    
    int result;
    
    if (self.confidence < otherObject.confidence)
        result = NSOrderedAscending;
    else if (self.confidence  > otherObject.confidence)
        result = NSOrderedDescending;
    else
        result = NSOrderedSame;
    
    return -result;
}
@end

