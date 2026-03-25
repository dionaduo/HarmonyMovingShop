import { window } from '@kit.ArkUI';
import { tabBarComponent } from '../component/common/tabBarComponent';
import { HomeBuilder } from '../component/home/HomeBuilder';
import { ChannelBar } from '../component/home/ChannelBar';
import { CouponBar } from '../component/home/CouponBar';
import { GrouponBar } from '../component/home/GrouponBar';
import { BrandBar } from '../component/home/BrandBar';
import { NewGoodsBar } from '../component/home/NewGoodsBar';
import { HotGoodsBar } from '../component/home/HotGoodsBar';
import { TopicBar } from '../component/home/TopicBar';
@Entry
@Component
struct Index {
  aboutToAppear(): void {
    window.getLastWindow(this.getUIContext().getHostContext()).then((win)=>{
      win.setWindowLayoutFullScreen(true).catch((err:string)=>{
        console.log(err)
      })
    })
  }

  @Builder
  homeBuilder() {
    Scroll(){
      Column(){
        HomeBuilder()
        ChannelBar()
        CouponBar()
        GrouponBar()
        BrandBar()
        NewGoodsBar()
        HotGoodsBar()
        TopicBar()
      }
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
  }
  @Builder
  recommendBuilder() {
    Column() {
      Text('推荐页面内容')
    }.width('100%').height('100%')
  }
  @Builder
  favoriteBuilder() {
    Column() {
      Text('收藏页面内容')
    }.width('100%').height('100%')
  }
  @Builder
  moreBuilder() {
    Column() {
      Text('更多页面内容')
    }
    .width('100%').height('100%')
  }

  build() {
    Column() {
      tabBarComponent({
        homeContent: this.homeBuilder,
        recommendContent: this.recommendBuilder,
        favoriteContent: this.favoriteBuilder,
        moreContent: this.moreBuilder
      })
    }
    .height('100%')
    .width('100%')
  }
}