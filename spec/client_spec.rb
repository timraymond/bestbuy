require 'spec_helper'

describe BestBuy::Client do
  it 'raises argument error when not provided with an API key' do
    expect{ BestBuy::Client.new }.to raise_exception(ArgumentError, /api key/i)
  end

  it 'creates requests with affiliate tracking ID' do
    bby = BestBuy::Client.new(api_key: '123456', affiliate_tracking_id: 'foobar')
    expect(bby.products(upc: '8675309').to_s).to eq('https://api.bestbuy.com/v1/products(upc=8675309)?LID=foobar&apiKey=123456&format=json')
  end

  describe 'products' do
    let(:bby) { BestBuy::Client.new(api_key: '1234deadbeef') }

    it 'returns a products query for a given upc' do
      query = bby.products(upc: '004815162342')
      expect(query.to_s).to eq('https://api.bestbuy.com/v1/products(upc=004815162342)?apiKey=1234deadbeef&format=json')
    end

    describe 'to_curl' do
      it 'returns an exec\'able curl command' do
        query = bby.products(upc: '004815162342')
        expect(query.to_curl).to eq('curl https://api.bestbuy.com/v1/products(upc=004815162342)?apiKey=1234deadbeef&format=json')
      end
    end
  end
end
