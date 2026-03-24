import { header } from '../common/header'
import { window } from '@kit.ArkUI'
import { Brand } from '../../viewModel/home/IHomeData'
import { getHomeData } from '../../api/home'

@Component
export struct BrandBar {
  @State brand: Array<Brand> = []

  aboutToAppear(): void {
    this.getCoupon()
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }

  private async getCoupon() {
    try {
      const res = await getHomeData()
      this.brand = res.data.brandList
      console.log(JSON.stringify(this.brand))
    } catch (err) {
      console.error(err)
    }
  }

  build() {
    Column(){
      header({
        head: '品牌商直供',
        moreHead:'更多品牌商'
      })
      Grid(){
        ForEach(this.brand,(item:Brand,index:number)=>{
          GridItem(){
            Column(){
              Image(item.picUrl)
              .objectFit(ImageFit.Contain)
              .borderRadius(10)
              Text(item.name)
              .fontSize(12)
              .fontColor(Color.Black)
              .fontWeight('bold')
            }
          }
        })
      }
      .columnsGap(3)
      .rowsGap(3)
      .width('100%')
      .height(300)
      .rowsTemplate('repeat(2, 1fr)')
      .columnsTemplate('repeat(2, 1fr)')
    }.width('100%')
    .padding(10)
  }
}