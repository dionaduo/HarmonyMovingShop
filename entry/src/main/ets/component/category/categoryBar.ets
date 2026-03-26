// categoryBar.ets
import { getCategory, getCurrentCategory } from "../../api/category/catalog"
import { ApiResponse } from "../../viewModel"
import { CategoryData, CurrentCategoryData, CategoryL1, CategoryL2, Category,
  PageList } from "../../viewModel/category/catalog"
import { lineGoods } from "../goods/lineGoods"

@Component
export struct categoryBar {
  @State categoryData: CategoryData = {} as CategoryData
  @State categoryMain: CategoryL1[] = [] // 所有一级分类（左侧 Tabs）
  @State currentSubCategories: CategoryL2[] = [] // 当前一级下的二级分类（右侧显示）
  @State selectedIndex: number = 0 // 当前选中的一级分类索引
  private tabsController: TabsController = new TabsController()
  private router = this.getUIContext().getRouter()

  async aboutToAppear(): Promise<void> {
    try {
      const resp: ApiResponse<CategoryData> = await getCategory()
      this.categoryData = resp.data || {} as CategoryData

      this.categoryMain = this.categoryData.categoryList || []
      console.log(`加载到 ${this.categoryMain.length} 个一级分类`)

      // 默认加载第一个一级分类的子分类
      if (this.categoryMain.length > 0) {
        await this.loadCurrentSubCategory(this.categoryMain[0].id)
      }
    } catch (e) {
      console.error("加载分类失败:", e)
    }
  }

  // 加载指定一级分类的子分类
  async loadCurrentSubCategory(id: number): Promise<void> {
    try {
      const resp: ApiResponse<CurrentCategoryData> = await getCurrentCategory(id)
      const data = resp.data || {} as CurrentCategoryData
      this.currentSubCategories = data.currentSubCategory || []
      console.log(`加载子分类 ${this.currentSubCategories.length} 个`)
    } catch (e) {
      console.error("加载子分类失败:", e)
    }
  }

  @Builder cate(it: CategoryL1,index:number){
    Column() {
      Text(it.name)
        .fontSize(16)
        .fontColor(this.selectedIndex === index ? '#ff228ce5' : Color.Black)
        .fontWeight(this.selectedIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .padding({
          top: 5,
          bottom: 5,
          left: 2,
          right: 5
        })
      if (this.selectedIndex === index){
        Divider().strokeWidth(2).width(12).color(Color.Red)
      }
    }.width(30).backgroundColor(this.selectedIndex === index ? '#ffeeeded' : Color.Transparent)
  }

  build() {
    Row() { // 左右布局：左侧 Tabs + 右侧内容
      // ==================== 左侧：一级分类（垂直 Tabs） ====================
      Tabs({
        barPosition: BarPosition.Start, // 左侧
        index: this.selectedIndex,
        controller: this.tabsController
      }) {
        ForEach(this.categoryMain, (item: CategoryL1, index: number) => {
          TabContent().tabBar(this.cate(item,index))
        })
      }
      .vertical(true)
      .barWidth(160) // 左侧栏宽度，可自行调整
      .barHeight("100%")
      .width(50)
      .onChange((index: number) => {
        this.selectedIndex = index
        if (this.categoryMain[index]) {
          this.loadCurrentSubCategory(this.categoryMain[index].id)
        }
      }).layoutWeight(15)


      // ==================== 右侧：二级分类列表 ====================
      Column({ space: 8 }) {
        if (this.currentSubCategories.length === 0) {
          Text("加载中...")
            .fontSize(16)
            .fontColor(Color.Gray)
            .padding(20)
        } else {
          Column({space:5}){
            ForEach(this.categoryMain,(item:CategoryL1,index:number)=>{
              if (this.selectedIndex===index) {
                Image(item.picUrl).width('100%').objectFit(ImageFit.Contain)
                Text(item.desc).fontSize(16).fontColor(Color.Black)
              }
            })
          }.width('100%')
          .padding({top:30})
          Scroll(){
            Grid() {
              ForEach(this.currentSubCategories, (sub: CategoryL2) => {
                GridItem() {
                  lineGoods({
                    picUrl: sub.picUrl,
                    name: sub.name
                  })
                }

                .backgroundColor(Color.White)
                .borderRadius(8)
                .onClick(() => {
                  console.log(`点击二级分类: ${sub.name} (id: ${sub.id})`)
                  this.router.pushUrl({
                    url: 'view/category/subCategory',
                    params: {
                      id: sub.id,
                      name: sub.name
                    } as CategoryL2
                  }).catch((e: string) => {
                    console.log('跳转失败:' + e)
                  })
                })
              })
            }
            .padding({ top: 30,bottom:30 })
            .rowsTemplate('repeat(5,1fr)')
            .columnsTemplate('repeat(3,1fr)')
            .rowsGap(2)
            .columnsGap(5)
          }.scrollable(ScrollDirection.Vertical)
        }
      }
      .padding(5)
      .layoutWeight(85)
    }
    .width("100%")
    .height("100%")
  }
}