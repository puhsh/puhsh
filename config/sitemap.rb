require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://puhsh.com'
SitemapGenerator::Sitemap.create do
  add '/download', changefreq: 'monthly'
  add '/posts', changefreq: 'weekly'
end
