export interface AddressItem {
  id: number
  name: string
  userId: number
  province: string
  city: string
  county: string
  addressDetail: string
  areaCode: string
  postalCode: string
  tel: string
  isDefault: boolean
  addTime: string
  updateTime: string
  deleted: boolean
}

interface AddressList {
  total: number;
  pages: number;
  limit: number;
  page: number;
  list: AddressItem[];
}

export interface AddressSaveParams {
  id?: number
  name: string
  tel: string
  province: string
  city: string
  county: string
  areaCode: string
  addressDetail: string
  isDefault?: boolean
  postalCode?: string
}
