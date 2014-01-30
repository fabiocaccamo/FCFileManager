//
//  FCFileManager.h
//
//  Created by Fabio Caccamo on 28/01/14.
//  Copyright (c) 2014 Fabio Caccamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCFileManager : NSObject


+(NSString *)applicationSupportDirectory;
+(NSString *)applicationSupportDirectoryWithPath:(NSString *)path;

+(NSString *)cachesDirectory;
+(NSString *)cachesDirectoryWithPath:(NSString *)path;

+(NSString *)documentsDirectory;
+(NSString *)documentsDirectoryWithPath:(NSString *)path;

+(NSString *)mainBundleDirectory;
+(NSString *)mainBundleDirectoryWithPath:(NSString *)path;

+(NSString *)temporaryDirectory;
+(NSString *)temporaryDirectoryWithPath:(NSString *)path;


+(BOOL)copyFileAtPath:(NSString *)path toPath:(NSString *)toPath;
+(BOOL)copyFileAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *)error;

+(BOOL)createFileAtPath:(NSString *)path;
+(BOOL)createFileAtPath:(NSString *)path error:(NSError *)error;
+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content;
+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content error:(NSError *)error;

+(BOOL)existsFileAtPath:(NSString *)path;

+(NSArray *)listFilesAtPath:(NSString *)path withExtension:(NSString *)extension;

+(BOOL)moveFileAtPath:(NSString *)path toPath:(NSString *)toPath;
+(BOOL)moveFileAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *)error;

+(NSString *)readFileAtPath:(NSString *)path;
+(NSString *)readFileAtPath:(NSString *)path error:(NSError *)error;
+(NSArray *)readFileAtPathAsArray:(NSString *)path;
+(NSData *)readFileAtPathAsData:(NSString *)path;
+(NSData *)readFileAtPathAsData:(NSString *)path error:(NSError *)error;
+(NSDictionary *)readFileAtPathAsDictionary:(NSString *)path;
+(NSDictionary *)readFileAtPathAsJSON:(NSString *)path;
+(NSDictionary *)readFileAtPathAsJSON:(NSString *)path error:(NSError *)error;
+(NSMutableArray *)readFileAtPathAsMutableArray:(NSString *)path;
+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path;
+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path error:(NSError *)error;
+(NSMutableDictionary *)readFileAtPathAsMutableDictionary:(NSString *)path;

+(BOOL)removeFileAtPath:(NSString *)path;
+(BOOL)removeFileAtPath:(NSString *)path error:(NSError *)error;

+(BOOL)removeFilesInSubpathsOfPath:(NSString *)path;
+(BOOL)removeFilesInSubpathsOfPath:(NSString *)path error:(NSError *)error;

+(BOOL)renameFileAtPath:(NSString *)path withName:(NSString *)name;
+(BOOL)renameFileAtPath:(NSString *)path withName:(NSString *)name error:(NSError *)error;

+(NSArray *)subpathsOfPath:(NSString *)path deep:(BOOL)deep;

+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content;
+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *)error;


@end