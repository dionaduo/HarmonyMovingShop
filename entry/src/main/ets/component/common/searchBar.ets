import { window } from '@kit.ArkUI'

@Component
export struct searchBar {
  aboutToAppear(): void {
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }
  build() {
    Column(){
      Search().width('90%').height(40)
    }.width('100%')
  }
}