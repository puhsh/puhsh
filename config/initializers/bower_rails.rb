BowerRails.configure do |bower_rails|
  bower_rails.install_before_precompile = true # invokes rake bower:install before precompilation
  bower_rails.clean_before_precompile = true   # invokes rake bower:clean before precompilation
end
