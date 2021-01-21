//
//  OnboardingViewController.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 13.01.21.
//

import UIKit

protocol OnboardingDelegate: AnyObject {
    func onboardingViewControllerDidFinish(_ controller: OnboardingViewController)
}

class OnboardingViewController: UIViewController {
    
    // MARK: - Types
    
    private struct OnboardingPageItem {
        let image: UIImage?
        let text: String
    }
    
    private enum Constants {
        
        enum Strings {
            static var firstPageImageName: String { "FirstPageImage" }
            static var firstPageLabelText: String { "Lots of Lightroom Presets" }
            static var secondPageImageName: String { "SecondPageImage" }
            static var secondPageLabelText: String { "A good preset will make you happier" }
            static var thirdPageImageName: String { "ThirdPageImage" }
            static var thirsPageLabelText: String { "Create your own style" }
            static var nextButtonTitle: String { "Next" }
            static var beforeLabelText: String { "Before" }
            static var afterLabelText: String { "After" }
        }
        
        enum UI {
            static var cornerRadius: CGFloat { 10 }
            static var offset: CGFloat { 20 }
            static var buttonBottomOffset: CGFloat { -100 }
            static var buttonHeight: CGFloat { 50 }
            static var pageControlHeight: CGFloat { 50 }
            static var pageControlBottomOffset: CGFloat { 240 }
            static var labelsOffset: CGFloat { 50 }
            static var labelHeight: CGFloat { 30 }
            static var labelWidth: CGFloat { 100 }
        }
    }
    
    // MARK: - Properties
    
    private let pageControlItems: [OnboardingPageItem] = [
        OnboardingPageItem(image: UIImage(named: Constants.Strings.firstPageImageName),
                           text: Constants.Strings.firstPageLabelText),
        OnboardingPageItem(image: UIImage(named: Constants.Strings.secondPageImageName),
                           text: Constants.Strings.secondPageLabelText),
        OnboardingPageItem(image: UIImage(named: Constants.Strings.thirdPageImageName),
                           text: Constants.Strings.thirsPageLabelText)
    ]
    
    weak var delegate: OnboardingDelegate?
    
    // MARK: - GUI
    
    private lazy var scrollView = UIScrollView()
    private lazy var beforeLabel = UILabel()
    private lazy var afterLabel = UILabel()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pageControlItems.count
        
        return pageControl
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Strings.nextButtonTitle, for: .normal)
        button.setTitleColor(.generalBackgroundColor, for: .normal)
        button.titleLabel?.font = .customFont(of: 18, kind: .semiBold)
        button.backgroundColor = .primaryButtonColor
        button.layer.cornerRadius = Constants.UI.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(self.nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        configureScrollView()
        
        view.addSubview(pageControl)
        pageControl.addTarget(self,
                              action: #selector(pageControlDidChange(_:)),
                              for: .valueChanged)
        setupLabels()
        
        view.addSubview(nextButton)
        setNextButtonConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurePageControl()
    }
    
    // MARK: - Methods
    
    private func configureScrollView() {
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pageControlItems.count),
                                        height: view.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        for (index, _) in pageControlItems.enumerated() {
            let page = OnboardingPageView(frame: CGRect(x: scrollView.bounds.width * CGFloat(index),
                                                        y: 0,
                                                        width: view.frame.width,
                                                        height: view.frame.height))
            page.imageView.image = self.pageControlItems[index].image
            page.label.text = self.pageControlItems[index].text
            scrollView.addSubview(page)
            setupGradient(for: page)
        }
    }
    
    private func configurePageControl() {
        pageControl.frame = CGRect(x: Constants.UI.offset,
                                   y: view.frame.height - Constants.UI.pageControlBottomOffset,
                                   width: view.frame.width - Constants.UI.offset * 2,
                                   height: Constants.UI.pageControlHeight)
        beforeLabel.frame = CGRect(x: Constants.UI.labelsOffset,
                                   y: Constants.UI.labelsOffset * 2,
                                   width: Constants.UI.labelWidth,
                                   height: Constants.UI.labelHeight)
        afterLabel.frame = CGRect(x: view.bounds.width-Constants.UI.labelsOffset-beforeLabel.bounds.width,
                                  y: Constants.UI.labelsOffset * 2,
                                  width: Constants.UI.labelWidth,
                                  height: Constants.UI.labelHeight)
    }
    
    private func configureLabel(label: UILabel, text: String) {
        label.text = text.capitalized
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .primaryTextColor
        label.font = .customFont(of: 18, kind: .semiBold)
    }
    
    private func setupLabels() {
        view.addSubview(beforeLabel)
        configureLabel(label: beforeLabel,
                       text: Constants.Strings.beforeLabelText)
        view.addSubview(afterLabel)
        configureLabel(label: afterLabel,
                       text: Constants.Strings.afterLabelText)
    }
    
    private func setupGradient(for view: UIView) {
        let view = view
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: view.bounds.height / 2,
                                width: view.bounds.width,
                                height: view.bounds.height / 2)
        gradient.colors = [UIColor.clear.cgColor, UIColor.generalBackgroundColor.cgColor]
        view.layer.insertSublayer(gradient, at: 1)
    }
    
    private func setNextButtonConstraints() {
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                           constant: Constants.UI.buttonBottomOffset).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor,
                                         constant: Constants.UI.offset).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor,
                                          constant: -Constants.UI.offset).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: Constants.UI.buttonHeight).isActive = true
    }
    
    // MARK: - Actions
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * view.frame.width, y: 0),
                                    animated: true)
    }
    
    @objc private func nextButtonPressed() {
        delegate?.onboardingViewControllerDidFinish(self)
    }
}

// MARK: - Scroll view delegate

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
