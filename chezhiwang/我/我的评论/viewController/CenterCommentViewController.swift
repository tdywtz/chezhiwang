//
//  MyCommentViewController.swift
//  chezhiwang
//
//  Created by bangong on 16/11/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

import UIKit


class CentreCommentModel: NSObject {

    var title = String()
    var ID = String()
    var issuedate = String()//提问时间
    var type = String()
    var date = String()//评论时间
    var content = String()
    var userName = String()
}


class CentreCommentCell: UITableViewCell {

    let iconImageView = UIImageView.init()
    let titleLabel = UILabel()

   override  init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView .addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}


/// <#Description#>
class CentreCommentViewController: BasicViewController {

    var _tableView = UITableView()
    var dadaArray = Array<CentreCommentModel>()

    override func viewDidLoad() {
        super.viewDidLoad()

        _tableView = UITableView.init(frame: self.view.frame, style: .plain)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 44
        self.view.addSubview(_tableView)
     
        loadData()

    }

    func loadData() {


        let url = String.localizedStringWithFormat(URLFile.urlStringForDiscuss(),CZWManager.get_userID(),1)
        HttpRequest.get(url, success: { (data: Any?) in


            let arr = data as! Array<NSDictionary>
            CentreCommentModel.mj_setupReplacedKey(fromPropertyName: { () -> [AnyHashable : Any]? in
                return ["ID":"id"]
            })
                for dict in  arr {

                    let model: CentreCommentModel =  CentreCommentModel.mj_object(withKeyValues:dict)
                    self.dadaArray.append(model)
                    self._tableView.reloadData()

            }
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

        return dadaArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        if cell == nil {
            cell = CentreCommentCell.init(style: .default, reuseIdentifier: "cell")
        }
        let model = dadaArray[indexPath.row]
        cell?.textLabel?.text = model.ID

        return cell!
    }
}
