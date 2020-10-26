#import "AmapSpecialPlugin.h"
#if __has_include(<amap_special/amap_special-Swift.h>)
#import <amap_special/amap_special-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amap_special-Swift.h"
#endif

@implementation AmapSpecialPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmapSpecialPlugin registerWithRegistrar:registrar];
}
@end
