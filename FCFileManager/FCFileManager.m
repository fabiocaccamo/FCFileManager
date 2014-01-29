//
//  FCFileManager.m
//
//  Created by Fabio Caccamo on 28/01/14.
//  Copyright (c) 2014 Fabio Caccamo. All rights reserved.
//

#import "FCFileManager.h"

@implementation FCFileManager


static NSMutableArray *_absoluteDirectories = nil;

static NSString *_applicationSupportDirectory = nil;
static NSString *_cachesDirectory = nil;
static NSString *_documentsDirectory = nil;
static NSString *_mainBundleDirectory = nil;
static NSString *_temporaryDirectory = nil;


+(NSMutableArray *)absoluteDirectories
{
    if(!_absoluteDirectories){
        _absoluteDirectories = [NSMutableArray arrayWithObjects:
                                [self applicationSupportDirectory],
                                [self cachesDirectory],
                                [self documentsDirectory],
                                [self mainBundleDirectory],
                                [self temporaryDirectory],
                                nil];
        
        [_absoluteDirectories sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return (((NSString *)obj1).length > ((NSString *)obj2).length) ? 0 : 1;
            
        }];
        
        //directories ordered by -length because a directory could be a subpath of another one...
    }
    
    return _absoluteDirectories;
}


+(NSString *)absoluteDirectoryForPath:(NSString *)path
{
    NSMutableArray *directories = [self absoluteDirectories];
    
    for(NSString *directory in directories)
    {
        NSRange indexOfDirectoryInPath = [path rangeOfString:directory];
        
        if(indexOfDirectoryInPath.location == 0)
        {
            return directory;
        }
    }
    
    return nil;
}


+(NSString *)absolutePath:(NSString *)path
{
    NSString *defaultDirectory = [self absoluteDirectoryForPath:path];
    
    if(defaultDirectory != nil)
    {
        return path;
    }
    else {
        return [self documentsDirectoryWithPath:path];
    }
}


+(NSString *)applicationSupportDirectory
{
    if(!_applicationSupportDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        
        _applicationSupportDirectory = [paths lastObject];
    }
    
    return _applicationSupportDirectory;
}


+(NSString *)applicationSupportDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager applicationSupportDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)cachesDirectory
{
    if(!_cachesDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        _cachesDirectory = [paths lastObject];
    }
    
    return _cachesDirectory;
}


+(NSString *)cachesDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager cachesDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)documentsDirectory
{
    if(!_documentsDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        _documentsDirectory = [paths lastObject];
    }
    
    return _documentsDirectory;
}


+(NSString *)documentsDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager documentsDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)mainBundleDirectory
{
    if(!_mainBundleDirectory){
        _mainBundleDirectory = [NSBundle mainBundle].resourcePath;
    }
    
    return _mainBundleDirectory;
}


+(NSString *)mainBundleDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager mainBundleDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)temporaryDirectory
{
    if(!_temporaryDirectory){
        _temporaryDirectory = NSTemporaryDirectory();
    }
    
    return _temporaryDirectory;
}


+(NSString *)temporaryDirectoryWithPath:(NSString *)path 
{
    return [[FCFileManager temporaryDirectory] stringByAppendingPathComponent:path];
}





+(BOOL)copyFileAtPath:(NSString *)path toPath:(NSString *)toPath
{
    return [self copyFileAtPath:path toPath:toPath error:nil];
}


+(BOOL)copyFileAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *)error
{
    NSString *filePath = [self absolutePath:path];
    NSString *fileToPath = [self absolutePath:toPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([self createDirectoriesForPath:fileToPath error:error])
    {
        if([fileManager copyItemAtPath:filePath toPath:fileToPath error:&error])
        {
            return YES;
        }
    }
    
    return NO;
}


+(BOOL)createDirectoriesForPath:(NSString *)path error:(NSError *)error
{
    NSString *filePath = [self absolutePath:path];
    
    NSMutableArray *filePathComponents = [[filePath pathComponents] mutableCopy];
    [filePathComponents removeLastObject];
    
    NSString *filePathParentPath = [NSString pathWithComponents:filePathComponents];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager createDirectoryAtPath:filePathParentPath withIntermediateDirectories:YES attributes:nil error:&error])
    {
        return YES;
    }
    
    return NO;
}


+(BOOL)createFileAtPath:(NSString *)path
{
    return [self createFileAtPath:path withContent:nil error:nil];
}


+(BOOL)createFileAtPath:(NSString *)path error:(NSError *)error
{
    return [self createFileAtPath:path withContent:nil error:error];
}


+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content
{
    return [self createFileAtPath:path withContent:content error:nil];
}


+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content error:(NSError *)error
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![self existsFileAtPath:filePath])
    {
        if([self createDirectoriesForPath:path error:error])
        {
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
            
            if(content != nil)
            {
                [self writeFileAtPath:filePath content:content error:error];
            }
            
            return YES;
        }
    }
    
    return NO;
}


+(BOOL)existsFileAtPath:(NSString *)path
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        return YES;
    }
    
    return NO;
}


+(BOOL)moveFileAtPath:(NSString *)path toPath:(NSString *)toPath
{
    return [self moveFileAtPath:path toPath:toPath error:nil];
}


+(BOOL)moveFileAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *)error
{
    NSString *filePath = [self absolutePath:path];
    NSString *fileToPath = [self absolutePath:toPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([self createDirectoriesForPath:fileToPath error:error])
    {
        if([fileManager moveItemAtPath:filePath toPath:fileToPath error:&error])
        {
            return YES;
        }
    }
    
    return NO;
}


+(NSString *)readFileAtPath:(NSString *)path
{
    return [self readFileAtPath:path error:nil];
}


+(NSString *)readFileAtPath:(NSString *)path error:(NSError *)error
{
    return [NSString stringWithContentsOfFile:[self absolutePath:path] encoding:NSUTF8StringEncoding error:&error];
}


+(NSArray *)readFileAtPathAsArray:(NSString *)path
{
    return [NSArray arrayWithContentsOfFile:[self absolutePath:path]];
}


+(NSData *)readFileAtPathAsData:(NSString *)path
{
    return [self readFileAtPathAsData:path error:nil];
}


+(NSData *)readFileAtPathAsData:(NSString *)path error:(NSError *)error
{
    return [NSData dataWithContentsOfFile:[self absolutePath:path] options:NSDataReadingMapped error:&error];
}


+(NSDictionary *)readFileAtPathAsDictionary:(NSString *)path
{
    return [NSDictionary dictionaryWithContentsOfFile:[self absolutePath:path]];
}


+(NSDictionary *)readFileAtPathAsJSON:(NSString *)path
{
    return [self readFileAtPathAsJSON:path error:nil];
}


+(NSDictionary *)readFileAtPathAsJSON:(NSString *)path error:(NSError *)error
{
    NSData *data = [self readFileAtPathAsData:path error:error];
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if([NSJSONSerialization isValidJSONObject:json])
    {
        return (NSDictionary *)json;
    }
    
    return nil;
}


+(NSMutableArray *)readFileAtPathAsMutableArray:(NSString *)path
{
    return [NSMutableArray arrayWithContentsOfFile:[self absolutePath:path]];
}


+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path
{
    return [self readFileAtPathAsMutableData:path error:nil];
}


+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path error:(NSError *)error
{
    return [NSMutableData dataWithContentsOfFile:[self absolutePath:path] options:NSDataReadingMapped error:&error];
}


+(NSMutableDictionary *)readFileAtPathAsMutableDictionary:(NSString *)path
{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[self absolutePath:path]];
}


+(BOOL)removeFileAtPath:(NSString *)path
{
    return [self removeFileAtPath:path error:nil];
}


+(BOOL)removeFileAtPath:(NSString *)path error:(NSError *)error
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager removeItemAtPath:filePath error:&error])
    {
        return YES;
    }
    
    return NO;
}


+(BOOL)removeFilesInSubpathsOfPath:(NSString *)path
{
    return [self removeFilesInSubpathsOfPath:path error:nil];
}


+(BOOL)removeFilesInSubpathsOfPath:(NSString *)path error:(NSError *)error
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *contentsError;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:filePath error:&contentsError];
    
    if(contentsError != nil)
    {
        error = contentsError;
        
        return NO;
    }
    
    for(NSString *content in contents)
    {
        NSString *contentPath = [filePath stringByAppendingPathComponent:content];
        
        if(![self removeFileAtPath:contentPath error:error])
        {
            return NO;
        }
    }
    
    return YES;
}


+(BOOL)renameFileAtPath:(NSString *)path withName:(NSString *)name
{
    return [self renameFileAtPath:path withName:name error:nil];
}


+(BOOL)renameFileAtPath:(NSString *)path withName:(NSString *)name error:(NSError *)error
{
    NSRange indexOfSlash = [name rangeOfString:@"/"];
    
    if(indexOfSlash.location < name.length)
    {
        error = [NSError errorWithDomain:@"file name can't contain '/'" code:0 userInfo:nil];
        
        return NO;
    }
    
    NSString *filePath = [self absolutePath:path];
    
    NSMutableArray *filePathComponents = [[filePath pathComponents] mutableCopy];
    [filePathComponents removeLastObject];
    [filePathComponents addObject:name];
    
    NSString *filePathRenamed = [NSString pathWithComponents:filePathComponents];
    
    if([self moveFileAtPath:filePath toPath:filePathRenamed error:error])
    {
        return YES;
    }
    
    return NO;
}


+(NSArray *)subpathsOfPath:(NSString *)path deep:(BOOL)deep
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filePathSubpaths;
    
    if(deep)
    {
        filePathSubpaths = [fileManager subpathsOfDirectoryAtPath:filePath error:nil];
    }
    else {
        filePathSubpaths = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
    }
    
    return  filePathSubpaths;
}


+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content
{
    return [self writeFileAtPath:path content:content error:nil];
}


+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *)error
{
    [self createFileAtPath:path withContent:nil error:error];
    
    NSString *filePath = [self absolutePath:path];
    
    @try
    {
        if([content isKindOfClass:[NSArray class]])
        {
            [((NSArray *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSData class]])
        {
            [((NSData *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSDictionary class]])
        {
            [((NSDictionary *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSJSONSerialization class]])
        {
            [((NSDictionary *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSString class]])
        {
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSMutableArray class]])
        {
            [((NSMutableArray *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSMutableData class]])
        {
            [((NSMutableData *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSMutableDictionary class]])
        {
            [((NSMutableDictionary *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSMutableString class]])
        {
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
        }
        else {
            error = [NSError errorWithDomain:@"unsupported content type" code:0 userInfo:nil];
            return NO;
        }
    }
    @catch (NSException *exception)
    {
        error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@ - %@", exception.name, exception.reason] code:0 userInfo:nil];
        
        return NO;
    }
    @finally
    {
    }
    
    return YES;
}


@end