//
//  MNHomeViewController.swift
//  MNWeibo
//
//  Created by miniLV on 2020/3/10.
//  Copyright © 2020 miniLV. All rights reserved.
//

import UIKit

//原创微博
private let originCellID = "originCellID"
//转发微博
private let repostCellID = "repostCellID"

class MNHomeViewController: MNBaseViewController {

    private lazy var listViewModel = MNStatusListViewModel()

    override func loadDatas() {
        
        listViewModel.loadStatus(pullup: self.isPull) { (isSuccess, needRefresh)   in
            self.refreshControl?.endRefreshing()
            self.isPull = false
            if needRefresh{
                self.tableView?.reloadData()
            }
        }
    }

    override func setupNaviTitle(){
        
        let title = MNNetworkManager.shared.userAccount.screen_name
        let button = MNTitleButton(title: title, target: self, action: #selector(clickTitleButton(button:)))
        naviItem.titleView = button
    }
    
    @objc func showFridends() {
        let vc = DemoViewController.init()
        vc.title = "Demo"
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension MNHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: repostCellID, for: indexPath) as! MNHomeRepostCell
        let viewModel = listViewModel.statusList[indexPath.row]
        let cellID = (viewModel.status.retweeted_status == nil) ? originCellID : repostCellID
        
        //FIXME:
        var cell = MNHomeBaseCell()
        if viewModel.status.retweeted_status == nil{
            cell = MNHomeNormalCell(style: .default, reuseIdentifier: cellID)
        }else{
            if viewModel.status.retweeted_status?.pic_urls?.count ?? 0 > 0{
                
            }
            cell = MNHomeRepostCell(style: .default, reuseIdentifier: cellID)
        }

        cell.selectionStyle = .none

        cell.viewModel = viewModel
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.statusList[indexPath.row]
        return viewModel.rowHeight
    }
}

extension MNHomeViewController:MNHomeCellDelegate{
    func homeCellDidClickUrlString(cell: MNHomeNormalCell, urlStr: String) {
        print("urlStr = \(urlStr)")
        let vc = MNWebViewController()
        vc.urlString = urlStr
        vc.title = "123"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MNHomeViewController{

    override func setupTableView() {
        super.setupTableView()
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 250
        tableView?.separatorStyle = .none
        naviItem.leftBarButtonItem = UIBarButtonItem(title: "好友", fontSize: 16, target: self, action: #selector(showFridends))
        
//        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: originCellID)
//        tableView.
    }
}
