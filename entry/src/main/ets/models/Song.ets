/**
 * 网易云 API 返回的歌手数据结构
 */
export interface ApiArtist {
  name: string
  id?: number
}

/**
 * 网易云 API 返回的专辑数据结构
 */
export interface ApiAlbum {
  name: string
  picUrl?: string
  pic_str?: string
  id?: number
}

/**
 * 网易云 API 返回的歌曲数据结构
 */
export interface ApiSongData {
  id: number
  name: string
  artists?: ApiArtist[]
  ar?: ApiArtist[]
  album?: ApiAlbum
  al?: ApiAlbum
}

/**
 * 歌曲实体类
 */
export class Song {
  id: number
  name: string
  artist: string
  album: string
  cover: string

  constructor(id: number, name: string, artist: string, album: string, cover: string) {
    this.id = id
    this.name = name
    this.artist = artist
    this.album = album
    this.cover = cover
  }

  /**
   * 从 API 响应数据创建 Song 对象
   */
  static fromApiResponse(data: ApiSongData): Song {
    const artists = data.artists || data.ar || []
    const album = data.album || data.al

    return new Song(
      data.id,
      data.name,
      artists.length > 0 ? artists[0].name : '未知歌手',
      album?.name || '未知专辑',
      album?.picUrl || album?.pic_str || ''
    )
  }
}
