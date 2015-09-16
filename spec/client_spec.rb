require 'spec_helper'

describe BestBuy::Client do
  it 'raises argument error when not provided with an API key' do
    expect{ BestBuy::Client.new }.to raise_exception(ArgumentError, /api key/i)
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
