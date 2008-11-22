#!/usr/bin/env ruby

require 'open-uri'

module Nginx
  module Fetch
    CHANGES_URL = "http://nginx.net/CHANGES"
    TARBALL_URL = "http://sysoev.ru/nginx/nginx-:version.tar.gz"
    CHANGE_VERSION_REGEXP = /nginx\s*(\d+\.\d+\.\d+)/i
      
    def fetch_versions
      open(CHANGES_URL).read.grep(CHANGE_VERSION_REGEXP).inject([]) do |a, l| 
        a << $1 if l =~ CHANGE_VERSION_REGEXP
        a
      end
    end
    
    def fetch_tarball(version, folder = ".")
      version =~ /^\d+\.\d+\.\d+$/ or raise "Wrong version format! Received #{version.inspect}"
      url = TARBALL_URL.gsub(/:version/, version)
      puts "Fetching #{version}"
      cmd = %{wget #{url} -nc}
      Dir.chdir(folder) do 
        system("#{cmd}")
      end
    end
    
  end
end

if $0 == __FILE__
  
  include Nginx::Fetch
  
  fetch_versions.each do |v|
    fetch_tarball(v, File.dirname(__FILE__))
  end
  
end
