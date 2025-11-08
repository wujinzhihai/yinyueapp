// entry/src/main/ets/models/Song.ts

/**
 * 歌曲数据接口
 */
export interface ISong {
  id: number
  name: string
  artist: string
  album: string
  duration: number
  audioUrl: string
  coverUrl: string
}

/**
 * 歌曲数据模型
 */
export class Song implements ISong {
  id: number
  name: string
  artist: string
  album: string
  duration: number
  audioUrl: string
  coverUrl: string

  constructor(
    id: number,
    name: string,
    artist: string,
    album: string,
    duration: number,
    audioUrl: string,
    coverUrl: string
  ) {
    this.id = id
    this.name = name
    this.artist = artist
    this.album = album
    this.duration = duration
    this.audioUrl = audioUrl
    this.coverUrl = coverUrl
  }

  /**
   * 从API响应创建Song对象
   */
  static fromJson(json: Record<string, Object>): Song {
    return new Song(
      json['id'] as number,
      json['name'] as string,
      json['artist'] as string,
      json['album'] as string,
      json['duration'] as number,
      json['audioUrl'] as string,
      json['coverUrl'] as string
    )
  }

  // ========== 兼容属性 ==========
  get singer(): string {
    return this.artist
  }

  get url(): string {
    return this.audioUrl
  }

  get picUrl(): string {
    return this.coverUrl
  }
}
