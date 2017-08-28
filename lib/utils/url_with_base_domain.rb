module Utils
  class UrlWithBaseDomain
    def initialize(uri, base_domain)
      @uri = URI.parse(uri)
      @base_domain = base_domain
    end

    def subdomain
      domain_parts = parts(@uri.host)
      base_domain_parts = parts(@base_domain)
      components_count = base_domain_parts.size
      unless @uri.host.ends_with?(@base_domain)
        raise "Base domain doesn't match the URI"
      end
      domain_parts.pop(components_count)
      domain_parts.empty? ? nil : domain_parts.join('.')
    end

    def remove_subdomain
      self.subdomain = nil
    end

    def subdomain=(new_subdomain)
      @uri.host = [new_subdomain, @base_domain].reject(&:blank?).join('.')
    end

    def to_s
      @uri.to_s
    end

    private

    def parts(domain)
      domain.split('.')
    end
  end
end
