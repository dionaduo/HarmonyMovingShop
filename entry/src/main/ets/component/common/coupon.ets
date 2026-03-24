@Component
export struct coupon {

  @Prop discount: number = 0
  @Prop desc: string = ''
  @Prop tag: string = ''
  @Prop name: string = ''
  @Prop days: number = 0

  build() {
    Column(){
      Row() {
        Column() {
          Row() {
            Text('$' + this.discount + '元').fontSize(16).fontColor(Color.Red).padding(5)
          }

          Row() {
            Text(this.desc + '-' + this.tag).fontSize(12).fontColor(Color.Gray).padding(5)
          }
        }.layoutWeight(2)

        Column() {
          Row() {
            Text(this.name).fontSize(14).fontColor(Color.Black).padding(5)
          }

          Row() {
            Text(this.days + '天').fontSize(10).fontColor(Color.Gray).padding(5)
          }
        }.layoutWeight(8)
      }.border({ width: 1, color: Color.Red })
      .borderRadius(5)
      .height(80)
      .padding(5)
    }
  }
}