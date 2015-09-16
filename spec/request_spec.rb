require 'spec_helper'

describe BestBuy::Request do
  it 'only supports VALID_ENDPOINTS' do
    expect{described_class.new(api_key: '1234', endpoint: 'nuclear_waste')}.to raise_exception(BestBuy::APIError, /unsupported/)
  end

  it 'joins multiple filters with pipes' do
    req = described_class.new(api_key: '1234', endpoint: 'products', filters: ["upc=004815162342", "longDescription=GoPro*"])
    expect(req.to_s).to eq("https://api.bestbuy.com/v1/products(upc=004815162342|longDescription=GoPro*)?apiKey=1234&format=json")
  end

  describe 'select' do
    it 'restricts the returned fields from the API' do
      req = described_class.new(api_key: '1234', endpoint: 'products', filters: ["upc=004815162342", "longDescription=GoPro*"])
      expect(req.pluck(:sku, :name).to_s).to eq("https://api.bestbuy.com/v1/products(upc=004815162342|longDescription=GoPro*)?apiKey=1234&format=json&show=sku,name")
    end
  end
end
