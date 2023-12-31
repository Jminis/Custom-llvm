// RUN: %clang_cc1 -triple x86_64-apple-darwin -emit-llvm -o %t %s
// RUN: FileCheck < %t %s

typedef struct {} Z;

@interface A
-(void)bar:(Z)a;
-(void)foo:(Z)a : (char*)b : (Z)c : (double) d;
@end

@implementation A
-(void)bar:(Z)a {}
-(void)foo:(Z)a: (char*)b : (Z)c : (double) d {}
@end

// CHECK: private unnamed_addr constant [14 x i8] c"v16@0:8{?=}16
// CHECK: private unnamed_addr constant [26 x i8] c"v32@0:8{?=}16*16{?=}24d24

@interface NSObject @end

@class BABugExample;
typedef BABugExample BABugExampleRedefinition;

@interface BABugExample : NSObject {
    BABugExampleRedefinition *_property; // .asciz   "^{BABugExample=^{BABugExample}}"
}
@property (copy) BABugExampleRedefinition *property;
@end

@implementation BABugExample
@synthesize property = _property;
@end

// CHECK: private unnamed_addr constant [8 x i8] c"@16

@class SCNCamera;
typedef SCNCamera C3DCamera;
typedef struct
{
    C3DCamera *presentationInstance;
}  C3DCameraStorage;

@interface SCNCamera
@end

@implementation SCNCamera
{
    C3DCameraStorage _storage;
}
@end
// CHECK: private unnamed_addr constant [39 x i8] c"{?=\22presentationInstance\22@\22SCNCamera\22}\00"

int i;
typeof(@encode(typeof(i))) e = @encode(typeof(i));
const char * Test(void)
{
    return e;
}
// CHECK: @e ={{.*}} global [2 x i8] c"i\00", align 1
// CHECK: define{{.*}} ptr @Test()
// CHECK: ret ptr @e
