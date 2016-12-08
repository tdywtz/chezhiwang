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
    var cellHeight: CGFloat = 0

}


class CentreCommentCell: UITableViewCell {

    lazy var iconImageView: UIImageView = { [unowned self] in
        let iv = UIImageView.init()
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        self.contentView.addSubview(iv)
        return iv
        }()

    lazy var userNameLabel: UILabel = { [unowned self] in
        let label = UILabel.init()
        label.font = UIFont .systemFont(ofSize: 17)
        label.textColor = UIColor.red
        self.contentView.addSubview(label)
        return label
        }()

    lazy var dateLabel: UILabel = { [unowned self] in
        let label = UILabel.init()
        label.font = UIFont .systemFont(ofSize: 14)
        label.textColor = UIColor.orange
        self.contentView.addSubview(label)
        return label
    }()

    lazy var contentLabel: UILabel = { [unowned self] in
        let label = UILabel.init()
        label.font = UIFont .systemFont(ofSize: 17)
        label.textColor = UIColor.black
        self.contentView.addSubview(label)
        return label
        }()

    lazy var titleLabel: UILabel = { [unowned self] in
        let label = UILabel.init()
        label.font = UIFont .systemFont(ofSize: 17)
        label.textColor = UIColor.gray
        self.contentView.addSubview(label)
        return label
        }()


    var model:CentreCommentModel?{
        didSet{
        let _ =  resettring()
        }
    }



    func resettring() -> CGFloat {

        let width = UIScreen.main.bounds.width
        userNameLabel.text = model?.userName
        dateLabel.text = model?.date
        contentLabel.text = model?.content
        titleLabel.text = model?.title

        userNameLabel.sizeToFit()
        dateLabel.sizeToFit()

        titleLabel.sizeToFit()

        userNameLabel.lh_left = iconImageView.lh_right+10
        userNameLabel.lh_top = 10
        userNameLabel.lh_width = width - userNameLabel.lh_left

        dateLabel.lh_left = userNameLabel.lh_left
        dateLabel.lh_top = userNameLabel.lh_bottom + 10;

        contentLabel.lh_left = userNameLabel.lh_left
        contentLabel.lh_top = dateLabel.lh_bottom + 10
        contentLabel.lh_width = width - contentLabel.lh_left
        contentLabel.sizeToFit()

        titleLabel.lh_left = iconImageView.lh_left
        titleLabel.lh_top = contentLabel.lh_bottom + 10
        titleLabel.lh_height = 30


        return titleLabel.lh_bottom  + 10
    }
}


//MARK: <#Description#>

let cellReuseIdentifier = "CentreCommentCell"
class CentreCommentViewController: BasicViewController {

    var _tableView = UITableView()
    var dadaArray = Array<CentreCommentModel>()

    override func viewDidLoad() {
        super.viewDidLoad()

        _tableView = UITableView.init(frame: self.view.frame, style: .plain)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.estimatedRowHeight = 44
        self.view.addSubview(_tableView)

        _tableView.register(CentreCommentCell.classForCoder(), forCellReuseIdentifier: cellReuseIdentifier)
        loadData()

    }

    func loadData() {


        let url = String.localizedStringWithFormat(URLFile.urlStringForDiscuss(),CZWManager.get_userID(),1)
        HttpRequest.get(url, success: { (data: Any?) in

           let cell = CentreCommentCell.init(style: .default, reuseIdentifier: "temp")
            let arr = data as! Array<NSDictionary>
            CentreCommentModel.mj_setupReplacedKey(fromPropertyName: { () -> [AnyHashable : Any]? in
                return ["ID":"id",]
            })
            for dict in  arr {

                let model: CentreCommentModel =  CentreCommentModel.mj_object(withKeyValues:dict)
                cell.model = model
model.cellHeight = cell.resettring()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? CentreCommentCell

        let model = dadaArray[indexPath.row]
        cell?.model = model

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let model = dadaArray[indexPath.row]
        return model.cellHeight
    }
}


