import preferences from '@ohos.data.preferences';

const PREFERENCES_NAME = 'MyAppStore';
const KEY_TOKEN = 'userToken';

class PreferencesUtil {
  private preferences: preferences.Preferences | null = null;

  // 初始化，建议在 EntryAbility 的 onCreate 或 onWindowStageCreate 中调用
  async init(context: Context) {
    try {
      this.preferences = await preferences.getPreferences(context, PREFERENCES_NAME);
    } catch (err) {
      console.error(`Failed to get preferences. Code: ${err.code}, message:${err.message}`);
    }
  }

  // 保存 Token
  async saveToken(token: string) {
    if (!this.preferences) {
      console.warn("Preferences not initialized");
      return;
    }
    try {
      await this.preferences.put(KEY_TOKEN, token);
      await this.preferences.flush();
    } catch (err) {
      console.error(`Failed to save token. Code: ${err.code}, message:${err.message}`);
    }
  }

  // 获取 Token
  async getToken(): Promise<string> {
    if (!this.preferences) {
      console.warn("Preferences not initialized");
      return '';
    }
    try {
      return await this.preferences.get(KEY_TOKEN, '') as string;
    } catch (err) {
      console.error(`Failed to get token. Code: ${err.code}, message:${err.message}`);
      return '';
    }
  }

  // 删除 Token (退出登录时使用)
  async deleteToken() {
    if (!this.preferences) return;
    try {
      await this.preferences.delete(KEY_TOKEN);
      await this.preferences.flush();
    } catch (err) {
      console.error(`Failed to delete token. Code: ${err.code}, message:${err.message}`);
    }
  }
}

export default new PreferencesUtil();