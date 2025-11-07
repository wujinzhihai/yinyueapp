/**
 * 歌曲数据模型
 */
export class Song {
  /**
   * 歌曲ID
   */
  id: number

  /**
   * 歌曲名称
   */
  name: string

  /**
   * 艺术家
   */
  artist: string

  /**
   * 专辑名称
   */
  album: string

  /**
   * 封面图URL
   */
  coverUrl: string

  /**
   * 歌曲时长（秒）
   */
  duration: number

  /**
   * 音频文件URL（可选）
   */
  audioUrl?: string

  /**
   * 构造函数
   * @param id 歌曲ID
   * @param name 歌曲名称
   * @param artist 艺术家
   * @param album 专辑名称
   * @param coverUrl 封面图URL
   * @param duration 歌曲时长（秒），默认180秒
   * @param audioUrl 音频文件URL（可选）
   */
  constructor(
    id: number,
    name: string,
    artist: string,
    album: string,
    coverUrl: string,
    duration: number = 180,
    audioUrl?: string
  ) {
    this.id = id
    this.name = name
    this.artist = artist
    this.album = album
    this.coverUrl = coverUrl
    this.duration = duration
    this.audioUrl = audioUrl
  }
}
