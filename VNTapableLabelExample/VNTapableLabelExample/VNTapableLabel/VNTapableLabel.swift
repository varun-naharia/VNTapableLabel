//
//  VNTapableLabel.swift
//  VNTapableLabelExample
//
//  Created by Varun Naharia on 02/08/19.
//  Copyright © 2019 Technaharia. All rights reserved.
//

import UIKit

protocol VNTapableLabelDelegate {
    func didTapOn(word:String)
}

class VNTapableLabel: UILabel {
    
    var vnDelegate:VNTapableLabelDelegate?
    func enableTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapText(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func tapText(_ gesture : UITapGestureRecognizer) {
        
        
        if let selectedWord = gesture.getTextFrom(self)
        {
            print(selectedWord)
            self.vnDelegate?.didTapOn(word: selectedWord)
        }
    }
    
    
}

extension UITapGestureRecognizer {
    func getWords(_ label:UILabel) -> [[String:String]] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = label.text!.components(separatedBy: chararacterSet)
        let wordsOnly = components
        var index:Int = 0
        var words:[[String:String]] = []
        for word in wordsOnly
        {
            var start = index
            index += word.count
            if(start != 0)
            {
                start += 1
                index += 1
            }
            
            words.append(["word": word, "start":"\(start)", "end":"\(index-1)"])
        }
        
        return words
    }
    
    func getTextFrom(_ label:UILabel ) -> String? {
        let words = getWords(label)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let xTemp = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
        let yTemp = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let textContainerOffset = CGPoint.init(x: xTemp, y:yTemp)
        
        let locationOfTouchInTextContainer = CGPoint.init(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y )
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        print(words)
        print(indexOfCharacter)
        print("\n")
        let selectedWord = words.filter({ indexOfCharacter >= Int($0["start"]!)!  &&  indexOfCharacter <= Int($0["end"]!)! })
        return selectedWord.count > 0 ? selectedWord[0]["word"] : " "
    }
}
