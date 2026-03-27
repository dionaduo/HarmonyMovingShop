// api/address/address.ts
import { httpRequest } from "../../utils/request"
import { ApiResponse } from "../../viewModel"
import { AddressItem, AddressSaveParams } from "../../viewModel/address/address"
import { PageList } from "../../viewModel/category/catalog"

export const getAddressList = (): Promise<ApiResponse<PageList<AddressItem>>> => {
  return httpRequest.get('address/list')
}

export const getAddressDetail = (id: number): Promise<ApiResponse<PageList<AddressItem>>> => {
  console.log('【API】getAddressDetail ID:', id);
  return httpRequest.get('/address/detail', { params: { id: id } });
};

export const saveAddress = (data: AddressSaveParams): Promise<ApiResponse<PageList<AddressItem>>> => {
  return httpRequest.post('address/save', data)
}

export const deleteAddress = (id: number): Promise<ApiResponse<PageList<AddressItem>>> => {
  return httpRequest.post('address/delete', id )
}