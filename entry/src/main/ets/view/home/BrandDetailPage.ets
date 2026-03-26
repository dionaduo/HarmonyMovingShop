// BrandDetailPage.ets
import { getBrandById, getBrandGoodsById } from '../../api/home'
import { goods } from '../../component/goods/goods'
import { GoodsItem } from '../../viewModel/goods/goods'
import { Brand } from '../../viewModel/goods/goodsDetail'

@Entry
@Component
struct BrandDetailPage {
  @State brandId: number = 0
  @State brandGoodsList: GoodsItem[] = []
  @State brandDetail: Brand = {} as Brand
  @State isLoading: boolean = true
  private router = this.getUIContext().getRouter()

  aboutToAppear(): void {
    const params = this.router.getParams() as GoodsItem
    this.brandId = params?.id || (this.router.getParams() as Brand).id

    if (this.brandId > 0) {
      this.loadBrandData()
    }
  }

  private async loadBrandData() {
    this.isLoading = true
    this.brandGoodsList = [] // 清空旧数据
    try {
      const goodsResponse = await getBrandGoodsById(this.brandId)
      // 强制类型转换 + 安全取值（解决类型检查报错）
      const listData = goodsResponse?.data?.list
      this.brandGoodsList = Array.isArray(listData) ? listData : []

      // 获取品牌详情
      const brandResponse = await getBrandById(this.brandId)
      this.brandDetail = brandResponse?.data || {} as Brand

    } catch (e) {
      console.error('加载品牌数据失败:', e)
      this.brandGoodsList = []
    } finally {
      this.isLoading = false
    }
  }

  build() {
    Column() {
      // 顶部返回栏
      Row() {
        Row({ space: 8 }) {
          Image($r('app.media.right_arrow'))
            .width(18)
            .fillColor(Color.Black)
          Text('返回')
            .fontSize(16)
        }
        .padding(10) .onClick(() => this.router.back())
      }
      .padding({top :30})
      .width('100%')
      .backgroundColor(Color.White)

      if (this.isLoading) {
        Column() {
          Text('加载中...').fontSize(18).fontColor(Color.Gray)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            // 品牌信息
            if (this.brandDetail?.id) {
              Row(){
                Column() {
                  Image(this.brandDetail.picUrl || '')
                    .width('100%')
                    .height(200)
                    .objectFit(ImageFit.Contain)

                  Text(this.brandDetail.name || '')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Start)
                    .width('100%')

                  Text(this.brandDetail.desc || '')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                    .textAlign(TextAlign.Start)
                    .width('100%')
                }
                .padding(10)
                .backgroundColor(Color.White)
                .borderRadius(10)
              }.alignItems(VerticalAlign.Top)
            }

            // 商品列表
            if (this.brandGoodsList.length === 0) {
              Text('该品牌暂无商品')
                .fontSize(16)
                .fontColor(Color.Gray)
                .padding(60)
            } else {
              Grid() {
                ForEach(this.brandGoodsList, (item: GoodsItem, index: number) => {
                  GridItem() {
                    goods({
                      goodsImage: item.picUrl || '',
                      goodTitle: item.name || '',
                      goodsDesc: item.brief || '',
                      goodsCurPrice: item.counterPrice || 0,
                      goodsRealPrice: item.retailPrice || 0
                    })
                  }.onClick(()=>{
                    this.router.pushUrl({
                      url:'view/goods/GoodsDetailPage',
                      params:{
                        id: item.id
                      }as GoodsItem
                    })
                  })
                })
              }
              .scrollBar(BarState.Off)
              .columnsTemplate('repeat(auto-fill, minmax(165px, 1fr))')
              .columnsGap(5)
              .rowsGap(5)
              .padding({ left:10,right:10,bottom:20 })
            }
          }
          .height('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}