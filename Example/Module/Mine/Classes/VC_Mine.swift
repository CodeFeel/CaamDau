//Created  on 2018/12/16  by LCD :https://github.com/liucaide .

import UIKit

import PencilKit


public struct R_Mine: RowVCProtocol {
    public init(){}
    public var vc: UIViewController {
        return VC_Mine.cd_storyboard("MineStoryboard", from: "Mine") as! VC_Mine
    }
}
class VC_Mine: UIViewController {
    @IBOutlet weak var topBar: TopBar!
    @IBOutlet weak var tableView: UITableView!
    
    var vm:VM_Mine = VM_Mine()
    var delegateData:VC_MineTableViewDelegateDataSource?
    lazy var modelMj:RefreshModel = {
        var m = RefreshModel()
        let ass = Assets()
        let arr = [ass.refresh_0,
                   ass.refresh_1,
                   ass.refresh_2,
                   ass.refresh_3,
                   ass.refresh_4,
                   ass.refresh_5,
                   ass.refresh_6,
                   ass.refresh_7]
        m.down_imgIdle = arr
        m.down_imgPulling = arr
        m.down_imgWillRefresh = arr
        m.down_imgRefreshing = arr
        return m
    }()
    
    var tableViewHeaderHeight:CGFloat = 220
    lazy var tableViewHeader: UIView = {
        let vv = UIView(frame: CGRect(w: CD.screenW, h: tableViewHeaderHeight))
        vv.addSubview(tableViewHeaderImgBg)
        tableViewHeaderImgBg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableViewHeaderImgBg.contentMode = .scaleAspectFill
        tableViewHeaderImgBg.clipsToBounds = true
        tableViewHeaderImgBg.cd.blurEffect(block: { (v) in
            v.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        })
        vv.addSubview(tableViewHeaderImgLogo)
        tableViewHeaderImgLogo.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        tableViewHeaderImgLogo.cd.corner(40, clips: true)
        return vv
    }()
    
    lazy var tableViewHeaderImgBg: UIImageView = {
        return UIImageView(image: Assets().logo_0)
    }()
    lazy var tableViewHeaderImgLogo: UIImageView = {
        let v = UIImageView(image: Assets().logo_0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerLogoClick(_:)))
        v.cd.isUser(true).add(tap)
        return v
    }()
    
    
    var logoPKDrawing:Any?
    @objc func headerLogoClick(_ tap:Any) {
        if #available(iOS 13.0, *) {
            PencilDraw.show(tableViewHeaderImgLogo.image ?? Assets().logo_0, drawing: logoPKDrawing as? PKDrawing ?? PKDrawing()) { [weak self](draw, image) in
                self?.logoPKDrawing = draw
                self?.tableViewHeaderImgLogo.image = image
            }
        } else {
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cd.navigationBar(hidden: true)
        delegateData = VC_MineTableViewDelegateDataSource(vm)
        tableView.cd
            .dataSource(delegateData)
            .delegate(delegateData)
            .estimatedAll()
            //.content(inset: UIEdgeInsets(top: topBar._heightStatusBar, left: 0, bottom: 0, right: 0))
            /*.headerMJGifWithModel({ [weak self] in
                Time.after(3, {[weak self] in
                    self?.tableView.cd.endRefreshing()
                    self?.tableView.reloadData()
                })
            }, model: modelMj)
            .beginRefreshing()*/
            .table(headerView: tableViewHeader)
        topBar.delegate = self
        
        
        delegateData?.scrollViewDidScrollBlock = { [unowned self]scrollView in
            /*
            print("contentOffsetY-->", contentOffsetY)
            print("contentOffset.Y->", scrollView.contentOffset.y)
            
            guard scrollView.contentOffset.y > 0 else {
                return
            }
            guard contentOffsetY >= 0 else {
                return
            }
            if scrollView.contentOffset.y > contentOffsetY {
                //上
                velocityUp = true
                let offset = scrollView.contentOffset.y-contentOffsetY
                self.topBar.hidden(navigationBar: -offset)
            }else{
                //下
                velocityUp = false
                let offset = scrollView.contentOffset.y-contentOffsetY
                self.topBar.hidden(navigationBar: -(44-abs(offset)))
                
            }*/
            
            self.topBar.change(alpha: scrollView.contentOffset.y, maxOffset: self.tableViewHeaderHeight-self.topBar._heightTopBar) { [weak self](a) in
                let arr:[(UIColor,Float)] = [(Config.color.navigation0.cd_alpha(a),0),(Config.color.navigation1.cd_alpha(a),1)]
                self?.topBar.cd.gradient(layerAxial: arr,  updateIndex: 0)
            }
            
            do{ /// logo 缩小到标题栏
            
            }
            do{ /// 背景缩放
                guard scrollView.contentOffset.y <= self.tableViewHeaderHeight else {
                    return
                }
                let offset = scrollView.contentOffset.y
                self.tableViewHeaderImgBg.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(offset)
                }
                guard scrollView.contentOffset.y <= 0 else {
                    return
                }
                self.tableViewHeaderImgBg.snp.updateConstraints { (make) in
                    make.left.equalToSuperview().offset(offset)
                    make.right.equalToSuperview().offset(-offset)
                }
            }
        }
        
        
        //let vvc = TableViewController()
        //vvc.vm = VM_Mine()
        
        
        
        /*
        self.view.cd
            .append(UILabel.self, {
                $0.cd
                    .frame(x: 0, y: 300, w: 200, h: 200)
                    .background(UIColor.blue)
            })
            .add(
                UILabel().cd
                    .background(UIColor.red)
                    .frame(x: 10, y: 100, w: 100, h: 100)
                    .build)
         */
            
    }
    
    var ob:NSObjectProtocol?
    
}

extension VC_Mine: TopBarProtocol {
    func topBar(custom topBar: TopBar) {
        topBar.cd.background(UIColor.clear)
        topBar.bar_navigation.line.isHidden = true
        topBar._colorTitle = UIColor.white
        topBar._colorSubTitle = UIColor.white
        topBar._colorNormal = UIColor.white
        topBar._colorSelected = UIColor.white
        topBar._colorHighlighted = UIColor.white
        let arr:[(UIColor,Float)] = [(Config.color.navigation0.cd_alpha(0),0),(Config.color.navigation1.cd_alpha(0),1)]
        //topBar.bar_status.cd.gradient(layer: arr)
        //topBar.bar_navigation.cd.gradient(layer: arr)
        topBar.cd.gradient(layerAxial: arr)
        
        //topBar._heightCustomBar = 40
        //topBar.bar_custom.cd.background(UIColor.orange)
        
    }
    
    @objc func buttonClick(_ sender:UIButton) {
        print_cd("点击了")
    }
    
    
    func topBar(_ topBar: TopBar, updateItemStyleForItem item: TopNavigationBar.Item) -> [TopNavigationBarItem.Item.Style]? {
        switch item {
        case .leftItem1:
            let icon = IconFont.tsearch(22)
            return [.title([(txt: icon.text, font: icon.font, color: Config.color.hex("f"), state: .normal),
                            (txt: icon.text, font: icon.font, color: Config.color.hex("d"), state: .highlighted),
                            (txt: icon.text, font: icon.font, color: Config.color.hex("d"), state: .selected)])]
        case .rightItem1:
            let icon = IconFont.tshare(22)
            return [.title([(txt: icon.text, font: icon.font, color: Config.color.hex("f"), state: .normal),
                            (txt: icon.text, font: icon.font, color: Config.color.hex("d"), state: .highlighted),
                            (txt: icon.text, font: icon.font, color: Config.color.hex("d"), state: .selected)])]
        default:
            return nil
        }
    }
    
    func topBar(_ topBar:TopBar, didSelectAt item:TopNavigationBar.Item) {
        switch item {
        case .rightItem1:
            self.view.layoutIfNeeded()
        default:
            break
        }
        
        Net.config.log = true
        Net()
            .method(.get)
            .baseURL("http://apis.juhe.cn/qrcode/api")
            .parameters(
                ["key":"516c5015e25a46c7c5b6a027c9835b17",
                 "text":"https://github.com/liucaide/CaamDau",
                 "el": "h",
                 "logo": "https://static.pgyer.com/static-20200106/images/newHome/homepage_tracup_pic1.png",
                 "bgcolor": "f0f0f0",
                 "fgcolor": "333333",
                 "w": 500,
                 "m": 20,
                 "lw": 80,
                 "type": 2
            ])
            .success({ [weak self](res) in
                print_cd(res)
            })
            .failure({ (error) in
                print_cd(error)
            })
            .request()
        
        
        
    }
}

class VC_MineTableViewDelegateDataSource: TableViewDelegateDataSource {
    
    var scrollViewDidScrollBlock:((UIScrollView)->Void)?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollBlock?(scrollView)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
