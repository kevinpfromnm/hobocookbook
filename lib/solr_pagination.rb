module ActsAsSolr
  module ClassMethods
    def solr_paginated_search(query, options = {})
      page     = options[:page] || 1
      per_page = options[:per_page] || 10
      total    = options[:total_entries]
      options.delete(:page)
      options.delete(:per_page)
      pager = WillPaginate::Collection.new(page, per_page, total)
      options.merge!(:offset => pager.offset, :limit => per_page)
      result = find_by_solr(query, options)
      returning WillPaginate::Collection.new(page, per_page, 
                                            result.try.total_hits || 0) do |p|
        p.replace result.try.docs || []
      end
    end
  end
end
