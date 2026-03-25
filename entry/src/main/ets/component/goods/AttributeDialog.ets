import { Attribute } from "../../viewModel/goods/goodsDetail"
@CustomDialog
@Component
export struct AttributeDialog {
  private attrDialogController: CustomDialogController;
  @Prop attributes: Attribute[] // 动态属性数据

  build() {
    Column() {
      // 标题栏+拉动把手
      Row() {
        Text("商品属性详情").fontSize(18)
      }
      .padding(10)

      Divider().height(4).width(40).backgroundColor(Color.Gray) // 拉动指示条

      // 属性列表（支持滚动）
      List({ space: 5 }) {
        ForEach(this.attributes, (item: Attribute) => {
          ListItem() {
            Row({space:15}){
              Text(item.attribute).fontSize(14)
              Text(item.value).fontSize(13).width('75%')
            }.padding(10).width('100%')
          }
        })
      }
      .width('100%')
      .height('100%')
      .padding({bottom:10})
    }
    .height(400)
    .zIndex(999)
    .width('100%')
    .borderRadius(20)
    .backgroundColor(Color.White)
  }
}