@Component
export struct header {
  @Prop head:string =''
  @Prop moreHead:string =''
  @Prop moreHeadUrl:string =''

  build() {
    Row() {
      Column() {
        Text(this.head).fontSize(14).fontColor(Color.Black).textAlign(TextAlign.Start)
      }

      Column() {
        Row() {
          Text(this.moreHead).fontSize(10).fontColor(Color.Gray)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.End)
          Image($r('app.media.right_arrow'))
            .width(14)
            .objectFit(ImageFit.Contain)
            .padding({ bottom: 1 })
        }.onClick(() => {
          if (this.moreHeadUrl) {
            this.getUIContext().getRouter().pushUrl({
              url: this.moreHeadUrl
            }).catch((err: string) => {
              console.log('跳转失败,错误信息:' + err)
            })
          }
        })
      }
    }.width('100%').height(20)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({bottom:5,top:5})
  }
}