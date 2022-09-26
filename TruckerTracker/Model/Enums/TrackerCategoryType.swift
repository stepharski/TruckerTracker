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
            return #colorLiteral(red: 1, green: 0.1607843137, blue: 0.09019607843, alpha: 1)
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
            return [#colorLiteral(red: 0.7490196078, green: 0.1333333333, blue: 0.07843137255, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.0431372549, blue: 0.02352941176, alpha: 1)]
        case .fuel:
            return [#colorLiteral(red: 0.4509803922, green: 0.1098039216, blue: 0.07058823529, alpha: 1), #colorLiteral(red: 0.05490196078, green: 0.01176470588, blue: 0.007843137255, alpha: 1)]
        }
    }
    
    var contrastGradientColors: [UIColor] {
        switch self {
        case .gross:
            return [#colorLiteral(red: 0.1176470588, green: 0.2235294118, blue: 0.1960784314, alpha: 1), #colorLiteral(red: 0.1125063226, green: 0.1943914294, blue: 0.1672864556, alpha: 1)]
        case .miles:
            return [#colorLiteral(red: 0.1568627451, green: 0.4352941176, blue: 0.3215686275, alpha: 1), #colorLiteral(red: 0.01900070347, green: 0.08035971969, blue: 0.02665106393, alpha: 1)]
        case .expenses:
            return [#colorLiteral(red: 0.231372549, green: 0.07843137255, blue: 0.05882352941, alpha: 1), #colorLiteral(red: 0.2976229489, green: 0.05207278579, blue: 0.03022488952, alpha: 1)]
        case .fuel:
            return [#colorLiteral(red: 0.7490196078, green: 0.1294117647, blue: 0.07843137255, alpha: 1), #colorLiteral(red: 0.09479983896, green: 0.02081591263, blue: 0.01330549922, alpha: 1)]
        }
    }
    
    var gradientLocations: [NSNumber] {
        return [0, 1]
    }
    
    var title: String {
        return self.rawValue
    }
}
