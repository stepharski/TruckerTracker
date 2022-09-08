//
//  TrackerCategoryType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/7/22.
//

import UIKit

enum TrackerCategoryType: String, CaseIterable {
    case gross, expenses, miles, fuel
    
    var image: UIImage? {
        switch self {
        case .gross:
            return SFSymbols.dollar
        case .miles:
            return SFSymbols.doubleCircle
        case .expenses:
            return SFSymbols.minusCircle
        case .fuel:
            return SFSymbols.flame
        }
    }
    
    var imageTintColor: UIColor {
        switch self {
        case .gross:
            return #colorLiteral(red: 0, green: 0.8392156863, blue: 0.4941176471, alpha: 1)
        case .expenses:
            return #colorLiteral(red: 0.9019607843, green: 0.07058823529, blue: 0, alpha: 1)
        case .miles:
            return #colorLiteral(red: 0.1882352941, green: 0.631372549, blue: 0.4470588235, alpha: 1)
        case .fuel:
            return #colorLiteral(red: 0.8509803922, green: 0.2901960784, blue: 0.2235294118, alpha: 1)
        }
    }
    
    var gradientColors: [UIColor] {
        switch self {
        case .gross:
            return [#colorLiteral(red: 0.1921568627, green: 0.6431372549, blue: 0.4549019608, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1450980392, blue: 0.1333333333, alpha: 1)]
        case .miles:
            return [#colorLiteral(red: 0.168627451, green: 0.2509803922, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 0, green: 0.06274509804, blue: 0, alpha: 1)]
        case .expenses:
            return [#colorLiteral(red: 0.7058823529, green: 0.2745098039, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.0431372549, blue: 0.02352941176, alpha: 1)]
        case .fuel:
            return [#colorLiteral(red: 0.4509803922, green: 0.1098039216, blue: 0.07058823529, alpha: 1), #colorLiteral(red: 0.05490196078, green: 0.01176470588, blue: 0.007843137255, alpha: 1)]
        }
    }
    
    var gradientLocations: [NSNumber] {
        return [0, 1]
    }
    
    var title: String {
        return self.rawValue
    }
}
