import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);

    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    let windowClass: window.Window = windowStage.getMainWindowSync();
    windowClass.setWindowLayoutFullScreen(true);
    let TYPE_SYSTEM = window.AvoidAreaType.TYPE_SYSTEM //系统保留区域（状态栏、导航栏等）
    let TYPE_CUTOUT = window.AvoidAreaType.TYPE_CUTOUT //刘海屏/挖孔屏区域
    let TYPE_KEYBOARD = window.AvoidAreaType.TYPE_KEYBOARD //软键盘弹出区域
    let TYPE_SYSTEM_GESTURE = window.AvoidAreaType.TYPE_SYSTEM_GESTURE //手势操作冲突区域（如灵动岛）
    let TYPE_NAVIGATION_INDICATOR = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR //导航与指示器
    let avoidArea = windowClass.getWindowAvoidArea(TYPE_NAVIGATION_INDICATOR) //得到避让区
    //导航条的高度
    let topRect = avoidArea.topRect.height;
    let bottomRect = avoidArea.bottomRect.height;
    //放置全局应用存储中
    AppStorage.setOrCreate<number>("topRect", topRect)
    AppStorage.setOrCreate<number>("bottomRect", bottomRect)
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}