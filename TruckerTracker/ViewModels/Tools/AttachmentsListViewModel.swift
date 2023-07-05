//
//  AttachmentsListViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/15/23.
//

import UIKit

// MARK: - AttachmentsList ViewModel
class AttachmentsListViewModel {
    
    private var attachmentViewModels = [AttachmentViewModel]()
    
    var numberOfRows: Int {
        return attachmentViewModels.count
    }
    
    func model(at index: Int) -> AttachmentViewModel {
        return attachmentViewModels[index]
    }
    
    
    func fetchAttachments() {
        for _ in 0..<10 {
            let viewModel = AttachmentViewModel(attachment: Attachment.getRandomMock())
            attachmentViewModels.append(viewModel)
        }
    }
}


// MARK: - Attachment ViewModel
class AttachmentViewModel {
    
    let attachment: Attachment
    
    init(attachment: Attachment) {
        self.attachment = attachment
    }
    
    var image: UIImage? {
        return SFSymbols.docFill
    }
    
    var title: String {
        return attachment.title
    }
    
    var subtitle: String {
        let itemType = attachment.itemType.title.capitalized
        let attachmentDate = attachment.date.convertToMonthDayYearFormat()
        return "\(itemType) on \(attachmentDate)"
    }
}
