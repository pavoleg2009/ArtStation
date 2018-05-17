import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        label1.font = AppFont.brandLight(ofSize: 17)
        label1.text = "Neque porro quisquam est qui dolorem ipsum"
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
        
        let label2 = UILabel()
        label2.font = AppFont.brandRegular(ofSize: 17)
        label2.text = "Neque porro quisquam est qui dolorem ipsum"
        label2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label2)
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: label1.topAnchor, constant: 40),
            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
        
        let label3 = UILabel()
        label3.font = AppFont.brandSemibold(ofSize: 17)
        label3.text = "Neque porro quisquam est qui dolorem ipsum"
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label3)
        NSLayoutConstraint.activate([
            label3.topAnchor.constraint(equalTo: label2.topAnchor, constant: 40),
            label3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
        
        let label4 = UILabel()
        label4.font = AppFont.brandBold(ofSize: 17)
        label4.text = "Neque porro quisquam est qui dolorem ipsum"
        label4.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label4)
        NSLayoutConstraint.activate([
            label4.topAnchor.constraint(equalTo: label3.topAnchor, constant: 40),
            label4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
        
//        for family: String in UIFont.familyNames {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
        
    }

}

