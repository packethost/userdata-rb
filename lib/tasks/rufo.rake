begin
  require "rufo"
  desc "Run rufo"
  task(:rufo) { sh "rufo -c . config.ru" }
rescue LoadError; end
