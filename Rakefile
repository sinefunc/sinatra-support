task(:test) {
  Dir['./test/**/test_*.rb'].each { |f| load f }
}

namespace :doc do
  task :update do
    system "yard"
  end

  task :deploy => :update do
    # http://github.com/rstacruz/git-update-ghpages
    repo = env['REPO'] || "sinefunc/sinatra-support"
    system "git update-ghpages -i doc #{repo}"
  end
end
