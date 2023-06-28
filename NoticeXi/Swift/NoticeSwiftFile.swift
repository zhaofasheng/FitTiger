//
//  NoticeSwiftFile.swift
//  NoticeXi
//
//  Created by li lei on 2019/8/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeSwiftFile: NSObject {
    
   static let screenHeight = UIScreen.main.bounds.size.height;
   static let screenWidth = UIScreen.main.bounds.size.width;
        
   static func isiPhoneX() ->Bool {
       if #available(iOS 11, *) {
             guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                 return false
             }
             
             if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                 print(unwrapedWindow.safeAreaInsets)
                 return true
             }
       }
       return false
    }
    
   static func NAVHEIGHT() -> CGFloat {
        if isiPhoneX() {
            return 84.0
        }
        return 64.0
    }
   
   static func STATUSHEIGHT() -> CGFloat {
        if isiPhoneX() {
            return 44.0
        }
        return 20.0
    }
    
   static func BOTTOMHEIGHT() -> CGFloat {
        if isiPhoneX() {
            return 34.0
        }
        return 0.0
    }
    
    static func TABBARHEIGHT() -> CGFloat {
         if isiPhoneX() {
             return 83.0
         }
         return 49.0
     }
     
  
    static func getSwiftTextWidth(str:String,height:CGFloat,font:Int) -> CGFloat{
        return str.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT),height: height),options:.usesLineFragmentOrigin,attributes:[NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(font))],context:nil).size.width
    }
    
    static func getSwiftTextHeight(str:String,width:CGFloat,font:Int) -> CGFloat{
        return str.boundingRect(with: CGSize(width: width,height: CGFloat(MAXFLOAT)),options:.usesLineFragmentOrigin,attributes:[NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(font))],context:nil).size.height
       }
}
