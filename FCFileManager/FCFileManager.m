//
//  FCFileManager.m
//
//  Created by Fabio Caccamo on 28/01/14.
//  Copyright (c) 2014 Fabio Caccamo. All rights reserved.
//

#import "FCFileManager.h"

@implementation FCFileManager


static NSMutableArray *_absoluteDirectories = nil;

static NSString *_pathForApplicationSupportDirectory = nil;
static NSString *_pathForCachesDirectory = nil;
static NSString *_pathForDocumentsDirectory = nil;
static NSString *_pathForMainBundleDirectory = nil;
static NSString *_pathForTemporaryDirectory = nil;


+(NSMutableArray *)absoluteDirectories
{
    if(!_absoluteDirectories){
        _absoluteDirectories = [NSMutableArray arrayWithObjects:
                                [self pathForApplicationSupportDirectory],
                                [self pathForCachesDirectory],
                                [self pathForDocumentsDirectory],
                                [self pathForMainBundleDirectory],
                                [self pathForTemporaryDirectory],
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
    if(!path || [path isEqualToString:@""] || [path isEqualToString:@"/"])
    {
        return nil;
    }
    
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
        return [self pathForDocumentsDirectoryWithPath:path];
    }
}


+(id)attributeOfFileAtPath:(NSString *)path forKey:(NSString *)key
{
    return [[self attributesOfFileAtPath:path] objectForKey:key];
}


+(id)attributeOfFileAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *)error
{
    return [[self attributesOfFileAtPath:path error:error] objectForKey:key];
}


+(NSDictionary *)attributesOfFileAtPath:(NSString *)path
{
    return [self attributesOfFileAtPath:path error:nil];
}


+(NSDictionary *)attributesOfFileAtPath:(NSString *)path error:(NSError *)error
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    
    return attributes;
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


+(NSDate *)creationDateOfFileAtPath:(NSString *)path
{
    return [self creationDateOfFileAtPath:path error:nil];
}


+(NSDate *)creationDateOfFileAtPath:(NSString *)path error:(NSError *)error
{
    return (NSDate *)[self attributeOfFileAtPath:path forKey:NSFileCreationDate error:error];
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


+(BOOL)isEmptyFileAtPath:(NSString *)path
{
    return [self isEmptyFileAtPath:path error:nil];
}


+(BOOL)isEmptyFileAtPath:(NSString *)path error:(NSError *)error
{
    if([[self sizeOfFileAtPath:path error:error] intValue] == 0)
    {
        return YES;
    }
    else {
        return NO;
    }
}


+(BOOL)isExecutableFileAtPath:(NSString *)path
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager isExecutableFileAtPath:filePath];
}


+(BOOL)isReadableFileAtPath:(NSString *)path
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager isReadableFileAtPath:filePath];
}


+(BOOL)isWritableFileAtPath:(NSString *)path
{
    NSString *filePath = [self absolutePath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager isWritableFileAtPath:filePath];
}


+(NSArray *)listContentOfPath:(NSString *)path deep:(BOOL)deep
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
    
    return filePathSubpaths;
}


+(NSArray *)listFilesAtPath:(NSString *)path withExtension:(NSString *)extension
{
    NSArray *pathContent = [self listContentOfPath:path deep:NO];
    
    return [pathContent filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSString *subpath = (NSString *)evaluatedObject;
        NSString *subpathExtension = [[subpath pathExtension] lowercaseString];
        NSString *filterExtension = [extension lowercaseString];
        
        if([subpathExtension isEqualToString:filterExtension])
        {
            return YES;
        }
        
        return NO;
    }]];
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


+(NSString *)pathForApplicationSupportDirectory
{
    if(!_pathForApplicationSupportDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        
        _pathForApplicationSupportDirectory = [paths lastObject];
    }
    
    return _pathForApplicationSupportDirectory;
}


+(NSString *)pathForApplicationSupportDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager pathForApplicationSupportDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)pathForCachesDirectory
{
    if(!_pathForCachesDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        _pathForCachesDirectory = [paths lastObject];
    }
    
    return _pathForCachesDirectory;
}


+(NSString *)pathForCachesDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager pathForCachesDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)pathForDocumentsDirectory
{
    if(!_pathForDocumentsDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        _pathForDocumentsDirectory = [paths lastObject];
    }
    
    return _pathForDocumentsDirectory;
}


+(NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager pathForDocumentsDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)pathForMainBundleDirectory
{
    if(!_pathForMainBundleDirectory){
        _pathForMainBundleDirectory = [NSBundle mainBundle].resourcePath;
    }
    
    return _pathForMainBundleDirectory;
}


+(NSString *)pathForMainBundleDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager pathForMainBundleDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)pathForTemporaryDirectory
{
    if(!_pathForTemporaryDirectory){
        _pathForTemporaryDirectory = NSTemporaryDirectory();
    }
    
    return _pathForTemporaryDirectory;
}


+(NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path
{
    return [[FCFileManager pathForTemporaryDirectory] stringByAppendingPathComponent:path];
}


+(NSString *)readFileAtPath:(NSString *)path
{
    return [self readFileAtPathAsString:path error:nil];
}


+(NSString *)readFileAtPath:(NSString *)path error:(NSError *)error
{
    return [self readFileAtPathAsString:path error:error];
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


+(NSString *)readFileAtPathAsString:(NSString *)path
{
    return [self readFileAtPath:path error:nil];
}


+(NSString *)readFileAtPathAsString:(NSString *)path error:(NSError *)error
{
    return [NSString stringWithContentsOfFile:[self absolutePath:path] encoding:NSUTF8StringEncoding error:&error];
}


+(BOOL)removeContentOfPath:(NSString *)path
{
    return [self removeContentOfPath:path error:nil];
}


+(BOOL)removeContentOfPath:(NSString *)path error:(NSError *)error
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


+(NSNumber *)sizeOfFileAtPath:(NSString *)path
{
    return [self sizeOfFileAtPath:path error:nil];
}


+(NSNumber *)sizeOfFileAtPath:(NSString *)path error:(NSError *)error
{
    return (NSNumber *)[self attributeOfFileAtPath:path forKey:NSFileSize error:error];
}


+(NSURL *)urlForFileAtPath:(NSString *)path
{
    NSString *filePath = [self absolutePath:path];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    return fileURL;
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
        if([content isKindOfClass:[NSMutableArray class]])
        {
            [((NSMutableArray *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSArray class]])
        {
            [((NSArray *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSMutableData class]])
        {
            [((NSMutableData *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSData class]])
        {
            [((NSData *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSMutableDictionary class]])
        {
            [((NSMutableDictionary *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSDictionary class]])
        {
            [((NSDictionary *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSJSONSerialization class]])
        {
            [((NSDictionary *)content) writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSMutableString class]])
        {
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
        }
        else if([content isKindOfClass:[NSString class]])
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

