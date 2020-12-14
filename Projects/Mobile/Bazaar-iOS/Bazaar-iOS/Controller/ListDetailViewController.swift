//
//  ListDetailViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 12.12.2020.
//

import UIKit

class ListDetailViewController: UIViewController {

    @IBOutlet var listNameLabel: UILabel!
    @IBOutlet var productListTableView: UITableView!
    
    var list: CustomerListData!
    let imageCache = NSCache<NSString,UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNameLabel.text = list.name
        productListTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
    }
    
    
    @IBAction func didBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            dismiss(animated: true, completion: nil)
        //segue after add list !!
        if let productDetailVC = segue.destination as? ProductDetailViewController {
            let indexPath = self.productListTableView.indexPathForSelectedRow
            if indexPath != nil {
                productDetailVC.product = list.products[indexPath!.row]
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "listDetailToProductDetailSegue" {
             return self.productListTableView.indexPathForSelectedRow != nil
        }
        return false
    }
    
    
}

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.products.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listDetailToProductDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productListTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
        let product = list.products[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        cell.productDescriptionLabel.text = product.brand
        cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.productPriceLabel.text = "₺"+String(product.price)
        cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        if let url = product.picture {
            do{
                try cell.productImageView.loadImageUsingCache(withUrl: url)
            } catch let error {
                print(error)
                cell.productImageView.image = UIImage(named:"xmark.circle")
                cell.productImageView.tintColor = UIColor.lightGray
            }
        } else {
            cell.productImageView.image = UIImage(named:"xmark.circle")
            cell.productImageView.tintColor = UIColor.lightGray
            cell.productImageView.contentMode = .center
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = self.list.products[indexPath.row]
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                print("index path of delete: \(indexPath)")
            completionHandler(true)
            APIManager().deleteProductFromList(customer: UserDefaults.standard.value(forKey: K.user_id) as! String, list_id: String(self.list.id), product_id: String(product.id)) { (result) in
                switch result {
                case .success(_):
                    alertController.message = "\(product.name) is successfully deleted"
                    self.present(alertController, animated: true, completion: nil)
                    tableView.reloadData()
                case .failure(_):
                    alertController.message = "\(product.name) cannot be deleted"
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}

let imageCache = NSCache<NSString,UIImage>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) throws -> String {
        let url = URL(string: urlString)
        if url == nil { return "url nil" }
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return "image found in cache"
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
        return "done"
    }
}
