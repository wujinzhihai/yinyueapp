// entry/src/main/ets/pages/PlayerPage.ets

import { PlayerService } from '../services/PlayerService'
import { Song } from '../models/Song'
import router from '@ohos.router'

@Entry
@Component
struct PlayerPage {
  @State currentSong: Song | null = null
  @State isPlaying: boolean = false
  @State currentTime: number = 0
  @State duration: number = 0

  private playerService: PlayerService = PlayerService.getInstance()
  private updateTimer: number = -1

  aboutToAppear(): void {
    console.info('[PlayerPage] 页面启动')
    this.loadCurrentSong()
    this.startStateUpdate()
  }

  aboutToDisappear(): void {
    console.info('[PlayerPage] 页面销毁')
    clearInterval(this.updateTimer)
  }

  // ✅ 启动定时更新
  private startStateUpdate(): void {
    this.updateTimer = setInterval(() => {
      this.updatePlayerState()
    }, 500)
  }

  // ✅ 更新播放器状态
  private updatePlayerState(): void {
    this.currentSong = this.playerService.currentSong
    this.isPlaying = this.playerService.isPlaying
    // ✅ 修复：直接使用 currentTime 属性（毫秒转秒）
    this.currentTime = Math.floor(this.playerService.currentTime / 1000)

    if (this.currentSong) {
      this.duration = this.currentSong.duration
    }
  }

  private loadCurrentSong(): void {
    const song = this.playerService.currentSong
    if (song) {
      this.currentSong = song
      this.duration = song.duration
      console.info(`[PlayerPage] 当前歌曲: ${song.name}`)
    } else {
      console.warn('[PlayerPage] ⚠️ 无当前歌曲')
    }
  }

  private handlePlayPause(): void {
    console.info('[PlayerPage] 切换播放状态')
    this.playerService.togglePlay()
    this.isPlaying = this.playerService.isPlaying
  }

  private handlePrevious(): void {
    console.info('[PlayerPage] 上一曲')
    this.playerService.playPrevious()
    this.loadCurrentSong()
  }

  private handleNext(): void {
    console.info('[PlayerPage] 下一曲')
    this.playerService.playNext()
    this.loadCurrentSong()
  }

  // ✅ 返回首页
  private handleBack(): void {
    router.back()
  }

  // ✅ 修复：改为 minutes 消除警告
  private formatTime(seconds: number): string {
    const minutes = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return minutes.toString() + ':' + (secs < 10 ? '0' : '') + secs.toString()
  }

  build() {
    Column() {
      // ✅ 顶部返回按钮
      Row() {
        Button('← 返回')
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .fontColor('#333333')
          .onClick(() => this.handleBack())
      }
      .width('100%')
      .padding({ left: 20, top: 20, bottom: 10 })
      .justifyContent(FlexAlign.Start)

      if (this.currentSong) {
        Column() {
          // 封面
          Image(this.currentSong.coverUrl)
            .width(300)
            .height(300)
            .borderRadius(12)
            .margin({ top: 40, bottom: 40 })
            .alt($r('app.media.app_icon'))  // ✅ 加载失败时显示默认图标

          // 歌曲信息
          Text(this.currentSong.name)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .margin({ bottom: 8 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.currentSong.artist)
            .fontSize(16)
            .fontColor('#999999')
            .margin({ bottom: 40 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          // 进度条
          Row() {
            Text(this.formatTime(this.currentTime))
              .fontSize(12)
              .fontColor('#999999')
              .width(45)

            Slider({
              value: this.currentTime,
              min: 0,
              max: this.duration > 0 ? this.duration : 1,
              step: 1
            })
              .layoutWeight(1)
              .margin({ left: 12, right: 12 })
              .trackColor('#E0E0E0')
              .selectedColor('#FF1744')

            Text(this.formatTime(this.duration))
              .fontSize(12)
              .fontColor('#999999')
              .width(45)
          }
          .width('90%')
          .margin({ bottom: 50 })

          // 控制按钮
          Row() {
            Button('⏮️')
              .fontSize(32)
              .backgroundColor(Color.Transparent)
              .fontColor('#333333')
              .onClick(() => this.handlePrevious())

            Button(this.isPlaying ? '⏸️' : '▶️')
              .fontSize(48)
              .backgroundColor('#FF1744')
              .fontColor('#FFFFFF')
              .width(80)
              .height(80)
              .borderRadius(40)
              .margin({ left: 40, right: 40 })
              .onClick(() => this.handlePlayPause())

            Button('⏭️')
              .fontSize(32)
              .backgroundColor(Color.Transparent)
              .fontColor('#333333')
              .onClick(() => this.handleNext())
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)

      } else {
        // 无歌曲时显示
        Column() {
          Text('🎵')
            .fontSize(60)
            .margin({ bottom: 20 })
          Text('暂无播放歌曲')
            .fontSize(18)
            .fontColor('#999999')
          Button('返回首页')
            .fontSize(16)
            .margin({ top: 30 })
            .onClick(() => this.handleBack())
        }
        .layoutWeight(1)
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }
}
