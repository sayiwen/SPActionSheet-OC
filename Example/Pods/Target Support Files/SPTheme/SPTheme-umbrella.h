#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SPColor.h"
#import "SPFont.h"
#import "SPTheme.h"

FOUNDATION_EXPORT double SPThemeVersionNumber;
FOUNDATION_EXPORT const unsigned char SPThemeVersionString[];

