import { Coupon } from '../../viewModel/home/IHomeData'
import { window } from '@kit.ArkUI'
import { getHomeData } from '../../api/home'
import { it } from '@ohos/hypium'

@Component
export struct CouponBar {
  @State coupon: Array<Coupon> = []

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
      this.coupon = res.data.couponList
      console.log(JSON.stringify(this.coupon))
    } catch (err) {
      console.error(err)
    }
  }
  build() {
    Column({space:10}){
      Row(){
        Text('优惠券').fontSize(14).fontColor(Color.Black).textAlign(TextAlign.Start)
      }.width('100%').height(18)
      ForEach(this.coupon,(item:Coupon,index:number)=>{
        Row(){
          Column(){
            Row(){
              Text('$'+item.discount+'元').fontSize(16).fontColor(Color.Red).padding(5)
            }
            Row(){
              Text(item.desc+'-'+item.tag).fontSize(12).fontColor(Color.Gray).padding(5)
            }
          }.layoutWeight(2)
          Column(){
            Row(){
              Text(item.name).fontSize(14).fontColor(Color.Black).padding(5)
            }
            Row(){
              Text(item.days+'天').fontSize(10).fontColor(Color.Gray).padding(5)
            }
          }.layoutWeight(8)
        }.border({width:1,color:Color.Red})
        .height(80)
        .padding(5)
      })
    }.width('100%').backgroundColor('#ffe2e2de').padding({ left: 10, right: 10 })
  }
}