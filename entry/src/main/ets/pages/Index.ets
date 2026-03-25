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
import { categoryBar } from '../component/category/categoryBar';

@Entry
@Component
struct Index {

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
  categoryBuilder() {
    categoryBar()
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
        recommendContent: this.categoryBuilder,
        favoriteContent: this.favoriteBuilder,
        moreContent: this.moreBuilder
      })
    }
    .height('100%')
    .width('100%')
  }
}