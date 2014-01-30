FCFileManager
=============

**iOS File Manager on top of NSFileManager for simplifying files management.** It provides many static methods for executing most common operations with few lines of code. It works by default in the Documents directory to allow use of relative paths, but it's possible to work easily on any other directory.

#Features
- Build paths relative to absolute directories *(FCFileManager works by default in the Documents directory, so you must build absolute paths only if you need to work outside of the Documents directory)*
- Copy files
- Create files
- Check if files exist
- List files (filtered by extension) or directory content
- Move files
- Read files content as: NSArray, NSData, NSDictionary, NSString...
- Remove files or directory content
- Rename files
- Write files
- Directories are created on the fly
- Error handling as using NSFileManager

#Usage examples

**Build path:**
```objc
//my file path, this will be automatically used as it's relative to the Documents directory
NSString *path = @"test.txt";
//my file path relative to the temporary directory path
NSString *pathTemp = [FCFileManager pathForTemporaryDirectoryWithPath:path];
```

**Copy file:**
```objc
//copy file from Documents directory (public) to ApplicationSupport directory (private)
NSString *path = [FCFileManager pathForApplicationSupportDirectoryWithPath:@"test-copy.txt"];
[FCFileManager copyFileAtPath:@"test.txt" toPath:path];
```

**Create file:**
```objc
//create file and write content to it (if it doesn't exixt)
[FCFileManager createFileAtPath:@"test.txt" withContent:@"File management has never been so easy!!!"];
```

**Check if file exist:**
```objc
//check if file exist and returns YES or NO
BOOL testFileExists = [FCFileManager existsFileAtPath:@"test.txt"];
```

**List directory content or files (filtered by extension):**
```objc
//list content (files and directories) of the specified path
[FCFileManager listContentOfPath:[FCFileManager pathForMainBundleDirectory]];

//list files at the specified path filtered by extension, in this case list all PNGs in the MainBundleDirectory
[FCFileManager listFilesAtPath:[FCFileManager pathForMainBundleDirectory] withExtension:@"png"];
```

**Move file:**
```objc
//move file from a path to another and returns YES or NO
[FCFileManager moveFileAtPath:@"test.txt" toPath:@"tests/test.txt"];
```

**Read file:**
```objc
//read file from path and returns its content (NSString in this case)
NSString *test = [FCFileManager readFileAtPath:@"test.txt"];
```

**Remove files or directory content:**
```objc
//remove all files and directories in the Temporary directory
[FCFileManager removeContentOfPath:[FCFileManager pathForTemporaryDirectory]];

//remove file at the specified path
[FCFileManager removeFileAtPath:@"test.txt"];
```

**Rename file:**
```objc
//rename file at the specified path with the new name
[FCFileManager renameFileAtPath:@"test.txt" withName:@"test-renamed.txt"];
```

**Rename file:**
```objc
//write file at the specified path with content
[FCFileManager writeFileAtPath:@"test.txt" content:@"test-renamed.txt"];
```

#TODO
- documentation
