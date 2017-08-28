require 'spec_helper'
require_relative '../../../lib/utils/url_with_base_domain'

describe Utils::UrlWithBaseDomain do
  describe '#subdomain' do
    it 'returns subdomain from base domain' do
      url = described_class.new('http://aaa.bbb.pl/stuff', 'bbb.pl')

      expect(url.subdomain).to eq('aaa')
    end

    it 'returns nil when subdomain is not present in the uri' do
      url = described_class.new('http://bbb.pl/stuff', 'bbb.pl')

      expect(url.subdomain).to be_nil
    end
  end

  describe '#to_s' do
    it 'returns current state of the uri' do
      url = described_class.new('http://aaa.bbb.pl/stuff', 'bbb.pl')

      expect(url.to_s).to eq('http://aaa.bbb.pl/stuff')
    end
  end

  describe '#subdomain=' do
    it 'changes subdomain in the uri' do
      uri = described_class.new('http://aaa.bbb.pl/stuff', 'bbb.pl')

      uri.subdomain = 'test'

      expect(uri.to_s).to eq('http://test.bbb.pl/stuff')
    end

    it 'removes subdomain when nil is passed' do
      uri = described_class.new('http://aaa.bbb.pl/stuff', 'bbb.pl')

      uri.subdomain = nil

      expect(uri.to_s).to eq('http://bbb.pl/stuff')
    end

    it 'removes subdomain when empty string is passed' do
      uri = described_class.new('http://aaa.bbb.pl/stuff', 'bbb.pl')

      uri.subdomain = ''

      expect(uri.to_s).to eq('http://bbb.pl/stuff')
    end
  end
end
