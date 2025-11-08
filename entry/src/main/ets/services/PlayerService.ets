// entry/src/main/ets/services/PlayerService.ets

import { media } from '@kit.MediaKit'
import { Song } from '../models/Song'

/**
 * 音乐播放服务 - 单例模式
 * ❌ 移除 @ObservedV2 - 因为会导致 @State 冲突
 */
export class PlayerService {
  private static instance: PlayerService
  private avPlayer: media.AVPlayer | null = null

  // ========== 播放状态 (不使用装饰器) ==========
  currentSong: Song | null = null
  isPlaying: boolean = false
  currentTime: number = 0
  duration: number = 0
  playlist: Song[] = []
  currentIndex: number = -1

  // 状态变化回调
  onStateChange: (() => void) | null = null

  private constructor() {
    this.initPlayer()
  }

  static getInstance(): PlayerService {
    if (!PlayerService.instance) {
      PlayerService.instance = new PlayerService()
    }
    return PlayerService.instance
  }

  private async initPlayer(): Promise<void> {
    try {
      this.avPlayer = await media.createAVPlayer()
      console.info('[PlayerService] ✅ AVPlayer 初始化成功')

      this.avPlayer.on('stateChange', (state) => {
        console.info(`[PlayerService] 状态变化: ${state}`)
      })

      this.avPlayer.on('endOfStream', () => {
        console.info('[PlayerService] 播放完成')
        this.playNext()
      })

      this.avPlayer.on('durationUpdate', (duration) => {
        this.duration = duration
        this.notifyStateChange()
        console.info(`[PlayerService] 时长: ${this.formatTime(duration)}`)
      })

      this.avPlayer.on('timeUpdate', (time) => {
        this.currentTime = time
        this.notifyStateChange()
      })

      this.avPlayer.on('error', (err) => {
        console.error('[PlayerService] ❌ 播放错误:', JSON.stringify(err))
        this.playNext()
      })

    } catch (err) {
      console.error('[PlayerService] ❌ 初始化失败:', JSON.stringify(err))
    }
  }

  setPlaylist(songs: Song[]): void {
    this.playlist = songs
    console.info(`[PlayerService] 播放列表已设置: ${songs.length} 首歌曲`)
  }

  async playSong(song: Song, index?: number): Promise<void> {
    if (!this.avPlayer) {
      console.error('[PlayerService] ❌ 播放器未初始化')
      return
    }

    try {
      console.info(`[PlayerService] 🎵 开始播放: ${song.name}`)

      await this.avPlayer.reset()

      this.currentSong = song
      this.currentIndex = index ?? this.playlist.findIndex(s => s.id === song.id)

      // ✅ 使用 audioUrl
      const songUrl: string = song.audioUrl
      this.avPlayer.url = songUrl
      await this.avPlayer.prepare()
      await this.avPlayer.play()

      this.isPlaying = true
      this.notifyStateChange()
      console.info('[PlayerService] ✅ 播放成功')

    } catch (err) {
      console.error('[PlayerService] ❌ 播放失败:', JSON.stringify(err))
      this.isPlaying = false
      this.notifyStateChange()
    }
  }

  async togglePlay(): Promise<void> {
    if (!this.avPlayer || !this.currentSong) return

    try {
      if (this.isPlaying) {
        await this.avPlayer.pause()
        this.isPlaying = false
        console.info('[PlayerService] ⏸ 已暂停')
      } else {
        await this.avPlayer.play()
        this.isPlaying = true
        console.info('[PlayerService] ▶ 已播放')
      }
      this.notifyStateChange()
    } catch (err) {
      console.error('[PlayerService] ❌ 切换失败:', JSON.stringify(err))
    }
  }

  async playPrevious(): Promise<void> {
    if (this.playlist.length === 0) return

    const prevIndex = this.currentIndex > 0 ? this.currentIndex - 1 : this.playlist.length - 1
    await this.playSong(this.playlist[prevIndex], prevIndex)
  }

  async playNext(): Promise<void> {
    if (this.playlist.length === 0) return

    const nextIndex = this.currentIndex < this.playlist.length - 1 ? this.currentIndex + 1 : 0
    await this.playSong(this.playlist[nextIndex], nextIndex)
  }

  async seekTo(time: number): Promise<void> {
    if (!this.avPlayer) return

    try {
      await this.avPlayer.seek(time)
      this.currentTime = time
      this.notifyStateChange()
      console.info(`[PlayerService] 跳转到: ${this.formatTime(time)}`)
    } catch (err) {
      console.error('[PlayerService] ❌ 跳转失败:', JSON.stringify(err))
    }
  }

  formatTime(ms: number): string {
    const seconds = Math.floor(ms / 1000)
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  async release(): Promise<void> {
    if (this.avPlayer) {
      await this.avPlayer.release()
      this.avPlayer = null
      console.info('[PlayerService] 🔚 播放器已释放')
    }
  }

  // 通知状态变化
  private notifyStateChange(): void {
    if (this.onStateChange) {
      this.onStateChange()
    }
  }
}
