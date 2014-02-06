FCFileManager
=============

**iOS File Manager on top of NSFileManager for simplifying files management.** It provides many static methods for executing most common operations with few lines of code. It works by default in the Documents directory to allow use of relative paths, but it's possible to work easily on any other directory.

#Features
- Build paths relative to absolute directories *(FCFileManager works by default in the Documents directory, so you must build absolute paths only if you need to work outside of the Documents directory)*
- Copy files/directories
- Create files/directories
- Check if files/directory exists
- Get files/directories attributes
- Get files/directories creation date
- Get files/directories size
- List files/directories
- Move files/directories
- Read files content in different formats
- Remove files/directories
- Rename files/directories
- Write files content
- Directories are created on the fly
- Error handling as using NSFileManager

For the full list give a look to the APIs section!

#Usage examples

**Build path:**
```objc
//my file path, this will be automatically used as it's relative to the Documents directory
NSString *testPath = @"test.txt";
//my file path relative to the temporary directory path
NSString *testPathTemp = [FCFileManager pathForTemporaryDirectoryWithPath:testPath];
```

**Copy file:**
```objc
//copy file from Documents directory (public) to ApplicationSupport directory (private)
NSString *testPath = [FCFileManager pathForApplicationSupportDirectoryWithPath:@"test-copy.txt"];
[FCFileManager copyFileAtPath:@"test.txt" toPath:testPath];
```

**Create file:**
```objc
//create file and write content to it (if it doesn't exist)
[FCFileManager createFileAtPath:@"test.txt" withContent:@"File management has never been so easy!!!"];
```

**Check if file exist:**
```objc
//check if file exist and returns YES or NO
BOOL testFileExists = [FCFileManager existsItemAtPath:@"test.txt"];
```

**Move file:**
```objc
//move file from a path to another and returns YES or NO
[FCFileManager moveItemAtPath:@"test.txt" toPath:@"tests/test.txt"];
```

**Read file:**
```objc
//read file from path and returns its content (NSString in this case)
NSString *test = [FCFileManager readFileAtPath:@"test.txt"];
```

**Remove files or directory content:**
```objc
//remove file at the specified path
[FCFileManager removeItemAtPath:@"test.txt"];
```

**Rename file:**
```objc
//rename file at the specified path with the new name
[FCFileManager renameItemAtPath:@"test.txt" withName:@"test-renamed.txt"];
```

**Write file:**
```objc
NSArray *testContent = [NSArray arrayWithObjects:@"t", @"e", @"s", @"t", nil];

//write file at the specified path with content
[FCFileManager writeFileAtPath:@"test.txt" content:testContent];
```

#APIs
```objc
+(id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key;
+(id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError **)error;

+(NSDictionary *)attributesOfItemAtPath:(NSString *)path;
+(NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError **)error;

+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)path;
+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)path error:(NSError **)error;

+(BOOL)createFileAtPath:(NSString *)path;
+(BOOL)createFileAtPath:(NSString *)path error:(NSError **)error;

+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content;
+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content error:(NSError **)error;

+(NSDate *)creationDateOfItemAtPath:(NSString *)path;
+(NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError **)error;

+(BOOL)existsItemAtPath:(NSString *)path;

+(BOOL)isDirectoryItemAtPath:(NSString *)path;
+(BOOL)isDirectoryItemAtPath:(NSString *)path error:(NSError **)error;
+(BOOL)isEmptyItemAtPath:(NSString *)path;
+(BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError **)error;
+(BOOL)isFileItemAtPath:(NSString *)path;
+(BOOL)isFileItemAtPath:(NSString *)path error:(NSError **)error;
+(BOOL)isExecutableItemAtPath:(NSString *)path;
+(BOOL)isReadableItemAtPath:(NSString *)path;
+(BOOL)isWritableItemAtPath:(NSString *)path;

+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path;
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension;
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix;
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix;
+(NSArray *)listItemsInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath;
+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

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
+(NSString *)readFileAtPath:(NSString *)path error:(NSError **)error;

+(NSArray *)readFileAtPathAsArray:(NSString *)path;

+(NSData *)readFileAtPathAsData:(NSString *)path;
+(NSData *)readFileAtPathAsData:(NSString *)path error:(NSError **)error;

+(NSDictionary *)readFileAtPathAsDictionary:(NSString *)path;

+(NSDictionary *)readFileAtPathAsJSON:(NSString *)path;
+(NSDictionary *)readFileAtPathAsJSON:(NSString *)path error:(NSError **)error;

+(NSMutableArray *)readFileAtPathAsMutableArray:(NSString *)path;

+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path;
+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path error:(NSError **)error;

+(NSMutableDictionary *)readFileAtPathAsMutableDictionary:(NSString *)path;

+(NSString *)readFileAtPathAsString:(NSString *)path;
+(NSString *)readFileAtPathAsString:(NSString *)path error:(NSError **)error;

+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path;
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path error:(NSError **)error;
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension;
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension error:(NSError **)error;
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix;
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix error:(NSError **)error;
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix;
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix error:(NSError **)error;

+(BOOL)removeItemsInDirectoryAtPath:(NSString *)path;
+(BOOL)removeItemsInDirectoryAtPath:(NSString *)path error:(NSError **)error;

+(BOOL)removeItemAtPath:(NSString *)path;
+(BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error;

+(BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name;
+(BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name error:(NSError **)error;

+(NSNumber *)sizeOfItemAtPath:(NSString *)path;
+(NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError **)error;

+(NSURL *)urlForItemAtPath:(NSString *)path;

+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content;
+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError **)error;
```

#TODO
- documentation
