//  MyUITextView.h
//  TextViewBug
#import <UIKit/UIKit.h>
#import "WordSelectionProtocol.h"
#import "UIFontExt.h"
#import "RichTextStyle.h"

@class RichTextView;
@class RichTextAE;

NS_ASSUME_NONNULL_BEGIN

@interface RichTextTile : UIView
@property(nonatomic, weak) RichTextView *textView;
@end

@protocol RTSelected <NSObject>
-(void)textSelected:(NSString*)text animDuration:(CGFloat)duration hilightView:(UIView <WordSelection>*)view;
@end

typedef UIImage *__nullable(*RichDataGetImageCallback)(int imageNum);

@interface RichTextView : UIScrollView <UIScrollViewDelegate>

@property(nonatomic, strong) NSString *text;
@property(nonatomic, assign) CGSize tileSize;
@property(nonatomic, readonly) NSMutableArray* textRuns;
@property(nonatomic, assign) CGPoint lastPt;
@property(nonatomic, assign) RichTextStyle textStyle;
@property(nonatomic, assign) NSUInteger textColorIndex;
@property(nonatomic, assign) NSUInteger bgColorIndex;
@property(nonatomic, assign) NSInteger hyperlinkIndex;
@property(nonatomic, weak) UIViewController<UIScrollViewDelegate>* controller;
@property(nonatomic, assign) unsigned int topMargin;
@property(nonatomic, assign) unsigned int leftMargin;
@property(nonatomic, assign) unsigned int rightMargin;
@property(nonatomic, assign) unsigned int bottomMargin;
@property(nonatomic, assign) unsigned int lineSpacing;
@property(nonatomic, assign) NSInteger lastAEIndexAccessed;
//@property(nonatomic, assign) NSInteger selectedRun;
//@property(nonatomic, assign) NSRange selectedColumnRange;
@property(nonatomic, weak, nullable) id<RTSelected> selectionDelegate;
@property(nonatomic, assign) BOOL selectionDisabled;
@property(nonatomic, assign, getter=displayFrozen) BOOL freezeDisplay;
@property(nonatomic, assign, nullable) RichDataGetImageCallback richDataGetImageCallback;

@property (nonatomic, readonly) CGFloat fontSize;
@property (nonatomic, readonly) CGFloat fixedFontPointSize;

- (instancetype)initWithFrame: (CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame: (CGRect)frame border:(BOOL)border;
- (void)clearSelection;
- (UIFont*)fontForStyle: (RichTextStyle)style;
- (void) drawRect:(CGRect)rect inView:(RichTextTile*)view;
- (RichTextTile *)tileForRow:(int)row column:(int)column;
- (BOOL)findHotText:(NSString *)text charOffset:(int)charsDone pos:(CGPoint)pos minX:(CGFloat)minXPos hotPoint:(CGPoint*)hotPoint font:(UIFont*)font fontHeight:(CGFloat)fontHeight
 width:(CGFloat) width;
- (void)updateLine:(NSInteger)lineNum withYPos:(CGFloat)yPos;
- (void)updateLine:(NSInteger)lineNum withDescent:(CGFloat)desent;
- (void)updateLine:(NSInteger)lineNum width:(CGFloat)width;
- (BOOL)wordWrapTextSize:(NSString*)text atPoint:(CGPoint*)pos font:(UIFont*)font style:(RichTextStyle)style fgColor:(nullable UIColor*)fgColor
   bgColor:(nullable UIColor*)bgColor withRect:(CGRect)rect  lineNumber:(NSInteger)lineNum nextPos:(CGPoint*)nextPos hotPoint:(nullable CGPoint*)hotPoint doDraw:(BOOL)doDraw;
- (void)appendText:(NSString*)text;
- (void)appendImage:(int)imageNum withAlignment:(int)imageAlign;
- (BOOL)placeImage:(UIImage*)image imageView:(nullable UIImageView*)imageView atPoint:(CGPoint)pt withAlignment:(int)imageAlign prevLineY:(CGFloat)prevY newTextPoint:(CGPoint*)newTextPoint inDraw:(BOOL)inDraw textStyle:(RichTextStyle)textStyle;
- (NSInteger) getTextRunAtPoint:(CGPoint)touchPoint;
- (int)hyperlinkAtPoint:(CGPoint)point;
- (void)populateZeroHyperlinks;
- (nullable RichTextTile *)dequeueReusableTile;
- (void)prepareForKeyboardShowHide;
- (void)rememberTopLineForReflow;
@property (nonatomic, getter=getCurrentTextColor, readonly, copy) UIColor *currentTextColor;
- (void)resetColors;
- (void)resetMargins;
- (void)setNiceMargins:(BOOL)reflow;
- (void)setNoMargins;
- (void)layoutSubviews;
- (void)reloadData;
- (void)reset;
- (void)clear;
- (void)reflowText;
- (void)repositionAfterReflow;
- (void)reloadImages;
@property (nonatomic, weak) UIViewController<UIScrollViewDelegate> *delegate;
@property (nonatomic, copy) UIFont *font;
@property (nonatomic, copy) UIFont *fixedFont;
@property (nonatomic, readonly) CGSize fixedFontSize;
- (BOOL)setFontFamily:(NSString*)fontFamily size:(NSInteger)newSize;
- (BOOL)setFixedFontFamily:(NSString*)familyName size:(NSInteger)newSize;
- (void)setFontSize:(CGFloat)newFontSize;
- (void)setTextColor:(UIColor*)color;
@property (nonatomic, readonly) CGRect visibleRect;
- (NSUInteger)getOrAllocColorIndex:(UIColor*)color;
- (void)populateAccessibilityElements;
- (void)clearAE;
@property (nonatomic, readonly, strong, nullable) RichTextAE *updateAE;
- (void)appendAE;
- (void)markWaitForInput;
@property (nonatomic, getter=getTextPos, readonly, copy) NSArray *textPos;
@property (nonatomic, getter=getSaveDataDict, readonly, copy) NSDictionary *saveDataDict;
- (void)restoreFromSaveDataDict: (NSDictionary*)saveData;
@property (nonatomic, readonly) CGPoint cursorPoint;
@end

NS_ASSUME_NONNULL_END

