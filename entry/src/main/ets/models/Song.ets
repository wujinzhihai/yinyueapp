// D:\hongmengxitong\MusicApp\entry\src\main\ets\models\Song.ts
/**
 * 歌曲数据模型
 */
export class Song {
  id: number
  name: string
  artist: string
  albumName: string // 专辑名称属性
  coverUrl: string | Resource
  audioUrl: string
  duration: number

  constructor(
    id: number = 0,
    name: string = '',
    artist: string = '',
    albumName: string = '', // 专辑名称参数
    coverUrl: string | Resource = '',
    audioUrl: string = '',
    duration: number = 0
  ) {
    this.id = id
    this.name = name
    this.artist = artist
    this.albumName = albumName // 赋值给专辑名称属性
    this.coverUrl = coverUrl
    this.audioUrl = audioUrl
    this.duration = duration
  }
}
