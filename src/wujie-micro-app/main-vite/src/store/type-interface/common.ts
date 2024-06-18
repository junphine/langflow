
export interface ICommon {
  tagMenu:ITag
  tagList: ITagList
  website:any
}
export interface ITag {
    url?: string;
    title?: string;
    name?: string;
}
export interface ITagList {
  [index: number]: Array<ITag>
  length?: number;
  splice: Function;
  findIndex: Function;
  url?: string;
}