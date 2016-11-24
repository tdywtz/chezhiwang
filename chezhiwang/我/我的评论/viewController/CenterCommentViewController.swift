//
//  MyCommentViewController.swift
//  chezhiwang
//
//  Created by bangong on 16/11/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

import UIKit

fileprivate class CentreCommentModel: NSObject {


}

fileprivate class CentreCommentCell: UITableViewCell {

}


/// <#Description#>
class CentreCommentViewController: BasicViewController {

    var _tableView = UITableView()
    let dadaArray = Array<Any>()

    override func viewDidLoad() {
        super.viewDidLoad()


        _tableView = UITableView.init(frame: self.view.frame, style: .plain)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 44
        self.view.addSubview(_tableView)

    }

    func loadData() {
        HttpRequest .get(URLFile.urlStringForDiscuss(), success: { (data) in

        }, failure: { (error) in

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension CentreCommentViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        if cell == nil {
            cell = CentreCommentCell.init(style: .default, reuseIdentifier: "cell")
        }
        return cell!
    }
}
