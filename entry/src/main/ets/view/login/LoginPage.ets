import { Prompt } from '@kit.ArkUI';
import PreferencesUtil from '../../utils/PreferencesUtil';
import { LoginParams } from '../../viewModel/mine/mine';
import { login } from '../../api/mine/mine';

@Entry
@Component
struct LoginPage {
  private router = this.getUIContext().getRouter()
  private prompt = this.getUIContext().getPromptAction()

  @State username: string = 'user123';
  @State password: string = 'user123';
  @State isLoading: boolean = false;

  async handleLogin() {
    if (!this.username || !this.password) {
      this.prompt.showToast({ message: '请输入用户名和密码' });
      return;
    }

    this.isLoading = true;
    const params: LoginParams = {
      username: this.username,
      password: this.password
    };

    try {
      const res = await login(params);
      console.log(JSON.stringify(res))
      this.isLoading = false;

      if (res.errno === 0 && res.data) {
        // 1. 保存 Token
        console.log(JSON.stringify(res.data))
        await PreferencesUtil.saveToken(res.data.token);

        this.prompt.showToast({ message: '登录成功' });

        // 2. 返回上一页 (或者根据业务需求跳转到首页)
        this.router.back();
      } else {
        this.prompt.showToast({ message: res.errmsg || '登录失败' });
      }
    } catch (error) {
      this.isLoading = false;
      this.prompt.showToast({ message: '网络请求异常' });
      console.error(JSON.stringify(error));
    }
  }

  build() {
    Column() {
      Text('用户登录')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 100, bottom: 50 })

      TextInput({ placeholder: '请输入用户名', text: this.username })
        .onChange((value: string) => {
          this.username = value;
        })
        .margin({ bottom: 20 })

      TextInput({ placeholder: '请输入密码', text: this.password })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        })
        .margin({ bottom: 40 })

      Button(this.isLoading ? '登录中...' : '登录')
        .width('100%')
        .enabled(!this.isLoading)
        .onClick(() => {
          this.handleLogin();
        })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 20, right: 20 })
  }
}