//
//  RichTextStyle.h
//  Frotz
//
//  Created by Craig Smith on 6/1/11.
//  Copyright 2011 Craig Smith. All rights reserved.
//

#include <CoreFoundation/CFBase.h>


typedef CF_OPTIONS(unsigned int, RichTextStyle) {
    RichTextStyleNormal=0,
    RichTextStyleBold=1 << 0,
    RichTextStyleItalic=1<<1,
    RichTextStyleFixedWidth=1<<2,
    RichTextStyleFontStyleMask=7,
    RichTextStyleReverse=1<<3,
    RichTextStyleNoWrap=1<<4,
    RichTextStyleRightJustification=1<<5,
    RichTextStyleCentered=1<<6,
    RichTextStyleImage=1<<9,
    RichTextStyleInMargin=1<<10
};
enum { kFTImageNumShift = 20 };

#pragma mark compatibility macros
#define kFTNormal RichTextStyleNormal
#define kFTBold RichTextStyleBold
#define kFTItalic RichTextStyleItalic
#define kFTFixedWidth RichTextStyleFixedWidth
#define kFTFontStyleMask RichTextStyleFontStyleMask
#define kFTReverse RichTextStyleReverse
#define kFTNoWrap RichTextStyleNoWrap
#define kFTRightJust RichTextStyleRightJustification
#define kFTCentered RichTextStyleCentered
#define kFTImage RichTextStyleImage
#define kFTInMargin RichTextStyleInMargin
