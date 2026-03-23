@Component
export struct header {
  @State head:string =''
  @State moreHead:string =''

  build() {
    Row() {
      Column() {
        Text(this.head).fontSize(14).fontColor(Color.Black).textAlign(TextAlign.Start)
      }

      Column() {
        Row() {
          Text(this.moreHead).fontSize(10).fontColor(Color.Gray)
            .fontColor(Color.Black)
            .textAlign(TextAlign.End)
          Image($r('app.media.right_arrow'))
            .width(14)
            .objectFit(ImageFit.Contain)
            .padding({ bottom: 1 })
        }
      }
    }.width('100%').height(18).justifyContent(FlexAlign.SpaceBetween)
  }
}