// entry/src/main/ets/pages/PlayerPage.ets

import { PlayerService } from '../services/PlayerService'
import { Song } from '../models/Song'

@Entry
@Component
struct PlayerPage {
  @State currentSong: Song | null = null
  @State isPlaying: boolean = false
  @State currentTime: number = 0
  @State duration: number = 0

  private playerService: PlayerService = PlayerService.getInstance()

  aboutToAppear(): void {
    this.loadCurrentSong()
    this.subscribeToPlayerState()
  }

  private loadCurrentSong(): void {
    const song = this.playerService.currentSong
    if (song) {
      this.currentSong = song
      this.duration = song.duration
    }
  }

  private subscribeToPlayerState(): void {
    this.currentSong = this.playerService.currentSong
    this.isPlaying = this.playerService.isPlaying
  }

  private handlePlayPause(): void {
    this.playerService.togglePlay()
    this.isPlaying = this.playerService.isPlaying
  }

  private handlePrevious(): void {
    this.playerService.playPrevious()  // ✅ 改为 playPrevious
    this.loadCurrentSong()
  }

  private handleNext(): void {
    this.playerService.playNext()  // ✅ 改为 playNext
    this.loadCurrentSong()
  }

  private formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return mins.toString() + ':' + (secs < 10 ? '0' : '') + secs.toString()
  }

  build() {
    Column() {
      if (this.currentSong) {
        Column() {
          Image(this.currentSong.coverUrl)
            .width(300)
            .height(300)
            .borderRadius(12)
            .margin({ top: 60, bottom: 40 })

          Text(this.currentSong.name)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          Text(this.currentSong.artist)
            .fontSize(16)
            .fontColor('#999999')
            .margin({ bottom: 40 })

          Row() {
            Text(this.formatTime(this.currentTime))
              .fontSize(12)
              .fontColor('#999999')

            Slider({
              value: this.currentTime,
              min: 0,
              max: this.duration,
              step: 1
            })
              .width('70%')
              .margin({ left: 12, right: 12 })

            Text(this.formatTime(this.duration))
              .fontSize(12)
              .fontColor('#999999')
          }
          .width('90%')
          .margin({ bottom: 40 })

          Row() {
            Button('Previous')
              .fontSize(16)
              .onClick(() => this.handlePrevious())
              .margin({ right: 20 })

            Button(this.isPlaying ? 'Pause' : 'Play')
              .fontSize(20)
              .onClick(() => this.handlePlayPause())
              .margin({ right: 20 })

            Button('Next')
              .fontSize(16)
              .onClick(() => this.handleNext())
          }
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
      } else {
        Text('No song playing')
          .fontSize(18)
          .fontColor('#999999')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
