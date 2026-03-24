// BrandBar.ets
import { header } from '../common/header'
import { Brand } from '../../viewModel/home/IHomeData'
import { getHomeData } from '../../api/home'

@Component
export struct BrandBar {
  @State brand: Array<Brand> = []

  aboutToAppear(): void {
    this.loadBrandData()
  }

  private async loadBrandData() {
    try {
      const res = await getHomeData()
      this.brand = res.data?.brandList || []
    } catch (err) {
      console.error('加载品牌数据失败:', err)
    }
  }

  build() {
    Column() {
      // 头部标题
      header({
        head: '品牌商直供',
        moreHead: '更多品牌商'
      })

      // 品牌网格
      Grid() {
        ForEach(this.brand, (item: Brand) => {
          GridItem() {
            Column() { // 图片和文字间距
              Image(item.picUrl)
                .width(130)
                .height(80)
                .objectFit(ImageFit.Contain)
                .borderRadius(5)

              Text(item.name)
                .fontSize(13)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Medium)
                .maxLines(1)
            }
            .width('100%')
            .padding(5)
            .border({
              width: 1,
              color: Color.Gray,
              radius: 5
            })
            .backgroundColor(Color.White)
          }
        })
      }
      .columnsGap(2)
      .width('100%')
      .height(220) // 适当调小，避免过高
      .rowsTemplate('repeat(2, 1fr)')
      .columnsTemplate('repeat(2, 1fr)')
    }
    .width('100%')
    .padding(10)
  }
}