import { Groupon } from '../../viewModel/home/IHomeData'
import { window } from '@kit.ArkUI'
import { getHomeData } from '../../api/home'
import { header } from '../common/header'

@Component
export struct GrouponBar {
  @State groupon: Array<Groupon> = []

  aboutToAppear(): void {
    this.getGroupon()
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }

  private async getGroupon() {
    try {
      const res = await getHomeData()
      this.groupon = res.data.grouponList
      console.log(JSON.stringify(this.groupon))
    } catch (err) {
      console.error(err)
    }
  }
  build() {
    Column(){
      header({
        head:'团购专区',
        moreHead:'更多团购商品'
      })

      ForEach(this.groupon,(item:Groupon,index:number)=>{
        Row(){
          Column(){
            Image(item.picUrl).objectFit(ImageFit.Contain)
          }.layoutWeight(3)
          Column({space:4}){
            Row(){
              Text(item.name).fontSize(13)
            }
            Row(){
              Text(item.brief).fontSize(10).fontColor(Color.Gray)
            }
            Row({space:2}){
              Text(item.grouponDiscount+'人成团')
                .fontSize(12)
                .fontColor(Color.Blue)
                .border({width: 1, style: BorderStyle.Solid, color: Color.Blue})
              Text(item.grouponMember+'元立减')
                .fontSize(12)
                .fontColor(Color.Red)
                .border({width: 1, style: BorderStyle.Solid, color: Color.Red})
            }
            Row({space:5}){
              Text('$'+item.grouponPrice).fontSize(12)
              Text('$'+item.retailPrice).fontSize(10).fontColor(Color.Gray)
            }
          }.layoutWeight(7).padding(5)
          .justifyContent(FlexAlign.Start)
        }
        .border({width:1, style: BorderStyle.Solid, color: Color.Gray})
      })
    }.width('100%').padding(10)
  }
}