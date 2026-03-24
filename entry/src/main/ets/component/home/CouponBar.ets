import { Coupon } from '../../viewModel/home/IHomeData'
import { window } from '@kit.ArkUI'
import { getHomeData } from '../../api/home'
import { it } from '@ohos/hypium'
import { coupon } from '../common/coupon'

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
        coupon({
          discount:item.discount,
          desc:item.desc,
          tag:item.tag,
          name:item.name,
          days:item.days
        })
      })
    }.width('100%').padding({ left: 10, right: 10 })
  }
}