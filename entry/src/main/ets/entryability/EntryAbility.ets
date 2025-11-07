import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { PlayerService } from '../services/PlayerService';

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    // ✅ 初始化播放器服务
    try {
      await PlayerService.init();
      hilog.info(0x0000, 'testTag', 'PlayerService initialized successfully');
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'PlayerService init failed: %{public}s', JSON.stringify(error));
    }
  }

  async onDestroy(): Promise<void> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');

    // ✅ 释放播放器服务
    try {
      await PlayerService.destroy();
      hilog.info(0x0000, 'testTag', 'PlayerService destroyed successfully');
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'PlayerService destroy failed: %{public}s', JSON.stringify(error));
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
