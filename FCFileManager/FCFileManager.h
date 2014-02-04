//
//  FCFileManager.h
//
//  Created by Fabio Caccamo on 28/01/14.
//  Copyright (c) 2014 Fabio Caccamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCFileManager : NSObject

+(id)attributeOfFileAtPath:(NSString *)path forKey:(NSString *)key;
+(id)attributeOfFileAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *)error;

+(NSDictionary *)attributesOfFileAtPath:(NSString *)path;
+(NSDictionary *)attributesOfFileAtPath:(NSString *)path error:(NSError *)error;

+(BOOL)copyFileAtPath:(NSString *)path toPath:(NSString *)path;
+(BOOL)copyFileAtPath:(NSString *)path toPath:(NSString *)path error:(NSError *)error;

+(BOOL)createFileAtPath:(NSString *)path;
+(BOOL)createFileAtPath:(NSString *)path error:(NSError *)error;

+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content;
+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content error:(NSError *)error;

+(NSDate *)creationDateOfFileAtPath:(NSString *)path;
+(NSDate *)creationDateOfFileAtPath:(NSString *)path error:(NSError *)error;

+(BOOL)existsFileAtPath:(NSString *)path;

+(BOOL)isEmptyFileAtPath:(NSString *)path;
+(BOOL)isEmptyFileAtPath:(NSString *)path error:(NSError *)error;
+(BOOL)isExecutableFileAtPath:(NSString *)path;
+(BOOL)isReadableFileAtPath:(NSString *)path;
+(BOOL)isWritableFileAtPath:(NSString *)path;

+(NSArray *)listContentOfPath:(NSString *)path deep:(BOOL)deep;
+(NSArray *)listFilesAtPath:(NSString *)path withExtension:(NSString *)extension;

+(BOOL)moveFileAtPath:(NSString *)path toPath:(NSString *)toPath;
+(BOOL)moveFileAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *)error;

+(NSString *)pathForApplicationSupportDirectory;
+(NSString *)pathForApplicationSupportDirectoryWithPath:(NSString *)path;

+(NSString *)pathForCachesDirectory;
+(NSString *)pathForCachesDirectoryWithPath:(NSString *)path;

+(NSString *)pathForDocumentsDirectory;
+(NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path;

+(NSString *)pathForMainBundleDirectory;
+(NSString *)pathForMainBundleDirectoryWithPath:(NSString *)path;

+(NSString *)pathForTemporaryDirectory;
+(NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path;

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

+(NSString *)readFileAtPathAsString:(NSString *)path;
+(NSString *)readFileAtPathAsString:(NSString *)path error:(NSError *)error;

+(BOOL)removeContentOfPath:(NSString *)path;
+(BOOL)removeContentOfPath:(NSString *)path error:(NSError *)error;

+(BOOL)removeFileAtPath:(NSString *)path;
+(BOOL)removeFileAtPath:(NSString *)path error:(NSError *)error;

+(BOOL)renameFileAtPath:(NSString *)path withName:(NSString *)name;
+(BOOL)renameFileAtPath:(NSString *)path withName:(NSString *)name error:(NSError *)error;

+(NSNumber *)sizeOfFileAtPath:(NSString *)path;
+(NSNumber *)sizeOfFileAtPath:(NSString *)path error:(NSError *)error;

+(NSURL *)urlForFileAtPath:(NSString *)path;

+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content;
+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *)error;

@end

