//
//  RichTextView.swift
//  Frotz
//
//  Created by C.W. Betts on 8/26/15.
//
//

import UIKit
import QuartzCore.CALayer

private var hasAccessibility = false

private let DEFAULT_TILE_WIDTH = 1024 // 512
private let DEFAULT_TILE_HEIGHT = 120 // 120

private let TEXT_TOP_MARGIN     = 16
private let TEXT_RIGHT_MARGIN   = 6
private let TEXT_LEFT_MARGIN    = 6
private let TEXT_BOTTOM_MARGIN  = 8


private func DrawViewBorder(context: CGContextRef, x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, x1, y1);
    CGContextAddLineToPoint(context, x2, y2);
    CGContextClosePath(context);
    CGContextDrawPath(context, .Stroke);
}

@objc protocol RTSelected: NSObjectProtocol {
    func textSelected(text: String, animDuration duration: CGFloat, hilightView view: UIView/*<WordSelection>*/)
}

typealias RichDataGetImageCallback = @convention(c) (imageNum: Int32) -> UIImage?


class RichTextTile: UIView {
    weak var textView: RichTextView?
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        textView?.drawRect(rect, inView: self)
    }
}

class RichTextView: UIScrollView {
    /*
NSMutableString *m_text;
CGFloat m_fontSize, m_fixedFontSize;
CGSize m_tileSize;
NSInteger m_numLines;
NSMutableArray *m_textRuns;   // text fragments
NSMutableArray *m_textStyles; // bit set, bold, italic, etc.
NSMutableArray *m_colorIndex; // fg/bg color for run
NSMutableArray *m_hyperlinks;

NSMutableArray *m_textPos;     // beginning point of each text run
NSMutableArray *m_textLineNum; // which line (0..n) each run starts on

NSMutableArray *m_lineYPos;    // Y position of each line; indexed by line number, not run
NSMutableArray *m_lineWidth;    // width of each text line
NSMutableArray *m_lineDescent;  // height of line below text origin

NSMutableArray *m_imageviews;  // inline image views container
NSMutableArray *m_imageIDs;

NSMutableArray *m_colorArray;
UIColor *m_fgColor, *m_bgColor;
UIColor *m_currBgColor; // weak ref
NSInteger m_firstVisibleTextRunIndex;
CGFloat m_savedTopYOffset;

unsigned int m_topMargin, m_leftMargin, m_rightMargin, m_bottomMargin;
unsigned int m_tempLeftMargin, m_tempRightMargin;
unsigned int m_tempLeftYThresh, m_tempRightYThresh;
unsigned int m_extraLineSpacing;

CGPoint m_prevPt, m_lastPt;

UIFont *m_normalFont, *m_boldFont;
UIFont *m_italicFont, *m_boldItalicFont;
UIFont *m_fixedNormalFont, *m_fixedBoldFont;
UIFont *m_fixedItalicFont, *m_fixedBoldItalicFont;

RichTextStyle m_currentTextStyle;
NSUInteger m_currentTextColorIndex, m_currentBGColorIndex;
NSInteger m_hyperlinkIndex;

NSMutableSet *m_reusableTiles;
UIView *m_tileContainerView;
CGFloat m_fontHeight, m_fixedFontHeight, m_fixedFontWidth, m_fontMinWidth, m_fontMaxWidth;
CGFloat m_firstVisibleRow, m_firstVisibleColumn, m_lastVisibleRow, m_lastVisibleColumn;
UIViewController<UIScrollViewDelegate> *__weak m_controller;

CGFloat m_origY;
BOOL m_prevLineNotTerminated;

NSMutableArray *m_accessibilityElements;
NSInteger m_lastAEIndexAccessed, m_lastAEIndexAnnounced;

NSInteger m_selectedRun;
NSRange m_selectedColumnRange;
UILabelWA *m_selectionView;
BOOL m_selectionDisabled;
BOOL m_hyperlinkTest;

NSObject<RTSelected>* __weak m_selectionDelegate;

BOOL m_freezeDisplay;
CGRect m_delayedFrame;
CGRect m_origFrame;
*/
    
    var text: String {
        get {
            var text = ""
            for t in textRuns {
                text += t
            }
            return text
        }
        set {
            clear()
            textStyle = []
            
            let text = newValue as NSString
            let length = text.length
            var p = NSMakeRange(0, length)
            var r = text.rangeOfString("\n\n")
            
            while r.length != 0 {
                let nlPos = r.location
                r.location += 1
                while text.characterAtIndex(r.location) == 10 {
                    r.location += 1
                }
                if nlPos > 0 {
                    self.appendText(text.substringWithRange(NSMakeRange(p.location, r.location-p.location)))
                    r.length = length - r.location
                    p = r
                } else {
                    r.length = length - r.location
                }
                r = text.rangeOfString("\n\n", options: [], range: r)
            }
            
            self.appendText(text.substringWithRange(NSMakeRange(p.location, length - p.location)))
        }
    }
    var tileSize: CGSize = .zero
    private(set) var textRuns = [String]()
    var lastPt = CGPoint.zero
    var textStyle = RichTextStyle.Normal
    var textColorIndex: UInt = 0
    var bgColorIndex: UInt = 0
    var hyperlinkIndex = 0
    weak var controller: UIViewController?
    var topMargin: UInt32 = 0
    var leftMargin: UInt32 = 0
    var rightMargin: UInt32 = 0
    var bottomMargin: UInt32 = 0
    var lineSpacing: UInt32 = 0
    var lastAEIndexAccessed = 0
    weak var selectionDelegate: RTSelected?
    var selectionDisabled = false
    var richDataGetImageCallback: RichDataGetImageCallback?
    
    
    var textPos = [CGPoint]()
    let m_origFrame: CGRect

    override init(frame: CGRect) {
        m_origFrame = frame;
        
        super.init(frame: frame)
        

        
        autoresizesSubviews = true
        autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

    }
    
    private func appendText(text: String) {
        
    }
    
    convenience init(frame: CGRect, border: Bool) {
        self.init(frame: frame)
        let layer = self.layer
        layer.borderWidth = border ? 0.5 : 0
        layer.borderColor = UIColor.blackColor().CGColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clear() {
        
    }
    
    func drawRect(rect: CGRect, inView: RichTextTile) {

    }
}

class RichTextAE: UIAccessibilityElement {
    private var textIndex = 0
    private var aeIndex = 0
    private var runCount: UInt = 0
    
    override var accessibilityFrame: CGRect {
        get {
            if let v = accessibilityContainer as? RichTextView {
                v.lastAEIndexAccessed = aeIndex
                
                // update frame lazily when accessed, so we don't have to recalculate them all
                // when you reorient the device
                let startIndex = textIndex
                let runCount = self.runCount
                let textPos = v.textPos
                let count = textPos.count
                let endIndex = startIndex + Int(runCount) - 1
                if count == 0 || startIndex >= count || endIndex >= count {
                    return .zero
                }
                var p = textPos[startIndex]
                let p2 = endIndex < count - 1 ? textPos[endIndex + 1] : v.lastPt
                if p.x <= CGFloat(v.leftMargin) {
                    p.x = 0
                }
                var height = p2.y - p.y
                let width: CGFloat
                if height == 0 {
                    height = 10
                    width = p2.x - p.x
                } else {
                    p.x = 0
                    width = v.frame.size.height
                }
                
                var r = CGRect(x: p.x, y: p.y + CGFloat(v.topMargin), width: width, height: height)
                let window = v.window!
                r = v.convertRect(r, toView: window)
                r = window.convertRect(r, toWindow: nil)
                
                return r
            }
            return .zero
        }
        set {
            //do nothing
        }
    }
}


