FCFileManager
=============

iOS File Manager on top of NSFileManager for simplifying files management. It provides many static methods for executing most common operations with few lines of code. It works by default in the Documents directory to allow use of relative paths, but it's possible to work easily on any other directory.

#Features
- build paths relative to absolute directories
- copy files
- create files
- check if files exist
- list files in folder
- move files
- read files content as: NSArray, NSData, NSDictionary, NSMutableArray, NSMutableData, NSMutableDictionary, NSString
- remove files
- rename files
- write files
- directories are created on the fly
- error handling as using NSFileManager

#Usage
##Build paths:
FCFileManager works by default in the Documents directory, so you must build absolute paths only if you need to work outside of the Documents directory.

Example:

```objective-c
//my file path, this will be automatically used as it's relative to the Documents directory
NSString *path = @"data.xml";

//my file path relative to the temporary directory path
NSString *pathTemp = [FCFileManager pathForTemporaryDirectoryWithPath:path];
```
