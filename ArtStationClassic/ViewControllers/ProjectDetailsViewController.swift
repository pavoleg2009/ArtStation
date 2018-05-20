import UIKit
import WebKit

final class ProjectDetailsViewController: UIViewController {
    
    @IBOutlet weak var placeholdeView: UIView!
    
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    var detailLink: URL?
    var projectViewModel: ProjectViewModel!
    
    private func loadProjectDetails(from url: URL, to webView: WKWebView) {
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
    private func createWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        placeholdeView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: placeholdeView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: placeholdeView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: placeholdeView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: placeholdeView.trailingAnchor)
            ])
        webView.backgroundColor = AppColor.brandBlack
        webView.scrollView.backgroundColor = AppColor.brandBlack
    }
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        placeholdeView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: placeholdeView.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: placeholdeView.bottomAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: placeholdeView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: placeholdeView.trailingAnchor)
            ])
        activityIndicator.color = AppColor.brandPrimary
    }
    
    private func setTitle() {
        let titleMaxCharCount = 18
        let titleStr = projectViewModel.title
        self.title = (titleStr.count > titleMaxCharCount)
            ? "\(String(titleStr.prefix(titleMaxCharCount)))..."
            : titleStr
    }
    
    
    override func viewDidLoad() {
        setTitle()
        createWebView()
        createActivityIndicator()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let detailLink = detailLink {
            loadProjectDetails(from: detailLink, to: webView)
        }
    }

}

extension ProjectDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
