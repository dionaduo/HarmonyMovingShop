// subCategory.ets
import { getSubCategoryGoods, getSubCategoryDetail, subCategoryInterface } from "../../api/category/catalog"
import { ApiResponse } from "../../viewModel"
import { CategoryL2, SubCategoryGoodsList, SubCategoryDetail } from "../../viewModel/category/catalog"
import { GoodsItem } from "../../viewModel/goods/goods"
import { goods } from "../../component/goods/goods"

@Entry
@Component
export struct subCategory {
  // ==================== 接收参数（从 categoryBar 传入的当前子分类） ====================
  @State currentCategoryId: number = 0
  @State currentCategoryName: string = ""
  // ==================== Tabs 数据 ====================
  @State subCategories: CategoryL2[] = []
  @State selectedTabIndex: number = 0
  // ==================== 商品数据 ====================
  @State goodsList: GoodsItem[] = []
  @State isLoading: boolean = true
  @State hasMore: boolean = true
  @State page: number = 1
  @State limit: number = 20
  private tabsController: TabsController = new TabsController()
  private router = this.getUIContext().getRouter()

  aboutToAppear(): void {
    const params = this.router.getParams() as CategoryL2
    this.currentCategoryId = params.id || 0
    this.currentCategoryName = params.name || ""

    console.log('传入的子分类id: ' + JSON.stringify(this.currentCategoryId))
    console.log('传入的子分类名称: ' + JSON.stringify(this.currentCategoryName))

    if (this.currentCategoryId > 0) {
      this.loadSubCategoryDetail()
    }
  }

  async loadSubCategoryDetail(): Promise<void> {
    try {
      const resp: ApiResponse<SubCategoryDetail> = await getSubCategoryDetail(this.currentCategoryId)
      const data = resp.data || {} as SubCategoryDetail

      this.subCategories = data.brotherCategory || []

      const currentExists = this.subCategories.some(item => item.id === data.currentCategory.id)
      if (!currentExists && data.currentCategory) {
        this.subCategories.unshift(data.currentCategory)
      }

      const defaultIndex = this.subCategories.findIndex(item => item.id === this.currentCategoryId)
      this.selectedTabIndex = defaultIndex >= 0 ? defaultIndex : 0

      this.loadGoods(true)
    } catch (e) {
      console.error("加载子分类详情失败:", e)
    }
  }

  async loadGoods(isRefresh: boolean = false): Promise<void> {
    if (this.subCategories.length === 0) return

    const currentSub = this.subCategories[this.selectedTabIndex]
    if (!currentSub) return

    if (isRefresh) {
      this.page = 1
      this.goodsList = []
      this.isLoading = true
    }

    try {
      const params: subCategoryInterface = {
        categoryId: currentSub.id,
        page: this.page,
        limit: this.limit
      }

      const resp: ApiResponse<SubCategoryGoodsList> = await getSubCategoryGoods(params)
      const data = resp.data || {} as SubCategoryGoodsList

      if (isRefresh) {
        this.goodsList = data.list || []
      } else {
        this.goodsList = [...this.goodsList, ...(data.list || [])]
      }

      this.hasMore = (data.list && data.list.length === this.limit)

    } catch (e) {
      console.error("加载商品列表失败:", e)
    } finally {
      this.isLoading = false
    }
  }

  onTabChange(index: number): void {
    this.selectedTabIndex = index
    this.loadGoods(true)
  }

  onReachBottom(): void {
    if (!this.isLoading && this.hasMore) {
      this.page++
      this.loadGoods(false)
    }
  }

  build() {
    Column() {
      Blank().height(30)
      Row() {
        Row() {
          Image($r('app.media.right_arrow'))
            .width(20)
            .padding({ left: 5, bottom: 2 })
          Text('返回')
            .textAlign(TextAlign.End)
            .height(30)
            .padding(5)
            .onClick(() => {
              this.router.back()
            })
        }.width('20%').backgroundColor('#ffe9e9e9')
        Blank()
      }.width('100%').justifyContent(FlexAlign.Start)

      // ==================== Tabs（支持横向滚动） ====================
      Tabs({
        barPosition: BarPosition.Start,
        index: this.selectedTabIndex,
        controller: this.tabsController
      }) {
        ForEach(this.subCategories, (sub: CategoryL2, index: number) => {
          TabContent() {
            // 商品列表区域（你的原逻辑，完全未改动）
            if (this.isLoading && this.goodsList.length === 0) {
              Column({ space: 12 }) {
                Text("正在加载商品...")
                  .fontSize(16)
                  .fontColor(Color.Gray)
                  .padding(40)
              }
              .layoutWeight(1)
              .justifyContent(FlexAlign.Center)
            } else if (this.goodsList.length === 0) {
              Column({ space: 12 }) {
                Text("😶").fontSize(60)
                Text("暂无商品").fontSize(16).fontColor(Color.Gray)
                Text("该分类下暂时没有商品哦~").fontSize(14).fontColor(Color.Gray)
              }
              .layoutWeight(1)
              .justifyContent(FlexAlign.Center)
            } else {
              List({ space: 5 }) {
                ForEach(this.goodsList, (item: GoodsItem) => {
                  ListItem() {
                    goods({
                      goodsImage: item.picUrl || "",
                      goodTitle: item.name || "未知商品",
                      goodsDesc: item.brief || "",
                      goodsRealPrice: item.retailPrice || 0,
                      goodsCurPrice: item.counterPrice || 0
                    })
                      .onClick(() => {
                        console.log(`点击商品: ${item.name} (id: ${item.id})`)
                        this.router.pushUrl({
                          url: "view/goods/GoodsDetailPage",
                          params: { id: item.id } as GoodsItem
                        }).catch((e: string) => {
                          console.log('跳转失败:' + e)
                        })
                      })
                  }
                })
              }
              .height('100%')
              .layoutWeight(1)
              .padding({ left: 5, right:5 })
              .onReachEnd(() => this.onReachBottom())
            }
          }
          .padding(0)
          .tabBar(this.subTitleBuilder(sub, index))
        })
      }
      .layoutWeight(1)
      .onChange((index: number) => {
        this.onTabChange(index)
      })
      .barMode(BarMode.Scrollable)


    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f5f5f5")
  }

  // ==================== 修改后的 Builder：支持横向滚动的 Tab 标题 ====================
  @Builder
  subTitleBuilder(sub: CategoryL2, index: number) {

    Scroll() {
      Column(){
        Text(sub.name)
          .fontSize(16)
          .fontColor(this.selectedTabIndex === index ? '#ff228ce5' : Color.Black)
          .fontWeight(this.selectedTabIndex === index ? FontWeight.Bold : FontWeight.Normal)
          .padding({
            top: 2,
            bottom: 2,
            left: 5,
            right: 5
          })
        if (this.selectedTabIndex === index) {
          Divider().strokeWidth(2).width(20).color(Color.Red)
        }
      }
    }
    .height(40)
    .scrollBar(BarState.Off)
    .constraintSize({ minWidth: 30 ,minHeight:30}) // 防止单个Tab过窄
  }
}