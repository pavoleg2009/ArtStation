import UIKit
import WebKit

class ProjectDetailsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var detailLink: URL?
    
    private func loadProjectDetails(from url: URL, to webView: WKWebView) {
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let detailLink = detailLink {
            loadProjectDetails(from: detailLink, to: webView)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
