import media from '@ohos.multimedia.media'
import { Song } from '../models/Song'

/**
 * 播放器状态
 */
export enum PlayerState {
  IDLE = 'idle',
  PLAYING = 'playing',
  PAUSED = 'paused',
  STOPPED = 'stopped',
  ERROR = 'error'
}

/**
 * 播放模式
 */
export enum PlayMode {
  LOOP = 'loop',           // 列表循环
  SINGLE = 'single',       // 单曲循环
  RANDOM = 'random'        // 随机播放
}

/**
 * 播放器事件监听器接口
 */
export interface PlayerListener {
  onStateChange?: (state: PlayerState) => void
  onSongChange?: (song: Song | null) => void
  onProgressChange?: (current: number, duration: number) => void
  onError?: (error: string) => void
}

/**
 * 业务错误接口
 */
interface BusinessError {
  code: number
  message: string
}

/**
 * 音乐播放服务（单例模式）
 */
export class PlayerService {
  // ========== 单例模式 ==========
  private static instance: PlayerService | null = null

  /**
   * 静态初始化方法
   */
  static async init(): Promise<void> {
    console.info('[PlayerService] 静态初始化开始')
    if (!PlayerService.instance) {
      PlayerService.instance = new PlayerService()
      await PlayerService.instance.initPlayer()
      console.info('[PlayerService] 静态初始化完成')
    } else {
      console.warn('[PlayerService] 已初始化，跳过')
    }
  }

  /**
   * 静态销毁方法
   */
  static async destroy(): Promise<void> {
    console.info('[PlayerService] 静态销毁开始')
    if (PlayerService.instance) {
      await PlayerService.instance.release()
      PlayerService.instance = null
      console.info('[PlayerService] 静态销毁完成')
    } else {
      console.warn('[PlayerService] 未初始化，跳过销毁')
    }
  }

  /**
   * 获取单例实例
   */
  static getInstance(): PlayerService {
    if (!PlayerService.instance) {
      console.error('[PlayerService] 未初始化！请先调用 init()')
      const error = new Error('PlayerService not initialized. Call PlayerService.init() first.')
      throw error
    }
    return PlayerService.instance
  }

  // ========== 私有属性 ==========
  private avPlayer: media.AVPlayer | null = null
  private currentSong: Song | null = null
  private playlist: Song[] = []
  private currentIndex: number = -1
  private playMode: PlayMode = PlayMode.LOOP
  private playerState: PlayerState = PlayerState.IDLE
  private listeners: Set<PlayerListener> = new Set()
  private progressTimer: number = -1
  private isInitialized: boolean = false

  /**
   * 私有构造函数
   */
  private constructor() {
    console.info('[PlayerService] 构造函数调用')
  }

  // ========== 初始化与销毁 ==========

  /**
   * 初始化播放器
   */
  async initPlayer(): Promise<void> {
    if (this.isInitialized) {
      console.warn('[PlayerService] 播放器已初始化')
      return
    }

    try {
      console.info('[PlayerService] 开始初始化播放器')

      // 创建 AVPlayer 实例
      this.avPlayer = await media.createAVPlayer()

      // 设置事件监听
      this.setupPlayerListeners()

      this.isInitialized = true
      console.info('[PlayerService] 播放器初始化成功')
    } catch (err) {
      console.error('[PlayerService] 播放器初始化失败:', err)
      this.notifyError('播放器初始化失败')

      // ✅ 修复：正确抛出 Error
      if (err instanceof Error) {
        throw err
      } else {
        throw new Error(`初始化失败: ${String(err)}`)
      }
    }
  }

  /**
   * 释放资源
   */
  async release(): Promise<void> {
    try {
      console.info('[PlayerService] 开始释放资源')

      // 停止进度定时器
      this.stopProgressTimer()

      // 释放播放器
      if (this.avPlayer) {
        await this.avPlayer.reset()
        await this.avPlayer.release()
        this.avPlayer = null
      }

      // 清空数据
      this.currentSong = null
      this.playlist = []
      this.currentIndex = -1
      this.listeners.clear()
      this.isInitialized = false
      this.playerState = PlayerState.IDLE

      console.info('[PlayerService] 资源释放完成')
    } catch (err) {
      console.error('[PlayerService] 释放资源失败:', err)
    }
  }

  // ========== 播放器事件监听 ==========

  /**
   * 设置播放器事件监听
   */
  private setupPlayerListeners(): void {
    if (!this.avPlayer) return

    // 状态改变
    this.avPlayer.on('stateChange', (state: string) => {
      console.info('[PlayerService] 状态改变:', state)

      switch (state) {
        case 'playing':
          this.updateState(PlayerState.PLAYING)
          this.startProgressTimer()
          break
        case 'paused':
          this.updateState(PlayerState.PAUSED)
          this.stopProgressTimer()
          break
        case 'stopped':
          this.updateState(PlayerState.STOPPED)
          this.stopProgressTimer()
          break
        case 'error':
          this.updateState(PlayerState.ERROR)
          this.stopProgressTimer()
          break
      }
    })

    // 播放完成
    this.avPlayer.on('endOfStream', () => {
      console.info('[PlayerService] 播放完成')
      this.handlePlaybackComplete()
    })

    // 错误处理
    this.avPlayer.on('error', (error: BusinessError) => {
      console.error('[PlayerService] 播放器错误:', error)
      this.notifyError(`播放错误: ${error.message}`)
      this.updateState(PlayerState.ERROR)
    })
  }

  /**
   * 处理播放完成
   */
  private handlePlaybackComplete(): void {
    switch (this.playMode) {
      case PlayMode.SINGLE:
        // 单曲循环
        this.play()
        break
      case PlayMode.RANDOM:
        // 随机播放
        this.playRandomSong()
        break
      case PlayMode.LOOP:
      default:
      // 列表循环
        this.playNext()
        break
    }
  }

  // ========== 播放控制 ==========

  /**
   * 播放歌曲
   */
  async playSong(song: Song): Promise<void> {
    try {
      console.info('[PlayerService] 播放歌曲:', song.name)

      if (!this.avPlayer) {
        const error = new Error('播放器未初始化')
        throw error
      }

      // 重置播放器
      await this.avPlayer.reset()

      // 设置音频源
      this.avPlayer.url = song.audioUrl

      // 准备播放
      await this.avPlayer.prepare()

      // 开始播放
      await this.avPlayer.play()

      // 更新当前歌曲
      this.currentSong = song
      this.notifySongChange()

      console.info('[PlayerService] 开始播放:', song.name)
    } catch (err) {
      console.error('[PlayerService] 播放失败:', err)
      this.notifyError('播放失败')

      // ✅ 修复：正确抛出 Error
      if (err instanceof Error) {
        throw err
      } else {
        throw new Error(`播放失败: ${String(err)}`)
      }
    }
  }

  /**
   * 播放/暂停
   */
  async togglePlay(): Promise<void> {
    if (!this.avPlayer) return

    try {
      if (this.playerState === PlayerState.PLAYING) {
        // ✅ 修复：检查是否为 Promise
        await this.safePlayerCall(() => this.avPlayer!.pause())
        console.info('[PlayerService] 暂停播放')
      } else if (this.playerState === PlayerState.PAUSED) {
        // ✅ 修复：检查是否为 Promise
        await this.safePlayerCall(() => this.avPlayer!.play())
        console.info('[PlayerService] 继续播放')
      } else if (this.currentSong) {
        await this.playSong(this.currentSong)
      }
    } catch (err) {
      console.error('[PlayerService] 切换播放状态失败:', err)
      this.notifyError('播放控制失败')
    }
  }

  /**
   * 暂停
   */
  async pause(): Promise<void> {
    if (!this.avPlayer || this.playerState !== PlayerState.PLAYING) return

    try {
      // ✅ 修复：安全调用
      await this.safePlayerCall(() => this.avPlayer!.pause())
      console.info('[PlayerService] 暂停播放')
    } catch (err) {
      console.error('[PlayerService] 暂停失败:', err)
    }
  }

  /**
   * 继续播放
   */
  async play(): Promise<void> {
    if (!this.avPlayer) return

    try {
      if (this.playerState === PlayerState.PAUSED) {
        // ✅ 修复：安全调用
        await this.safePlayerCall(() => this.avPlayer!.play())
        console.info('[PlayerService] 继续播放')
      } else if (this.currentSong) {
        await this.playSong(this.currentSong)
      }
    } catch (err) {
      console.error('[PlayerService] 播放失败:', err)
    }
  }

  /**
   * 停止播放
   */
  async stop(): Promise<void> {
    if (!this.avPlayer) return

    try {
      // ✅ 修复：安全调用
      await this.safePlayerCall(() => this.avPlayer!.stop())
      this.stopProgressTimer()
      console.info('[PlayerService] 停止播放')
    } catch (err) {
      console.error('[PlayerService] 停止失败:', err)
    }
  }

  /**
   * ✅ 新增：安全的播放器方法调用（处理同步/异步）
   */
  private async safePlayerCall(fn: () => void | Promise<void>): Promise<void> {
    const result = fn()
    if (result instanceof Promise) {
      await result
    }
  }

  // ========== 播放列表管理 ==========

  /**
   * 设置播放列表
   */
  setPlaylist(songs: Song[]): void {
    this.playlist = [...songs]
    console.info('[PlayerService] 设置播放列表，共', songs.length, '首歌')
  }

  /**
   * 添加到播放列表
   */
  addToPlaylist(song: Song): void {
    this.playlist.push(song)
    console.info('[PlayerService] 添加歌曲到播放列表:', song.name)
  }

  /**
   * 播放列表中的歌曲
   */
  async playSongAt(index: number): Promise<void> {
    if (index < 0 || index >= this.playlist.length) {
      console.error('[PlayerService] 无效的歌曲索引:', index)
      return
    }

    this.currentIndex = index
    await this.playSong(this.playlist[index])
  }

  /**
   * 上一曲
   */
  async playPrevious(): Promise<void> {
    if (this.playlist.length === 0) return

    let prevIndex = this.currentIndex - 1
    if (prevIndex < 0) {
      prevIndex = this.playlist.length - 1
    }

    await this.playSongAt(prevIndex)
  }

  /**
   * 下一曲
   */
  async playNext(): Promise<void> {
    if (this.playlist.length === 0) return

    let nextIndex = this.currentIndex + 1
    if (nextIndex >= this.playlist.length) {
      nextIndex = 0
    }

    await this.playSongAt(nextIndex)
  }

  /**
   * 随机播放
   */
  private async playRandomSong(): Promise<void> {
    if (this.playlist.length === 0) return

    const randomIndex = Math.floor(Math.random() * this.playlist.length)
    await this.playSongAt(randomIndex)
  }

  // ========== 播放模式 ==========

  /**
   * 设置播放模式
   */
  setPlayMode(mode: PlayMode): void {
    this.playMode = mode
    console.info('[PlayerService] 播放模式切换为:', mode)
  }

  /**
   * 获取播放模式
   */
  getPlayMode(): PlayMode {
    return this.playMode
  }

  /**
   * 切换播放模式
   */
  togglePlayMode(): PlayMode {
    const modes = [PlayMode.LOOP, PlayMode.SINGLE, PlayMode.RANDOM]
    const currentIndex = modes.indexOf(this.playMode)
    const nextIndex = (currentIndex + 1) % modes.length
    this.playMode = modes[nextIndex]

    console.info('[PlayerService] 播放模式切换为:', this.playMode)
    return this.playMode
  }

  // ========== 进度控制 ==========

  /**
   * 跳转到指定位置
   */
  async seekTo(position: number): Promise<void> {
    if (!this.avPlayer) return

    try {
      await this.avPlayer.seek(position)
      console.info('[PlayerService] 跳转到:', position, 'ms')
    } catch (err) {
      console.error('[PlayerService] 跳转失败:', err)
    }
  }

  /**
   * 获取当前播放位置
   */
  getCurrentPosition(): number {
    return this.avPlayer?.currentTime || 0
  }

  /**
   * 获取总时长
   */
  getDuration(): number {
    return this.avPlayer?.duration || 0
  }

  /**
   * 启动进度定时器
   */
  private startProgressTimer(): void {
    this.stopProgressTimer()

    this.progressTimer = setInterval(() => {
      const current = this.getCurrentPosition()
      const duration = this.getDuration()
      this.notifyProgress(current, duration)
    }, 1000)
  }

  /**
   * 停止进度定时器
   */
  private stopProgressTimer(): void {
    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer)
      this.progressTimer = -1
    }
  }

  // ========== 状态获取 ==========

  /**
   * 获取当前歌曲
   */
  getCurrentSong(): Song | null {
    return this.currentSong
  }

  /**
   * 获取播放列表
   */
  getPlaylist(): Song[] {
    return [...this.playlist]
  }

  /**
   * 获取当前索引
   */
  getCurrentIndex(): number {
    return this.currentIndex
  }

  /**
   * 获取播放状态
   */
  getPlayerState(): PlayerState {
    return this.playerState
  }

  /**
   * 是否正在播放
   */
  isPlaying(): boolean {
    return this.playerState === PlayerState.PLAYING
  }

  // ========== 事件监听器管理 ==========

  /**
   * 添加监听器
   */
  addListener(listener: PlayerListener): void {
    this.listeners.add(listener)
    console.info('[PlayerService] 添加监听器，当前监听器数量:', this.listeners.size)
  }

  /**
   * 移除监听器
   */
  removeListener(listener: PlayerListener): void {
    this.listeners.delete(listener)
    console.info('[PlayerService] 移除监听器，当前监听器数量:', this.listeners.size)
  }

  /**
   * 通知状态改变
   */
  private updateState(state: PlayerState): void {
    this.playerState = state
    this.listeners.forEach(listener => {
      if (listener.onStateChange) {
        listener.onStateChange(state)
      }
    })
  }

  /**
   * 通知歌曲改变
   */
  private notifySongChange(): void {
    this.listeners.forEach(listener => {
      if (listener.onSongChange) {
        listener.onSongChange(this.currentSong)
      }
    })
  }

  /**
   * 通知进度改变
   */
  private notifyProgress(current: number, duration: number): void {
    this.listeners.forEach(listener => {
      if (listener.onProgressChange) {
        listener.onProgressChange(current, duration)
      }
    })
  }

  /**
   * 通知错误
   */
  private notifyError(error: string): void {
    this.listeners.forEach(listener => {
      if (listener.onError) {
        listener.onError(error)
      }
    })
  }
}
