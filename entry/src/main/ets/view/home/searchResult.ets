// searchResult.ets
import { GoodsItem } from '../../viewModel/goods/goods' // 调整为你实际的商品类型
import { goods } from '../../component/goods/goods' // 你的商品卡片组件
import { searchGoods } from '../../api/home'
import { CategoryL1 } from '../../viewModel/category/catalog'

@Entry
@Component
export struct SearchResult {
  @State keyword: string = ''
  @State goodsList: GoodsItem[] = []
  @State isLoading: boolean = true
  private router = this.getUIContext().getRouter()

  aboutToAppear(): void {
    const params = (this.router.getParams() as CategoryL1).keyword

    this.keyword = params || ''

    console.log('传入的key为:' + JSON.stringify(this.keyword))
    if (this.keyword) {
      this.fetchSearchResult()
    }
  }

  async fetchSearchResult(): Promise<void> {
    this.isLoading = true
    try {
      const res = await searchGoods(this.keyword)
      const allGoods = res.data.list
      this.goodsList = Array.isArray(allGoods) ? allGoods : []
      console.log(JSON.stringify(this.goodsList.length)+ '这是根据关键字'+this.keyword+'搜索到的商品列表'+ '是用searchGoods接口查询的res为:' +JSON.stringify(res))
    } catch (error) {
      console.error('搜索失败', error)
      this.goodsList = []
    } finally {
      this.isLoading = false
    }
  }

  build() {
    Column() {
      // 顶部标题栏（带返回）
      Row() {
        Column(){
          Row(){
            Image($r('app.media.right_arrow'))
              .width(18)
              .padding(2)
            Text(`返回`)
              .fontSize(14)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width(50)
          .onClick(() => this.router.back())
        }.justifyContent(FlexAlign.Start)
        Column(){
          Text(`搜索到的${this.keyword}结果: `)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
        }
        .padding({right:60})
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      }
      .height(60)
      .padding({top:30,left:10})
      .backgroundColor(Color.White)

      if (this.isLoading) {
        Text('加载中...').fontSize(16).padding(40)
      } else if (this.goodsList.length === 0) {
        Text('暂无相关商品')
          .fontSize(16)
          .fontColor(Color.Gray)
          .padding(60)
      } else {
        List({ space: 5 }) {
          ForEach(this.goodsList, (item: GoodsItem) => {
            ListItem() {
              goods({
                goodsImage: item.picUrl || '',
                goodTitle: item.name || '',
                goodsDesc: item.brief || '',
                goodsCurPrice: item.counterPrice || 0,
                goodsRealPrice: item.retailPrice || 0
              })
                .onClick(() => {
                  this.router.pushUrl({
                    url: `view/goods/GoodsDetailPage`,
                    params: { id: item.id }
                  })
                })
            }
          })
        }
        .padding({bottom:20,left:10,right:10})
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}