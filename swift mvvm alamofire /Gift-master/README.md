###前言
#####本人上个月去上海出差回深圳有一段时间了，回来之后只看看到苹果新发布会ios10和新的编辑器Xcode8，以及对Swift语言很大的更新，很多论坛和开发者都很蛋碎，许多的项目都出现很多错误，特别是第三库和Xcode那些插件，这里本人也花了很多的时间对项目的维护和修改，这场的项目我用礼物说来加以修改和新的维护，首先我们看看新的编辑器和项目结构内容

![Snip20160920_2.png](http://upload-images.jianshu.io/upload_images/1754828-aa870b35784247ea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![Snip20160920_4.png](http://upload-images.jianshu.io/upload_images/1754828-0dc50acb068c5170.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 新的编辑器在xib和故事版有了一定的修改，让人更加的美观，还有一些新的东西也稍微修改了很多。

###项目介绍

#####新维护和修改的项目
*我们先看看看Swift3.0的特点和使用，就拿我修改后的礼物说的来说一说*

- 我们如何打开一个Swift2.0项目的时候就会发现弹出下图

![Snip20161009_4.png](http://upload-images.jianshu.io/upload_images/1754828-d581dc5936bdd4ef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 这是告诉我们如何以前的项目是否转化为了Swift3.0，根据提示的步骤就可以了，这里可以试一试效果。

- 打开`AppDelegate`这个类我们观察一下启动项设置一下那些，如图

![Snip20161009_5.png](http://upload-images.jianshu.io/upload_images/1754828-8066b30e369e0194.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 这里并没有用到网络的框架`Alamofire`，我没看到cocoapods安装的框架是

```
MJRefresh
SDWebImage
SnapKit
SVProgressHUD
```

- 有些是oc用到的第三方框架，就避免不了桥接文件了,不要忘记了Swift没有宏的定义，唯一办法就是新建一个Swift文件，这个文件目的就是写和oc一样的宏，`Common.swift`

```
import UIKit

/// 弹出登录视图
let Notif_Login = "Notif_Login"
/// 搜索标签按钮
let Notif_BtnAction_SearchTag = "Notif_BtnAction_SearchTag"

/// 全局背景
let Color_GlobalBackground = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
let Color_GlobalLine = UIColor(red: 237.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
let Color_NavBackground = UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0)

let ScreenWidth = UIScreen.mainScreen().bounds.width
let ScreenHeight = UIScreen.mainScreen().bounds.height

```

![演示.gif](http://upload-images.jianshu.io/upload_images/1754828-3de4f19c40679870.gif?imageMogr2/auto-orient/strip)

###首页

- 还是以前的的老样子,在`UITabBarController`控制器分别设置四大控制器，我们一个一个讲解一下UI

```
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController()
        // Do any additional setup after loading the view.
    }

    private func addChildViewController(){
        addChildViewController(HomeViewController(), title: "礼物说", imageName: "tabbar_home")
        addChildViewController(HotViewController(), title: "热门", imageName: "tabbar_gift")
        addChildViewController(ClassifyViewController(), title: "分类", imageName: "tabbar_category")
        addChildViewController(MeViewController(), title: "我", imageName: "tabbar_me")
    }
    
    private func addChildViewController(controller: UIViewController, title: String, imageName: String) {
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        controller.tabBarItem.title = title
        
        let nav = NavigationController()
        nav.addChildViewController(controller)
        addChildViewController(nav)
    }

```

- `HomeViewController`基于`BaseViewController`，在基类中统一下页面的页面，和导航栏

![首页.png](http://upload-images.jianshu.io/upload_images/1754828-9d8ea0a46c910524.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 首页几个页面是分别拆开写的，我这里很乱，仔细来说一说怎么拼接这些自定义的控件

```
    // MARK: - 视图
    private func setupUI() {
        view.backgroundColor = Color_GlobalBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(gifTarget: self, action: #selector(HomeViewController.gifBtnAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(searchTarget: self, action: #selector(HomeViewController.searchBtnAction))
        navigationItem.titleView = titleImageView
        view.addSubview(scrollView)
        view.addSubview(popoverCategoryView)
        
        for i in 0..<categoryTitles.count {
            let categoryVC = i == 0 ? ChoiceStrategyViewController() : CommonStrategyViewController()
            addChildViewController(categoryVC)
            scrollView.addSubview(categoryVC.view)
            cacheCategoryViews.append(categoryVC.view)
        }
    }
    

```

```
    private func setupUIFrame() {
        popoverCategoryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44.0)
        scrollView.frame = CGRect(x: 0, y: CGRectGetMaxY(popoverCategoryView.frame), width: view.bounds.width, height: view.bounds.height - popoverCategoryView.bounds.height - 44.0)
        for i in 0..<cacheCategoryViews.count {
            let view = cacheCategoryViews[i]
            view.frame = CGRect(x: scrollView.bounds.width * CGFloat(i), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        }
        scrollView.contentSize = CGSizeMake(CGFloat(cacheCategoryViews.count) * scrollView.bounds.width, 0)
    }

```

```
// MARK: - 代理
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width;
        popoverCategoryView.scrollCategoryBtnByIndex(NSInteger(index))
    }
}

extension HomeViewController: PopoverCategoryViewDelegate {
    
    func selectedCategoryEndWithIndex(index: NSInteger) {
        scrollView.setContentOffset(CGPointMake(CGFloat(index) * scrollView.bounds.width, 0), animated: true)
    }

```

- 首页内容只写了这么点，但是内容涉及的很广泛，看是简单明了，其实内容暗藏玄机，用数组的方式加载`categoryTitles`，所有的重点内容都在最后的`PopoverCategoryViewDelegate`代理方法，这是难点，所有的东西都集中在于代理方法。这就是MVVM的模式，会看到控制器中很干净，把方法都集中在其他的View，在View中写代理方法，针对这种方法，大大减少了控制器的负担，从而较少了对内存的消耗，比MVC模式的更加一筹

![Snip20161009_10.png](http://upload-images.jianshu.io/upload_images/1754828-509e7e4af0bd5550.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 首页的数据都是死的，都是自定义cell加载出来的

```
private let cellReuseIdentifier = "BaseStrategyCell"
class BaseStrategyFeedController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    private func setupUI() {
        view.addSubview(tableView)
    }
    
    private func setupUIFrame() {
        tableView.frame = view.bounds
    }
    
    // MARK: - 懒加载
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color_GlobalBackground
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.sectionFooterHeight = 0.0001
        tableView.sectionHeaderHeight = 0.0001
        tableView.registerNib(UINib(nibName: "BaseStrategyCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
}

// MARK: - 代理
extension BaseStrategyFeedController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tabBarViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! TabbarController
        let navigationController = tabBarViewController.viewControllers![tabBarViewController.selectedIndex] as! NavigationController
        navigationController.pushViewController(CommonStrategyViewController(), animated: true)
    }
    
}

```

![Snip20161009_11.png](http://upload-images.jianshu.io/upload_images/1754828-6078f712b45a577b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###热门

- `HotViewController` 

```
import UIKit
import MJRefresh
class HotViewController: BaseGoodsFeedViewController {
    
    private var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
    }
    
    private func setupUI() {
        title = "热门"
        view.backgroundColor = Color_GlobalBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(searchTarget: self, action: #selector(HotViewController.searchBtnAction))
    }
    
    private func setupRefresh() {
        let header = Refresh(refreshingTarget: self, refreshingAction: #selector(HotViewController.pullDownLoadData))
        collectionView.mj_header = header
    }
    
    @objc private func pullDownLoadData() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.collectionView.mj_header.endRefreshing()
        }
    }
    
    @objc private func searchBtnAction() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

```

- 对代码就是这点，但是怎么没有看到UI控件呢？注意看`collectionView`这个视图以及`
class BaseGoodsFeedViewController: BaseViewController`这个继承的类

```
import UIKit
private let cellReuseIdentifier = "BaseGoodsCell"
/// 列数
private let collectionViewRow = 2
/// cell间距
private let cellMargin:CGFloat = 10.0
/// cell里除图片外的固定高度(适配了所有机型在展示的商品图片都为正方形)
private let fixedHeight:CGFloat = 78

class BaseGoodsFeedViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    private func setupUI() {
        view.addSubview(collectionView)
    }
    
    private func setupUIFrame() {
        collectionView.frame = view.bounds
    }
    
    // MARK: - 懒加载
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: BaseGoodsFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Color_GlobalBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerNib(UINib(nibName: "BaseGoodsCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        return collectionView
    }()
}

// MARK: - 代理
extension BaseGoodsFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! BaseGoodsCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let webViewVC = WebViewController()
        webViewVC.url = "http://s.click.taobao.com/t?e=m%3D2%26s%3D2ZgcWh6O%2BaEcQipKwQzePOeEDrYVVa64XoO8tOebS%2BdRAdhuF14FMa6oLp3eumO7J1gyddu7kN%2BtgmtnxDX9deVMA5qBABUs5mPg1WiM1P5OS0OzHKBZzQIomwaXGXUs78FqzS29vh5nPjZ5WWqolN%2FWWjML5JdM90WyHry0om01pr82yACYuF5aLkF0b2B%2B6zE1jcKGHQ%2BMosMYYBet5g%3D%3D"
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (cellMargin * CGFloat(collectionViewRow + 1))) / CGFloat(collectionViewRow)
        let height = width + fixedHeight
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin);
    }
}

// MARK: - 其他类
class BaseGoodsFlowLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        minimumInteritemSpacing = cellMargin * 0.5
        minimumLineSpacing = cellMargin
        scrollDirection = UICollectionViewScrollDirection.Vertical
    }


}

```
- 会发现还是和首页一样，把代理方法写在基础于`BaseViewController`,然后写代理方法


##分类
`ClassifyViewController`


![分类.png](http://upload-images.jianshu.io/upload_images/1754828-9b58d9c58078947f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 看到这么复杂的页面，不会又是MVVM吧。是的，所有项目都是按照这种风格来设计的，

```
import UIKit

class ClassifyViewController: BaseViewController {

    struct Static {
        static var dispatchOnceToken: dispatch_once_t = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    private func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = Color_GlobalBackground
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(chooseGifTarget: self, action: #selector(ClassifyViewController.SearchGifBtnAction))
        navigationItem.rightBarButtonItem?.customView?.alpha = 0
        view.addSubview(searchBar)
        view.addSubview(scrollView)
        scrollView.addSubview(strategyVC.view)
        scrollView.addSubview(singleGifVC.view)
        addChildViewController(strategyVC)
        addChildViewController(singleGifVC)
    }
    
    private func setupUIFrame() {
        dispatch_once(&Static.dispatchOnceToken) {
            self.titleView.frame = CGRectMake(0, 0, 120.0, 44.0)
            self.searchBar.frame = CGRectMake(0, 0, self.view.bounds.width, 44.0)
            self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), self.view.bounds.width, self.view.bounds.height - self.searchBar.bounds.height - 44.0)
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.width * 2.0, self.scrollView.bounds.height)
            self.strategyVC.view.frame = self.scrollView.bounds
            self.singleGifVC.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.frame), 0, self.scrollView.bounds.width, self.scrollView.bounds.height)
        }
    }
    
    // MARK: - 事件
    @objc private func SearchGifBtnAction() {
        navigationController?.pushViewController(SearchGifViewController(), animated: true)
    }
    
    // MARK: - 懒加载
    private lazy var titleView: ClassifyTitleView = {
        let view = ClassifyTitleView()
        view.delegate = self
        return view
    }()
    
    private lazy var searchBar: UISearchBar =  UISearchBar(searchGifdelegate: self, backgroundColor:UIColor(white: 0, alpha: 0.05), backgroundImage:UIImage.imageWithColor(UIColor.whiteColor(), size: CGSizeZero))
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.pagingEnabled = true
        return view
    }()
    
    private lazy var strategyVC: StrategyViewController = StrategyViewController()
    private lazy var singleGifVC: SingleGifViewController = SingleGifViewController()
}

// MARK: - 代理
extension ClassifyViewController: ClassifyTitleViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    // MARK: - ClassifyTitleViewDelegate
    func selectedOptionAtIndex(index: NSInteger) {
        scrollView.setContentOffset(CGPointMake(CGFloat(index) * scrollView.bounds.width, 0), animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// 更改选礼神器按钮alpha
        navigationItem.rightBarButtonItem?.customView?.alpha = scrollView.contentOffset.x / scrollView.bounds.width
        /// 更改titleView底部线条x
        titleView.scrollLine(scrollView.bounds.width, offsetX: scrollView.contentOffset.x)
    }



}
```

- 比起原来的项目我们的控制器非常的干净，也非常的简洁。要做的就是加载加载UI和实现代理方法，但是不是写在控制器类，而是拆开来写，最后一起放在控制器里面，说明一下`StrategyViewController`和`SingleGifViewController`

```
private let cellColumns = 2
private let cellMargin:CGFloat = 10.0
private let columnCellHeight:CGFloat = 250.0
private let cellScale:CGFloat = 200.0 / 100.0 /// cellxib宽高比例

private let categoryCellID = "StrategyCategoryCell"
private let columnCellID =  "StrategyColumnCell"
private let sectionID = "StrategySectionView"
class StrategyViewController: BaseViewController {
    
    private var headerReferenceSize:CGSize?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    private func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView)
    }
    
    private func setupUIFrame() {
        collectionView.frame = view.bounds
    }
    
    // MARK: - 事件
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: StrategyCollectionFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerNib(UINib(nibName: "StrategyColumnCell", bundle: nil), forCellWithReuseIdentifier: columnCellID)
        collectionView.registerNib(UINib(nibName: "StrategyCategoryCell", bundle: nil), forCellWithReuseIdentifier: categoryCellID)
        collectionView.registerNib(UINib(nibName: "StrategySectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionID)
        let section = NSBundle.mainBundle().loadNibNamed("StrategySectionView", owner: self, options: nil)!.last!
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.headerReferenceSize = CGSize(width: ScreenWidth, height: section.size.height)
        self.headerReferenceSize = collectionViewLayout.headerReferenceSize
        return collectionView
    }()
}

// MARK: - 代理
extension StrategyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        /// 栏目
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(columnCellID, forIndexPath: indexPath) as! StrategyColumnCell
            return cell
        }
        /// 分类
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(categoryCellID, forIndexPath: indexPath) as! StrategyCategoryCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let sectionView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: sectionID, forIndexPath: indexPath) as! StrategySectionView
        sectionView.hideMarginTopView(indexPath.section == 0 ? true : false)
        sectionView.viewAllBtn.tag = indexPath.section
        return sectionView
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(CommonStrategyViewController(), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height: columnCellHeight)
        }
        let width = (collectionView.bounds.width - (cellMargin * CGFloat(cellColumns + 1))) / CGFloat(cellColumns)
        let height = width / cellScale
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(0, cellMargin, 0, cellMargin);
        }
        return UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(headerReferenceSize!.width, headerReferenceSize!.height - 12)
        }
        return headerReferenceSize!
    }
}

// MARK: - 其他类
class StrategyCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        minimumInteritemSpacing = cellMargin * 0.5
        minimumLineSpacing = cellMargin
        scrollDirection = UICollectionViewScrollDirection.Vertical
    }
}

/// 分组头部
class StrategySectionView: UICollectionReusableView {
    
    @IBOutlet weak var marginTopView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    
    func hideMarginTopView(hide: Bool) {
        marginTopView.hidden = hide
    }
    
    @IBAction func viewAllBtnAction(sender: AnyObject) {
        let tabBarViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! TabbarController
        let navigationController = tabBarViewController.viewControllers![tabBarViewController.selectedIndex] as! NavigationController
        navigationController.pushViewController(sender.tag == 0 ? AllColumnViewController() : AllClassifyViewController(), animated: true)
    }
}
```

```
private let cellColumns = 3
private let cellMargin:CGFloat = 10.0
private let cellScale:CGFloat = 100.0 / 140.0 /// cellxib宽高比例
private let cellID = "SingleGifCell"
private let sectionID = "SingleGifSectionView"
private let columnCellID = "columnCell"
class SingleGifViewController: BaseViewController {
    
    private var headerReferenceSize:CGSize?
    private var selectedColumnRow = 0
    /// ture: 点击栏目 false: 滚动collectionView
    private var isSelectedColumn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    private func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
        view.addSubview(collectionView)
    }
    
    private func setupUIFrame() {
        let scale:CGFloat = 0.25
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * scale, height: view.bounds.height)
        collectionView.frame = CGRect(x: CGRectGetMaxX(tableView.frame), y: 0, width: view.bounds.width * (1 - scale) , height: view.bounds.height)
        
    }
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: StrategyCollectionFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerNib(UINib(nibName: "SingleGifCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.registerNib(UINib(nibName: "SingleGifSectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionID)
        let section = NSBundle.mainBundle().loadNibNamed("SingleGifSectionView", owner: self, options: nil)!.last!
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.headerReferenceSize = CGSize(width: ScreenWidth, height: section.size.height)
        self.headerReferenceSize = collectionViewLayout.headerReferenceSize
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color_GlobalBackground
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionFooterHeight = 0.0001
        tableView.sectionHeaderHeight = 0.0001
        tableView.registerNib(UINib(nibName: "SingleGifColumnCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: columnCellID)
        return tableView
    }()
}

// MARK: - 代理
extension SingleGifViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 18
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! SingleGifCell
        /// 滚动栏目列表
        if !isSelectedColumn && selectedColumnRow != indexPath.section {
            selectedColumnRow = indexPath.section
            tableView.reloadData()
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: indexPath.section, inSection: 0), atScrollPosition: .Top, animated: true)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let sectionView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: sectionID, forIndexPath: indexPath) as! SingleGifSectionView
        return sectionView
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(CommonGoodsFeedViewController(), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (cellMargin * CGFloat(cellColumns + 1))) / CGFloat(cellColumns)
        let height = width / cellScale
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(0, cellMargin, 0, cellMargin);
        }
        return UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeZero
        }
        return headerReferenceSize!
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isSelectedColumn = !scrollView.isKindOfClass(UICollectionView)
    }
}

extension SingleGifViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(columnCellID) as! SingleGifColumnCell
        cell.changeStatus(indexPath.row == selectedColumnRow ? true : false)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        isSelectedColumn = true
        selectedColumnRow = indexPath.row
        tableView.reloadData()
        /// 滚动商品列表
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: indexPath.row), atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
    }
    
}

// MARK: - 其他类
class SingleGifCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        minimumInteritemSpacing = cellMargin * 0.5
        minimumLineSpacing = cellMargin
        scrollDirection = UICollectionViewScrollDirection.Vertical
    }
}

/// 分组头部
class SingleGifSectionView: UICollectionReusableView {
    
}

```

- 他们的方法和思路都是一样的，可以说相同。

##个人中心

```
import UIKit
import SnapKit

private let cellReuseIdentifier = "Cell"
class MeViewController: BaseViewController{
    
    var tableview : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - 视图
    private func setupUI(){
        hideNavigationBar(false)
        setupBarView()
        setupTableView()
    }
    
    /**
     隐藏导航条
     
     - parameter showBgImage: 是否显示导航条背景
     */
    private func hideNavigationBar(showBgImage: Bool){
        automaticallyAdjustsScrollViewInsets = false;
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.setBackgroundImage(showBgImage ? UIImage(named: "me_profilebackground") : UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    /**
     布局导航栏按钮
     */
    private func setupBarView(){
        
        let mailButton = UIButton(x: 0, iconName: "me_message", target:self, action:#selector(MeViewController.mailBtnAction), imageEdgeInsets: UIEdgeInsetsMake(0, -20, 0, 0))
        let alarmclockButton = UIButton(x: 44, iconName: "me_giftremind", target:self, action: #selector(MeViewController.alarmclockBtnAction), imageEdgeInsets: UIEdgeInsetsMake(0, -20, 0, 0))
        leftBarView .addSubview(mailButton)
        leftBarView.addSubview(alarmclockButton)
        
        let qrcodeButton = UIButton(x: 0, iconName: "me_scan", target:self, action:#selector(MeViewController.qrcodeBtnAction), imageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, -20))
        let settingButton = UIButton(x: 44, iconName: "iconSettings", target:self, action: #selector(MeViewController.settingBtnAction), imageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, -20))
        rightBarView .addSubview(qrcodeButton)
        rightBarView.addSubview(settingButton)
        
        let leftBarItem = UIBarButtonItem()
        let rightBarItem = UIBarButtonItem()
        leftBarItem.customView = leftBarView
        rightBarItem.customView = rightBarView
        
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    /**
     布局tableview
     */
    private func setupTableView(){
        
        /// 初始化tableview
        tableview = UITableView(frame: view.bounds, style: UITableViewStyle.Grouped)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableview?.backgroundColor = Color_GlobalBackground
        tableview?.sectionHeaderHeight = 0
        tableview?.sectionFooterHeight = 0
        view.addSubview(tableview!)
        /// tableview头部
        tableview?.tableHeaderView = headerView
        /// tableview底部
        tableview?.tableFooterView = footerView
    }
    
    // MARK: - 懒加载
    private lazy var leftBarView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 88, height: 44))
    }()
    
    private lazy var rightBarView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 88, height: 44))
    }()
    
    private lazy var headerView: MeHeaderView = {
        return MeHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 214 + 70))
    }()
    
    private lazy var footerView: MeFooterView = {
        return MeFooterView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 300))
    }()
    
    private lazy var sectionView: UIView = {
        let nibs: NSArray = NSBundle.mainBundle().loadNibNamed("MeSectionView", owner: nil, options: nil)!
        let view = nibs.lastObject as! UIView
        view.frame = CGRect(x: 0, y: 0, width: self.tableview!.bounds.width, height: 60)
        return view
    }()
    
    // MARK: - 事件
    @objc private func mailBtnAction(){
        NSNotificationCenter.defaultCenter().postNotificationName(Notif_Login, object: nil)
    }
    
    @objc private func alarmclockBtnAction(){
        NSNotificationCenter.defaultCenter().postNotificationName(Notif_Login, object: nil)
    }
    
    @objc private func qrcodeBtnAction(){
        NSNotificationCenter.defaultCenter().postNotificationName(Notif_Login, object: nil)
    }
    
    @objc private func settingBtnAction(){
        NSNotificationCenter.defaultCenter().postNotificationName(Notif_Login, object: nil)
    }
}

// MARK: - 代理
extension MeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// 处理背景图片拉伸效果
        let offsetY = scrollView.contentOffset.y;
        if offsetY > 0 {
            return
        }
        let upFactor: CGFloat = 0.6;
        if offsetY >= 0.0 {
            headerView.bgimageView.transform = CGAffineTransformMakeTranslation(0, offsetY * upFactor)
        } else {
            let transform = CGAffineTransformMakeTranslation(0, offsetY)
            let s = 1 + -offsetY * 0.01
            headerView.bgimageView.transform = CGAffineTransformScale(transform, 1, s)
        }
        
    }
    
}

```

- 首页就没有用MVVM模式了，是传统的MVC模式，这里看到控制器的代码比较乱了，没有之前的简洁，个人中心的内容也没有写，都是写的。我这里就省略了不多解释了

代码下载地址

https://github.com/qijinliang/Gift

##总结

- 这次Xcode8.0和Swift3.0大升级给了很多开发者一些头痛的问题，以及一些新的知识挑战，我这个项目只是拿来讲解和稍微修改了一下，更多的还得不断的挑战和探索。