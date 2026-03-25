import { GoodsItem } from "../../viewModel/goods/goods"
import { Font } from "@ohos.arkui.UIContext"

@Component
export struct lineGoods {
  @Prop picUrl:string = ''
  @Prop name:string = ''
  @Prop retailPrice:number = 0
  build() {
    Column() {
      Image(this.picUrl)
        .objectFit(ImageFit.Contain)
        .borderRadius(10)
        .height(100)

      Text(this.name)
        .fontSize(12)
        .fontColor(Color.Black)
        .fontWeight('bold')
      if (this.retailPrice){
        Text('$ ' + this.retailPrice)
          .fontSize(10)
          .padding(2)
          .fontColor(Color.Red)
          .fontWeight(FontWeight.Bolder)
      }
    }
    .width('100%')
    .height(130)
    .border({
      width: 1,
      style: BorderStyle.Solid,
      color: Color.Gray
    })
    .borderRadius(5)
  }
}