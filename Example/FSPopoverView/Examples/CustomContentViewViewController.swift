//
//  CustomContentViewViewController.swift
//  FSPopoverView_Example
//
//  Created by Sheng on 2023/12/2.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import FSPopoverView

class CustomContentViewViewController: UIViewController {
    
    private var hiddenArrow = false
    private var showsDimBackground = false
    private var shouldDismissOnTapOutside = true
    private var transition: FSPopoverViewAnimatedTransitioning!
    
    private lazy var ghostView: UIView = {
        let label = UILabel()
        label.text = "👻"
        label.font = .systemFont(ofSize: 120.0)
        label.textAlignment = .center
        return label
    }()
    
    private func p_createPopoverView() -> FSPopoverView {
        let popoverView = FSPopoverView()
        popoverView.dataSource = self
        popoverView.showsArrow = !hiddenArrow
        popoverView.showsDimBackground = showsDimBackground
        popoverView.transitioningDelegate = transition
        do {
            // border
//            popoverView.borderWidth = 1.0
//            popoverView.borderColor = .red
        }
        do {
            // shadow
//            popoverView.shadowColor = .green
//            popoverView.shadowRadius = 3.0
//            popoverView.shadowOpacity = 0.6
        }
        return popoverView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transition = FSPopoverViewTransitionScale()
    }
    
    @IBAction func changeHiddenArrow(_ sender: UISwitch) {
        hiddenArrow = sender.isOn ? true : false
    }
    
    @IBAction func changeShowsDimBackground(_ sender: UISwitch) {
        showsDimBackground = sender.isOn ? true : false
    }
    
    @IBAction func changeDismissOnTapOutside(_ sender: UISwitch) {
        shouldDismissOnTapOutside = sender.isOn ? true : false
    }
    
    @IBAction func onDidTapRightBarItem(_ sender: UIBarButtonItem) {
        let popoverView = p_createPopoverView()
        popoverView.present(fromBarItem: sender)
    }
    
    @IBAction func onDidTapPrecentButton(_ sender: UIButton) {
        let popoverView = p_createPopoverView()
        popoverView.present(fromRect: sender.frame.insetBy(dx: 0.0, dy: -6.0), in: view, displayIn: view)
    }
    
    @IBAction func onDidTapPrecentDownButton(_ sender: UIButton) {
        let popoverView = p_createPopoverView()
        popoverView.arrowDirection = .down
        popoverView.autosetsArrowDirection = false
        popoverView.present(fromView: sender)
    }
    
    @IBAction func onDidTapPrecentUpButton(_ sender: UIButton) {
        let popoverView = p_createPopoverView()
        popoverView.arrowDirection = .up
        popoverView.autosetsArrowDirection = false
        popoverView.present(fromView: sender, displayIn: view)
    }
    
    @IBAction func onDidTapChangeTransitionButton(_ sender: UIButton) {
        let items: [FSPopoverListItem] = ["Scale", "Fade", "Translate"].compactMap({ text in
            let item = FSPopoverListTextItem()
            item.title = text
            item.separatorColor = .lightGray
            item.isSeparatorHidden = false
            item.updateLayout()
            item.selectedHandler = { [unowned self] item in
                guard let item = item as? FSPopoverListTextItem else {
                    return
                }
                switch item.title {
                case "Scale":
                    self.transition = FSPopoverViewTransitionScale()
                case "Fade":
                    self.transition = FSPopoverViewTransitionFade()
                case "Translate":
                    self.transition = FSPopoverViewTransitionTranslate()
                default:
                    self.transition = FSPopoverViewTransitionScale()
                }
            }
            return item
        })
        items.last?.isSeparatorHidden = true
        
        let listView = FSPopoverListView(scrollDirection: .vertical)
        listView.items = items
        listView.borderWidth = 1.0
        listView.borderColor = .lightGray
        listView.shadowColor = .lightGray
        listView.shadowRadius = 3.0
        listView.shadowOpacity = 0.5
        listView.showsDimBackground = showsDimBackground
        listView.transitioningDelegate = transition
        listView.shouldDismissOnTapOutside = shouldDismissOnTapOutside
        listView.present(fromRect: sender.frame.insetBy(dx: 0.0, dy: -6.0), in: sender.superview)
    }
}

extension CustomContentViewViewController: FSPopoverViewDataSource {
    
    func backgroundView(for popoverView: FSPopoverView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }
    
    func contentView(for popoverView: FSPopoverView) -> UIView? {
        return ghostView
    }
    
    func contentSize(for popoverView: FSPopoverView) -> CGSize {
        return ghostView.sizeThatFits(.init(width: 1000.0, height: 1000.0))
    }
    
    func containerSafeAreaInsets(for popoverView: FSPopoverView) -> UIEdgeInsets {
        var insets = view.safeAreaInsets
        insets.left = 10.0
        insets.right = 10.0
        return insets
    }
    
    func popoverViewShouldDismissOnTapOutside(_ popoverView: FSPopoverView) -> Bool {
        return shouldDismissOnTapOutside
    }
}
