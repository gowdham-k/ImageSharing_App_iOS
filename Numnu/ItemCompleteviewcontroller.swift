//
//  ItemCompleteviewcontroller.swift
//  Numnu
//
//  Created by Suraj B on 11/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import Nuke

protocol ItemCompleteviewcontrollerDelegate {
    
    func popupClick()
    func postTableHeight(height : CGFloat)
}
class ItemCompleteviewcontroller : UIViewController {
    var apiClient     : ApiClient!
    var apiType         : String = "Item"
    var popdelegate : ItemCompleteviewcontrollerDelegate?
    var viewState       : Bool = false



    @IBOutlet weak var ItImageView: ImageExtender!
    @IBOutlet weak var ItTitleLabel: UILabel!
    
    @IBOutlet weak var myscrollView: UIScrollView!
    
    @IBOutlet weak var ItDescriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var eventname: UILabel!
    
    
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    var tagarray = ["Festival","Wine","Party"]
    var postList = [PostListDataItems]()
    var postModel  : PostListByEventId?
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet var completemainview: UIView!
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight : NSLayoutConstraint!
    
    @IBOutlet weak var containerviewtop: NSLayoutConstraint!
    @IBOutlet weak var postTableview: UITableView!
    
    var isLabelAtMaxHeight = false
    
    var primaryid       : Int = 149
    var pageno  : Int = 1
    var limitno : Int = 25

    var itemprimaryid   : Int  = 39
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        apiClient = ApiClient()
        /**********************set Nav bar****************************/
        
        setNavBar()
        
        /****************event label tap function************************/
        
        tapRegistration()
        alertTapRegister()
        
        tagViewUpdate()
        
        let eventtap = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.eventtap))
        eventname.addGestureRecognizer(eventtap)
        eventname.isUserInteractionEnabled = true
        
        let businesstap = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.businesstap))
        businessName.addGestureRecognizer(businesstap)
        businessName.isUserInteractionEnabled = true
        
        ItDescriptionLabel.text = Constants.dummy
        
        /****************Checking number of lines************************/
        
        if (ItDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
            
        } else {
            
            readMoreButton.isHidden         = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: ItDescriptionLabel.frame.width, font: ItDescriptionLabel.font)
            containerviewtop.constant = 8
        }
        
        postTableview.delegate   = self
        postTableview.dataSource = self
        postTableview.isScrollEnabled = false
//        ododToCallApi(pageno: pageno, limit: limitno)
       
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        viewState = true

        postList.removeAll()
        postTableview.reloadData()
        pageno  = 1
        limitno = 25
        
        methodToCallApi(pageno: pageno, limit: limitno)

 
    }
    func methodToCallApi(pageno: Int , limit: Int) {
        
        LoadingHepler.instance.show()
        apiClient.getFireBaseToken(completion: { token in
            
            let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getPostList(id: self.primaryid, page: param, type: self.apiType, headers: header, completion: { status,Values in
                
                if status == "success" {
                    
                    if let itemlist = Values {
                        
                        self.postModel = itemlist
                        
                        if let list = itemlist.data {
                            
                            self.postList += list
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.postTableview.reloadData()
                        print("APi\(self.postList.count)")
                    }
                    
                    self.reloadTable()
                    
                }else {
                    
                    LoadingHepler.instance.hide()
                    self.reloadTable()
                    
                }
                
                
            })
        })
        
        
    }
    
    func reloadTable() {
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.mainContainerView.constant = 283 + self.postTableview.contentSize.height
            self.mainContainerViewBottom.constant = 0
            LoadingHepler.instance.hide()
        }
            
          
        
    }
    
    func eventtap(){
        
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: "eventstoryid")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func businesstap(){
        
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.myscrollView.setContentOffset(offset, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewState = true

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            
            readMoreButton.setTitle("more", for: .normal)
            isLabelAtMaxHeight = false
            eventDescriptionHeight.constant = 75
            
            
        } else {
            
            readMoreButton.setTitle("less", for: .normal)
            isLabelAtMaxHeight = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: ItDescriptionLabel.frame.width, font: ItDescriptionLabel.font)
         
        }
     
        
    }
    
    
}

extension ItemCompleteviewcontroller {
    
    /****************event label tap function************************/
    
    func tapRegistration() {
        
        let completemenuTap = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.openCompleteMenu(sender:)))
        completemainview.isUserInteractionEnabled = true
        completemainview.addGestureRecognizer(completemenuTap)
        
    }
    
    func openCompleteMenu(sender:UITapGestureRecognizer) {
        
        openStoryBoard()
        
    }
    
    
    
    /*************************Tag view updating************************************/
    
    func tagViewUpdate() {
        
        var expandableWidth : CGFloat = 0
        
        for (i,text) in tagarray.enumerated() {
            
            let textLabel : UILabel = UILabel()
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: text, fontname: "Avenir-Medium", size: 12)
            textLabel.font = UIFont(name: "Avenir-Medium", size: 12)
            textLabel.text = text
            textLabel.backgroundColor  = UIColor.tagBgColor()
            textLabel.textColor        = UIColor.tagTextColor()
            textLabel.layer.cornerRadius  = 4
            textLabel.layer.masksToBounds = true
            textLabel.textAlignment = .center
            
            if i == 0 {
                
                textLabel.frame = CGRect(x: 0, y: 0, width: textSize.width+20, height: 22)
                
            } else {
                
                textLabel.frame = CGRect(x: expandableWidth, y: 0, width: textSize.width+20, height: 22)
                
            }
            
            expandableWidth += textSize.width+30
            tagScrollView.addSubview(textLabel)
            
        }
        
        tagScrollView.contentSize = CGSize(width: expandableWidth, height: 0)
        tagScrollView.isScrollEnabled = true
        
        
    }
    
    
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = "Item"
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        let button2 : UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button2.setImage(UIImage(named: "eventDots"), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(EventViewController.openPopup), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        let rightButton = UIBarButtonItem(customView: button2)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem  = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func openStoryBoard () {
        
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId) as! ItemDetailController
        vc.itemprimaryid = 39
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func alertTapRegister(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareView.addGestureRecognizer(tap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha                 = 0
            
        }, completion: nil)
        
    }
    
    func openPopup() {
        
        self.shareView.alpha   = 1
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.shareView.isHidden = false
            self.shareView.transform = top
            
        }, completion: nil)
        
        
    }
    
}



extension ItemCompleteviewcontroller : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postEventCell", for: indexPath) as! PostEventTableViewCell
        guard postList.count > 0 else {
            
            return cell
        }
        
        cell.item = postList[indexPath.row]
        cell.delegate = self
        cell.postEventBookMark.tag = indexPath.row
        cell.setHeight(heightview : Float(UIScreen.main.bounds.size.height))
        
        let posteventImagetap = UITapGestureRecognizer(target: self, action: #selector(getter: PostEventTableViewCell.postEventImage))
        cell.postEventImage.addGestureRecognizer(posteventImagetap)
        cell.postEventImage.isUserInteractionEnabled = true
        
        let posteventplacetap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventPlace))
        cell.postEventPlace.addGestureRecognizer(posteventplacetap)
        cell.postEventPlace.isUserInteractionEnabled = true
        
        let posteventplaceIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventPlaceIcon))
        cell.postEventPlaceIcon.addGestureRecognizer(posteventplaceIcontap)
        cell.postEventPlaceIcon.isUserInteractionEnabled = true
        
        
        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventDishLabel))
        cell.postEventDishLabel.addGestureRecognizer(posteventdishtap)
        cell.postEventDishLabel.isUserInteractionEnabled = true
        
        let posteventdishIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventDishIcon))
        cell.postEventDishIcon.addGestureRecognizer(posteventdishIcontap)
        cell.postEventDishIcon.isUserInteractionEnabled = true
        
        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventName))
        cell.postEventName.addGestureRecognizer(posteventnametap)
        cell.postEventName.isUserInteractionEnabled = true
        
        let posteventnameIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventNameIcon))
        cell.postEventNameIcon.addGestureRecognizer(posteventnameIcontap)
        cell.postEventNameIcon.isUserInteractionEnabled = true
        
        let profiletap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postUserImage))
        cell.postUserImage.addGestureRecognizer(profiletap)
        cell.postUserImage.isUserInteractionEnabled = true
        
        let profileusernametap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postUsernameLabel))
        cell.postUsernameLabel.addGestureRecognizer(profileusernametap)
        cell.postUsernameLabel.isUserInteractionEnabled = true
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        openStoryBoard()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if TextSize.sharedinstance.getNumberoflines(text: Constants.dummy, width: tableView.frame.width, font: UIFont(name: "Avenir-Book", size: 16)!) > 1 {
            
            return 428
            
        } else {
            
            return 402
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == postList.count - 1 && viewState {
            
            if let pageItem = postModel {
                
                if postList.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    methodToCallApi(pageno: pageno, limit: limitno)
                }
                
            }
            
        }
    }
    
    func postEventImage() {
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid")
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventPlace() {
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventPlaceIcon(){
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postEventDishLabel(){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func postEventDishIcon(){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postEventName(){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postEventNameIcon(){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postUserImage(){
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
        vc.boolForBack = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func postUsernameLabel(){
        
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
        vc.boolForBack = false
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}


/**************custom delegate******************/

extension ItemCompleteviewcontroller : PostEventTableViewCellDelegate {
    
    func bookmarkPost(tag: Int) {
        
       openPopup()
        
    }

}

